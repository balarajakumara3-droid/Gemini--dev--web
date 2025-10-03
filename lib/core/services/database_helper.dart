import 'package:flutter/foundation.dart';
import 'supabase_service.dart';

/// Helper class for common database operations
class DatabaseHelper {
  final SupabaseService _supabaseService = SupabaseService();

  /// Get products data using the generic method
  Future<List<Map<String, dynamic>>> getProducts({int limit = 20}) async {
    return await _supabaseService.getTableDataWithLimit('products', limit);
  }

  /// Search products using the generic search method
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    return await _supabaseService.searchTableData(
      'products', 
      query, 
      ['name', 'description', 'category', 'ingredients']
    );
  }

  /// Get restaurants data using the generic method
  Future<List<Map<String, dynamic>>> getRestaurants({int limit = 20}) async {
    return await _supabaseService.getTableDataWithLimit('restaurants', limit);
  }

  /// Search restaurants using the generic search method
  Future<List<Map<String, dynamic>>> searchRestaurants(String query) async {
    return await _supabaseService.searchTableData(
      'restaurants', 
      query, 
      ['name', 'cuisine', 'address']
    );
  }

  /// Get any table data with custom limit
  Future<List<Map<String, dynamic>>> getTableData(String tableName, {int limit = 20}) async {
    return await _supabaseService.getTableDataWithLimit(tableName, limit);
  }

  /// Search any table with custom columns
  Future<List<Map<String, dynamic>>> searchTable(
    String tableName, 
    String query, 
    List<String> searchColumns
  ) async {
    return await _supabaseService.searchTableData(tableName, query, searchColumns);
  }

  /// Get table count
  Future<int> getTableCount(String tableName) async {
    try {
      final data = await _supabaseService.client
          .from(tableName)
          .select('id', const FetchOptions(count: CountOption.exact));
      
      return data.length;
    } catch (e) {
      debugPrint('Error getting count for table $tableName: $e');
      return 0;
    }
  }

  /// Check if table exists and has data
  Future<bool> tableExistsAndHasData(String tableName) async {
    try {
      final count = await getTableCount(tableName);
      return count > 0;
    } catch (e) {
      debugPrint('Error checking if table $tableName exists: $e');
      return false;
    }
  }
}
