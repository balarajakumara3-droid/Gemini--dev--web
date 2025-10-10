import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  // In a real app, this would make HTTP requests to your backend
  // For now, we'll simulate the authentication with local storage
  
  static const String _usersKey = 'registered_users';

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      // Check registered users first
      if (usersJson != null && usersJson.isNotEmpty) {
        final List<dynamic> users = json.decode(usersJson);
        
        for (var userMap in users) {
          if (userMap['email'] == email && userMap['password'] == password) {
            // Remove password before returning
            final userCopy = Map<String, dynamic>.from(userMap);
            userCopy.remove('password');
            
            return {
              'success': true,
              'user': userCopy
            };
          }
        }
      }
      
      // Fallback to test account
      if (email == 'test@example.com' && password == 'password') {
        return {
          'success': true,
          'user': {
            'id': '1',
            'name': 'John Doe',
            'email': email,
            'phone': '+1234567890',
            'profileImage': '',
            'createdAt': DateTime.now().toIso8601String(),
            'isVerified': true,
            'preferences': [],
            'bio': 'Real estate enthusiast'
          }
        };
      }
      
      return {
        'success': false,
        'message': 'Invalid email or password'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error signing in: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password, String phone) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      if (email.isEmpty || password.length < 6) {
        return {
          'success': false,
          'message': 'Invalid registration data'
        };
      }

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      List<dynamic> users = [];
      if (usersJson != null && usersJson.isNotEmpty) {
        users = json.decode(usersJson);
        
        // Check if email already exists
        for (var user in users) {
          if (user['email'] == email) {
            return {
              'success': false,
              'message': 'Email already registered'
            };
          }
        }
      }
      
      // Create new user with password stored
      final newUser = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'email': email,
        'password': password, // Store password for sign-in verification
        'phone': phone,
        'profileImage': '',
        'createdAt': DateTime.now().toIso8601String(),
        'isVerified': false,
        'preferences': [],
        'bio': null
      };
      
      users.add(newUser);
      await prefs.setString(_usersKey, json.encode(users));
      
      // Return user without password
      final userResponse = Map<String, dynamic>.from(newUser);
      userResponse.remove('password');
      
      return {
        'success': true,
        'user': userResponse
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error registering: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return {
      'success': true,
      'message': 'Password reset link sent to your email'
    };
  }
}

