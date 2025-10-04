import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../../../core/models/user.dart' show User, Address;

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final supa.SupabaseClient _supabase = supa.Supabase.instance.client;

  AuthState _state = AuthState.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;

  // Initialize authentication state
  Future<void> initialize() async {
    try {
      _state = AuthState.loading;
      
      // Check if user is stored in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final userEmail = prefs.getString('user_email');
      final userName = prefs.getString('user_name');
      
      AuthState nextState;
      if (userId != null && userEmail != null) {
        _user = User(
          id: userId,
          email: userEmail,
          name: userName ?? '',
          phoneNumber: prefs.getString('user_phone'),
          profileImage: '',
          addresses: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        nextState = AuthState.authenticated;
      } else {
        nextState = AuthState.unauthenticated;
      }
      
      // Defer state change to avoid notifying during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _state = nextState;
        notifyListeners();
      });
      
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      
      // Defer notification to avoid build-time issues
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Login with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Query app_users table
      final response = await _supabase
          .from('app_users')
          .select()
          .eq('email', email)
          .eq('password', password) // In production, hash the password
          .single();

      if (response != null) {
        // Create user object
        _user = User(
          id: response['id'].toString(),
          email: response['email'],
          name: response['full_name'] ?? '',
          phoneNumber: response['phone'],
          profileImage: '',
          addresses: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', _user!.id);
        await prefs.setString('user_email', _user!.email);
        await prefs.setString('user_name', _user!.name);
        if (_user!.phoneNumber != null) {
          await prefs.setString('user_phone', _user!.phoneNumber!);
        }

        _state = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _setError('Invalid email or password');
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Insert into app_users table
      final response = await _supabase
          .from('app_users')
          .insert({
            'email': email,
            'password': password, // In production, hash the password
            'full_name': fullName,
            'phone': phoneNumber ?? '',
          })
          .select()
          .single();

      if (response != null) {
        // Create user object
        _user = User(
          id: response['id'].toString(),
          email: response['email'],
          name: response['full_name'] ?? '',
          phoneNumber: response['phone'],
          profileImage: '',
          addresses: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', _user!.id);
        await prefs.setString('user_email', _user!.email);
        await prefs.setString('user_name', _user!.name);
        if (_user!.phoneNumber != null) {
          await prefs.setString('user_phone', _user!.phoneNumber!);
        }

        _state = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _setError('Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out (logout)
  Future<void> signOut() async {
    try {
      _setLoading(true);
      
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_phone');

      _user = null;
      _state = AuthState.unauthenticated;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Alias for signOut to match existing code
  Future<void> logout() async {
    await signOut();
  }

  // Send OTP to phone number
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      _setLoading(true);
      _clearError();

      // Format phone number to ensure it has country code
      String formattedPhone = phoneNumber;
      if (!phoneNumber.startsWith('+')) {
        // Assume Indian number if no country code
        formattedPhone = '+91$phoneNumber';
      }

      // Try to send OTP for existing users only
      await _supabase.auth.signInWithOtp(
        phone: formattedPhone,
        shouldCreateUser: false, // Don't create user automatically
      );
      
      print('OTP sent successfully to $formattedPhone!');
      return true;
    } catch (e) {
      print('OTP send error: $e');
      
      // Handle specific error cases
      if (e.toString().contains('otp_disabled') || e.toString().contains('Signups not allowed')) {
        _setError('OTP authentication is not enabled. Please use email login or contact support.');
      } else if (e.toString().contains('User not found')) {
        _setError('Phone number not registered. Please register first or use email login.');
      } else {
        _setError('Failed to send OTP: ${e.toString()}');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP and sign in
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    try {
      // Format phone number to ensure it has country code
      String formattedPhone = phoneNumber;
      if (!phoneNumber.startsWith('+')) {
        // Assume Indian number if no country code
        formattedPhone = '+91$phoneNumber';
      }

      final response = await _supabase.auth.verifyOTP(
        phone: formattedPhone,
        token: otp,
        type: supa.OtpType.sms,
      );

      if (response.user != null) {
        print('Login successful for ${response.user!.phone}');
        
        // Create user object and save to SharedPreferences
        _user = User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          name: response.user!.userMetadata?['full_name'] ?? '',
          phoneNumber: response.user!.phone ?? formattedPhone,
          profileImage: response.user!.userMetadata?['avatar_url'] ?? '',
          addresses: [],
          createdAt: response.user!.createdAt != null 
              ? DateTime.parse(response.user!.createdAt!) 
              : DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', _user!.id);
        await prefs.setString('user_email', _user!.email);
        await prefs.setString('user_name', _user!.name);
        if (_user!.phoneNumber != null) {
          await prefs.setString('user_phone', _user!.phoneNumber!);
        }

        _state = AuthState.authenticated;
        notifyListeners();
      }
    } catch (e) {
      print('OTP verification error: $e');
      _setError('OTP verification failed: ${e.toString()}');
    }
  }

  // Placeholder methods for compatibility
  Future<bool> loginWithGoogle() async {
    _setError('Google login not implemented');
    return false;
  }

  Future<bool> loginWithApple() async {
    _setError('Apple login not implemented');
    return false;
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}