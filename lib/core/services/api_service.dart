import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../models/restaurant.dart';
import '../models/order.dart';
import '../models/user.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => 'ApiException: $message';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _authToken;

  Future<void> initialize() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: AppConfig.requestTimeout),
        receiveTimeout: const Duration(seconds: AppConfig.requestTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
    
    // Load existing auth token
    await loadAuthToken();
  }

  // Authentication methods
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  // Auth API calls
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      await setAuthToken(data['token']);
      return User.fromJson(data['user']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
        },
      );

      final data = response.data;
      await setAuthToken(data['token']);
      return User.fromJson(data['user']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await clearAuthToken();
    }
  }

  // Restaurant API calls
  Future<List<Restaurant>> getRestaurants({
    double? latitude,
    double? longitude,
    String? category,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (category != null) 'category': category,
        if (sortBy != null) 'sort_by': sortBy,
      };

      final response = await _dio.get(
        AppConfig.restaurantsEndpoint,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['restaurants'] ?? response.data;
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Restaurant> getRestaurantDetails(String restaurantId) async {
    try {
      final response = await _dio.get('${AppConfig.restaurantsEndpoint}/$restaurantId');
      return Restaurant.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<FoodCategory>> getRestaurantMenu(String restaurantId) async {
    try {
      final response = await _dio.get(
        AppConfig.menuEndpoint.replaceAll('{id}', restaurantId),
      );

      final List<dynamic> data = response.data['menu'] ?? response.data;
      return data.map((json) => FoodCategory.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Search API calls
  Future<List<Restaurant>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    String? category,
    String? cuisine,
    double? minRating,
    double? maxDeliveryTime,
    bool? isVegetarian,
  }) async {
    try {
      final queryParams = {
        'q': query,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (category != null) 'category': category,
        if (cuisine != null) 'cuisine': cuisine,
        if (minRating != null) 'min_rating': minRating,
        if (maxDeliveryTime != null) 'max_delivery_time': maxDeliveryTime,
        if (isVegetarian != null) 'is_vegetarian': isVegetarian,
      };

      final response = await _dio.get(
        AppConfig.searchEndpoint,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['restaurants'] ?? response.data;
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Order API calls
  Future<Order> createOrder(Order order) async {
    try {
      final response = await _dio.post(
        AppConfig.ordersEndpoint,
        data: order.toJson(),
      );

      return Order.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Order>> getOrders({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        AppConfig.ordersEndpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['orders'] ?? response.data;
      return data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Order> getOrderDetails(String orderId) async {
    try {
      final response = await _dio.get('${AppConfig.ordersEndpoint}/$orderId');
      return Order.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Order> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final response = await _dio.patch(
        '${AppConfig.ordersEndpoint}/$orderId/status',
        data: {
          'status': status.name,
        },
      );

      return Order.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _dio.patch(
        '${AppConfig.ordersEndpoint}/$orderId/cancel',
        data: {
          'reason': reason,
        },
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // User profile API calls
  Future<User> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateUserProfile(User user) async {
    try {
      final response = await _dio.put(
        '/user/profile',
        data: user.toJson(),
      );

      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Address>> getUserAddresses() async {
    try {
      final response = await _dio.get('/user/addresses');
      final List<dynamic> data = response.data['addresses'] ?? response.data;
      return data.map((json) => Address.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Address> addUserAddress(Address address) async {
    try {
      final response = await _dio.post(
        '/user/addresses',
        data: address.toJson(),
      );

      return Address.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteUserAddress(String addressId) async {
    try {
      await _dio.delete('/user/addresses/$addressId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Interceptors
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        handler.next(options);
      },
    );
  }

  Interceptor _createLoggingInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
      error: true,
      logPrint: (obj) {
        // Only log in debug mode
        assert(() {
          print(obj);
          return true;
        }());
      },
    );
  }

  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired, clear it
          clearAuthToken();
        }
        handler.next(error);
      },
    );
  }

  // Error handling
  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(
            message: 'Connection timeout. Please check your internet connection.',
            statusCode: 408,
          );
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          String message = 'An error occurred';
          
          try {
            final responseData = error.response?.data;
            if (responseData is Map<String, dynamic>) {
              message = responseData['message'] ?? 
                       responseData['error'] ?? 
                       responseData['detail'] ?? 
                       'An error occurred';
            } else if (responseData is String) {
              message = responseData;
            }
          } catch (e) {
            // If parsing fails, use default message
            message = 'An error occurred';
          }
          
          final errorCode = error.response?.data?['code'];
          
          return ApiException(
            message: message,
            statusCode: statusCode,
            errorCode: errorCode,
          );
        case DioExceptionType.cancel:
          return ApiException(message: 'Request was cancelled');
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return ApiException(
              message: 'No internet connection. Please check your network.',
            );
          }
          return ApiException(message: 'An unknown error occurred');
        default:
          return ApiException(message: 'An error occurred');
      }
    }
    
    return ApiException(message: error.toString());
  }
}