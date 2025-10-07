import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  final AuthService _authService = AuthService();

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _clearUserData();
    await _loadUserFromStorage();
  }

  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
    } catch (e) {
      // Ignore errors when clearing data
    }
  }

  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      // Don't load any user data - start fresh
      _user = null;
      print('AuthProvider: _user is null, isAuthenticated: ${_user != null}');
    } catch (e) {
      _error = e.toString();
      _user = null;
      print('AuthProvider: Error loading user, _user is null, isAuthenticated: ${_user != null}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signIn(email, password);
      if (result['success']) {
        _user = User.fromJson(result['user']);
        await _saveUserToStorage();
        return true;
      } else {
        _error = result['message'];
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String name, String email, String password, String phone) async {
    print('AuthProvider: signUp called with name=$name, email=$email, phone=$phone');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signUp(name, email, password, phone);
      print('AuthProvider: signUp result: $result');
      if (result['success']) {
        _user = User.fromJson(result['user']);
        await _saveUserToStorage();
        print('AuthProvider: signUp successful, user saved');
        return true;
      } else {
        _error = result['message'];
        print('AuthProvider: signUp failed: ${result['message']}');
        return false;
      }
    } catch (e) {
      _error = e.toString();
      print('AuthProvider: signUp error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _user = null;
    _error = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    
    notifyListeners();
  }

  Future<void> _saveUserToStorage() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _user!.toJson().toString());
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String bio,
    File? profileImage,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      if (_user != null) {
        // Update user data
        _user = User(
          id: _user!.id,
          name: name,
          email: email,
          phone: phone,
          bio: bio,
          profileImage: profileImage?.path ?? _user!.profileImage,
          createdAt: _user!.createdAt,
        );

        // Save to storage
        await _saveUserToStorage();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would validate the current password
      // and update it via API call
      print('Password changed successfully');
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
