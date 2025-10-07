class AuthService {
  // In a real app, this would make HTTP requests to your backend
  // For now, we'll simulate the authentication

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock authentication logic
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
    } else {
      return {
        'success': false,
        'message': 'Invalid email or password'
      };
    }
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password, String phone) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock registration logic
    if (email.isNotEmpty && password.length >= 6) {
      return {
        'success': true,
        'user': {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': name,
          'email': email,
          'phone': phone,
          'profileImage': '',
          'createdAt': DateTime.now().toIso8601String(),
          'isVerified': false,
          'preferences': [],
          'bio': null
        }
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid registration data'
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

