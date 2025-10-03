import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get all products
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      debugPrint('Fetching all products from Supabase...');
      final response = await _supabase
          .from('products')
          .select('*')
          .order('name');
      
      debugPrint('Supabase response type: ${response.runtimeType}');
      debugPrint('Supabase response length: ${response.length}');
      
      // Handle the case where response might not be a List
      List<dynamic> rawData;
      if (response is List) {
        rawData = response;
      } else if (response is PostgrestResponse) {
        rawData = response.data as List;
      } else {
        debugPrint('Unexpected response type: ${response.runtimeType}');
        return [];
      }
      
      debugPrint('Raw data length: ${rawData.length}');
      
      // Products table shape mapping (pass-through with defaults)
      final result = <Map<String, dynamic>>[];
      for (var item in rawData) {
        if (item is Map<String, dynamic>) {
          result.add({
            'id': item['id']?.toString() ?? '',
            'name': item['name'] ?? 'Unknown Item',
            'description': item['description'] ?? '',
            'price': (item['price'] is num) ? (item['price'] as num).toDouble() : 0.0,
            'image_url': item['image_url'],
            'category': item['category'],
            'is_available': item['is_available'] ?? true,
            'rating': (item['rating'] is num) ? (item['rating'] as num).toDouble() : 0.0,
            'preparation_time': item['preparation_time'] ?? 0,
            'calories': item['calories'] ?? 0,
            'created_at': item['created_at'],
          });
        }
      }
      
      debugPrint('Converted result length: ${result.length}');
      return result;
    } catch (e, stackTrace) {
      debugPrint('Error fetching products: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get products by category (restaurant name)
  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .eq('category', category)
          .order('name');
      
      // Handle the case where response might not be a List
      List<dynamic> rawData;
      if (response is List) {
        rawData = response;
      } else if (response is PostgrestResponse) {
        rawData = response.data as List;
      } else {
        debugPrint('Unexpected response type: ${response.runtimeType}');
        return [];
      }
      
      // Products table shape mapping
      final result = <Map<String, dynamic>>[];
      for (var item in rawData) {
        if (item is Map<String, dynamic>) {
          result.add({
            'id': item['id']?.toString() ?? '',
            'name': item['name'] ?? 'Unknown Item',
            'description': item['description'] ?? '',
            'price': (item['price'] is num) ? (item['price'] as num).toDouble() : 0.0,
            'image_url': item['image_url'],
            'category': item['category'],
            'is_available': item['is_available'] ?? true,
            'rating': (item['rating'] is num) ? (item['rating'] as num).toDouble() : 0.0,
            'preparation_time': item['preparation_time'] ?? 0,
            'calories': item['calories'] ?? 0,
            'created_at': item['created_at'],
          });
        }
      }
      
      return result;
    } catch (e) {
      debugPrint('Error fetching products by category: $e');
      return [];
    }
  }

  /// Search products by name or description
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('name');
      
      // Handle the case where response might not be a List
      List<dynamic> rawData;
      if (response is List) {
        rawData = response;
      } else if (response is PostgrestResponse) {
        rawData = response.data as List;
      } else {
        debugPrint('Unexpected response type: ${response.runtimeType}');
        return [];
      }
      
      // Products table shape mapping
      final result = <Map<String, dynamic>>[];
      for (var item in rawData) {
        if (item is Map<String, dynamic>) {
          result.add({
            'id': item['id']?.toString() ?? '',
            'name': item['name'] ?? 'Unknown Item',
            'description': item['description'] ?? '',
            'price': (item['price'] is num) ? (item['price'] as num).toDouble() : 0.0,
            'image_url': item['image_url'],
            'category': item['category'],
            'is_available': item['is_available'] ?? true,
            'rating': (item['rating'] is num) ? (item['rating'] as num).toDouble() : 0.0,
            'preparation_time': item['preparation_time'] ?? 0,
            'calories': item['calories'] ?? 0,
            'created_at': item['created_at'],
          });
        }
      }
      
      return result;
    } catch (e) {
      debugPrint('Error searching products: $e');
      return [];
    }
  }

  /// Get all unique categories (restaurant names)
  Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from('products')
          .select('category')
          .not('category', 'is', null);
      
      // Handle the case where response might not be a List
      List<dynamic> rawData;
      if (response is List) {
        rawData = response;
      } else if (response is PostgrestResponse) {
        rawData = response.data as List;
      } else {
        debugPrint('Unexpected response type: ${response.runtimeType}');
        return [];
      }
      
      final categories = <String>{};
      for (var row in rawData) {
        String? restaurantName;
        if (row is Map<String, dynamic>) {
          restaurantName = row['category'] as String?;
        }
        if (restaurantName != null && restaurantName.isNotEmpty) {
          categories.add(restaurantName);
        }
      }
      return categories.toList()..sort();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  /// Get product by ID
  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*')
          .eq('id', id)
          .single();
      
      if (response is Map<String, dynamic>) {
        return {
          'id': response['id']?.toString() ?? '',
          'name': response['name'] ?? 'Unknown Item',
          'description': response['description'] ?? '',
          'price': (response['price'] is num) ? (response['price'] as num).toDouble() : 0.0,
          'image_url': response['image_url'],
          'category': response['category'],
          'is_available': response['is_available'] ?? true,
          'rating': (response['rating'] is num) ? (response['rating'] as num).toDouble() : 0.0,
          'preparation_time': response['preparation_time'] ?? 0,
          'calories': response['calories'] ?? 0,
          'created_at': response['created_at'],
        };
      } else if (response is PostgrestResponse) {
        final data = response.data as Map<String, dynamic>;
        return {
          'id': data['id']?.toString() ?? '',
          'name': data['name'] ?? 'Unknown Item',
          'description': data['description'] ?? '',
          'price': (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
          'image_url': data['image_url'],
          'category': data['category'],
          'is_available': data['is_available'] ?? true,
          'rating': (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0.0,
          'preparation_time': data['preparation_time'] ?? 0,
          'calories': data['calories'] ?? 0,
          'created_at': data['created_at'],
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching product by ID: $e');
      return null;
    }
  }

  /// Add a new product
  Future<bool> addProduct({
    required String name,
    required double price,
    String? imageUrl,
    String? description,
    String? category,
    bool isAvailable = true,
    double rating = 0.0,
    int preparationTime = 15,
    String? ingredients,
    int calories = 0,
  }) async {
    try {
      await _supabase.from('products').insert({
        'name': name,
        'price': price,
        'image_url': imageUrl,
        'description': description,
        'category': category,
        'is_available': isAvailable,
        'rating': rating,
        'preparation_time': preparationTime,
        'ingredients': ingredients,
        'calories': calories,
      });
      return true;
    } catch (e) {
      debugPrint('Error adding product: $e');
      return false;
    }
  }

  /// Update a product
  Future<bool> updateProduct(String id, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('products')
          .update(updates)
          .eq('id', id);
      return true;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }

  /// Delete a product
  Future<bool> deleteProduct(String id) async {
    try {
      await _supabase
          .from('products')
          .delete()
          .eq('id', id);
      return true;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }
  
  /// Debug function to check the connection and data
  Future<void> debugConnection() async {
    try {
      debugPrint('Testing Supabase connection...');
      
      // Check if we can get a count
      final countResponse = await _supabase
          .from('products')
          .select('*', const FetchOptions(count: CountOption.exact));
      
      int count = 0;
      if (countResponse is PostgrestResponse) {
        count = countResponse.count ?? 0;
      } else if (countResponse is List) {
        count = countResponse.length;
      }
      
      debugPrint('Total products in database: $count');
      
      // Try to fetch a few products
      final response = await _supabase
          .from('products')
          .select('*')
          .limit(5)
          .order('name');
      
      debugPrint('Fetched response type: ${response.runtimeType}');
      int responseLength = 0;
      if (response is List) {
        responseLength = response.length;
      } else if (response is PostgrestResponse) {
        responseLength = response.data.length;
      }
      
      debugPrint('Fetched $responseLength products');
    } catch (e, stackTrace) {
      debugPrint('Error in debugConnection: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}