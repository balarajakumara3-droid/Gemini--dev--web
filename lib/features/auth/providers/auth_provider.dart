import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/user.dart' show User, Address;
import '../../../core/services/supabase_service.dart';
import '../../../core/services/database_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final DatabaseService _databaseService = DatabaseService();
  StreamSubscription<supa.AuthState>? _authSubscription;

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
      // Avoid notifying listeners during widget build; defer state change
      _state = AuthState.loading;
      
      // Check if user is already authenticated with Supabase
      final client = supa.Supabase.instance.client;
      final session = client.auth.currentSession;
      
      AuthState nextState;
      if (session?.user != null) {
        _user = _userFromSupabase(session!.user);
        nextState = AuthState.authenticated;
      } else {
        nextState = AuthState.unauthenticated;
      }

      // Notify after the first frame to avoid build-phase updates
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setState(nextState);
      });

      // Subscribe to Supabase auth state changes so OAuth redirects are handled
      _authSubscription ??= supa.Supabase.instance.client.auth
          .onAuthStateChange
          .listen((supa.AuthState authState) {
        final event = authState.event;
        final session = authState.session;

        if (event == supa.AuthChangeEvent.signedIn && session?.user != null) {
          _user = _userFromSupabase(session!.user);
          _setState(AuthState.authenticated);
        }

        if (event == supa.AuthChangeEvent.signedOut) {
          _user = null;
          _setState(AuthState.unauthenticated);
        }
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setError('Failed to initialize authentication');
      });
    }
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      // Supabase password login
      final client = supa.Supabase.instance.client;
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      debugPrint('auth: signed in userId: ${client.auth.currentSession?.user?.id}');

      final authUser = response.user ?? client.auth.currentUser;
      if (authUser == null) {
        _setError('Invalid email or password');
        return false;
      }

      _user = _userFromSupabase(authUser);

      // Save user data locally
      await _saveUserData();

      _setState(AuthState.authenticated);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Use Supabase Auth for registration
      final client = supa.Supabase.instance.client;

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{
          'full_name': name,
          if (phoneNumber != null) 'phone': phoneNumber,
        },
      );

      debugPrint('auth: signed up userId: ${client.auth.currentUser?.id}');

      final authUser = response.user ?? client.auth.currentUser;
      if (authUser == null) {
        _setError('Signup failed');
        return false;
      }

      // Optionally upsert to profiles table
      try {
        await client.from('users').upsert({
          'id': authUser.id,
          'full_name': name,
          'phone': phoneNumber,
          'avatar_url': null,
        });
      } catch (_) {
        // Non-fatal if profiles table or policy not set yet
      }

      _user = _userFromSupabase(authUser);

      // Save user data locally
      await _saveUserData();

      _setState(AuthState.authenticated);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login with phone number (OTP-based)
  Future<bool> loginWithPhone(String phoneNumber) async {
    try {
      _setLoading(true);
      _clearError();

      // Implementation depends on your OTP service
      // This is a placeholder for OTP-based authentication
      
      // For now, simulate successful login
      await Future.delayed(const Duration(seconds: 2));
      
      // In real implementation, you would:
      // 1. Send OTP to phone number
      // 2. Verify OTP
      // 3. Get user data from server
      
      _setError('Phone login not implemented yet');
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP for phone login
  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    try {
      _setLoading(true);
      _clearError();

      // Placeholder for OTP verification
      await Future.delayed(const Duration(seconds: 1));
      
      _setError('OTP verification not implemented yet');
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _setLoading(true);
      // Sign out from Supabase session
      try {
        await supa.Supabase.instance.client.auth.signOut();
      } catch (_) {
        // ignore network errors during sign-out; continue local cleanup
      }
      
      // Clear local data
      await _clearUserData();
      
      _user = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      // Continue with logout even if API call fails
      await _clearUserData();
      _user = null;
      _setState(AuthState.unauthenticated);
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  // Update user profile
  Future<bool> updateProfile(User updatedUser) async {
    try {
      _setLoading(true);
      _clearError();

      // Update profile in Supabase
      final client = supa.Supabase.instance.client;
      await client.from('users').upsert({
        'id': updatedUser.id,
        'full_name': updatedUser.name,
        'phone': updatedUser.phoneNumber,
        'avatar_url': updatedUser.profileImage,
      });

      _user = updatedUser;
      await _saveUserData();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // API call to change password
      // Implementation depends on your backend
      
      await Future.delayed(const Duration(seconds: 1));
      _setError('Password change not implemented yet');
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      // API call to send password reset email
      // Implementation depends on your backend
      
      await Future.delayed(const Duration(seconds: 1));
      _setError('Password reset not implemented yet');
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Social login methods
  Future<bool> loginWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      if (kIsWeb) {
        final client = supa.Supabase.instance.client;
        await client.auth.signInWithOAuth(
          supa.OAuthProvider.google,
          redirectTo: null,
        );
        final user = client.auth.currentUser;
        if (user == null) {
          _setError('Google login was cancelled or failed');
          return false;
        }
        _user = _userFromSupabase(user);
        _setState(AuthState.authenticated);
        return true;
      }

      // Check if running on iOS simulator - Google Sign-In may not work properly
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // For development purposes, show error instead of mock user
        if (kDebugMode) {
          _setError('Google Sign-In not available in simulator. Use a real device for testing.');
          return false;
        }
      }

      // Native Google Sign-In (iOS/Android) for real devices
      final googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );
      
      final account = await googleSignIn.signIn();
      if (account == null) {
        _setError('Google login was cancelled');
        return false;
      }
      
      final auth = await account.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;
      
      if (idToken == null) {
        _setError('Failed to obtain Google ID token');
        return false;
      }

      final client = supa.Supabase.instance.client;
      final response = await client.auth.signInWithIdToken(
        provider: supa.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final authUser = response.user ?? client.auth.currentUser;
      if (authUser == null) {
        _setError('Google login failed at Supabase');
        return false;
      }
      _user = _userFromSupabase(authUser);
      _setState(AuthState.authenticated);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithApple() async {
    try {
      _setLoading(true);
      _clearError();

      final client = supa.Supabase.instance.client;
      await client.auth.signInWithOAuth(
        supa.OAuthProvider.apple,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://login-callback/',
      );

      final session = client.auth.currentSession;
      final authUser = session?.user ?? client.auth.currentUser;

      if (authUser == null) {
        _setError('Apple login was cancelled or failed');
        return false;
      }

      _user = _userFromSupabase(authUser);
      _setState(AuthState.authenticated);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithFacebook() async {
    try {
      _setLoading(true);
      _clearError();

      // Implementation for Facebook Login
      await Future.delayed(const Duration(seconds: 2));
      _setError('Facebook login not implemented yet');
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

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
    if (_state == AuthState.error) {
      _state = _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    }
  }

  Future<void> _saveUserData() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _user!.id);
      await prefs.setString('user_name', _user!.name);
      await prefs.setString('user_email', _user!.email);
      if (_user!.phoneNumber != null) {
        await prefs.setString('user_phone', _user!.phoneNumber!);
      }
    }
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    
    // Clear user-specific database data
    if (_user != null) {
      await _databaseService.clearUserData(_user!.id);
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is supa.AuthException) {
      return error.message;
    }
    return error.toString();
  }

  User _userFromSupabase(supa.User authUser) {
    final name = (authUser.userMetadata?['full_name'] as String?)
        ?? (authUser.userMetadata?['name'] as String?)
        ?? authUser.email?.split('@').first
        ?? 'User';
    final avatar = authUser.userMetadata?['avatar_url'] as String?;

    return User(
      id: authUser.id,
      name: name,
      email: authUser.email ?? '',
      profileImage: avatar,
      addresses: const [],
      createdAt: _coerceToDateTime(authUser.createdAt),
      updatedAt: DateTime.now(),
    );
  }

  DateTime _coerceToDateTime(Object? value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  // Address management methods
  Future<List<Address>> getUserAddresses() async {
    if (_user == null) return [];
    
    try {
      // Get addresses from Supabase
      final client = supa.Supabase.instance.client;
      final response = await client
          .from('addresses')
          .select()
          .eq('user_id', _user!.id);
      
      final addresses = response.map((data) => Address.fromJson(data)).toList();
      
      // Cache locally
      for (final address in addresses) {
        await _databaseService.saveUserAddress(address, _user!.id);
      }
      
      return addresses;
    } catch (e) {
      // Fallback to local cache
      return await _databaseService.getUserAddresses(_user!.id);
    }
  }

  Future<bool> addAddress(Address address) async {
    if (_user == null) return false;
    
    try {
      // Add address to Supabase
      final client = supa.Supabase.instance.client;
      final response = await client
          .from('addresses')
          .insert({
            'user_id': _user!.id,
            'title': address.title,
            'address_line_1': address.addressLine1,
            'address_line_2': address.addressLine2,
            'city': address.city,
            'state': address.state,
            'pincode': address.pincode,
            'country': address.country,
            'is_default': address.isDefault,
          })
          .select()
          .single();
      
      final newAddress = Address.fromJson(response);
      await _databaseService.saveUserAddress(newAddress, _user!.id);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    if (_user == null) return false;
    
    try {
      // Delete address from Supabase
      final client = supa.Supabase.instance.client;
      await client
          .from('addresses')
          .delete()
          .eq('id', addressId)
          .eq('user_id', _user!.id);
      
      await _databaseService.deleteUserAddress(addressId);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    }
  }
}