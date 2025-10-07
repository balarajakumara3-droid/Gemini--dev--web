import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// Example class demonstrating how to fetch data from Supabase
class DataFetcher {
  final SupabaseService _supabaseService = SupabaseService();

  /// Example function to fetch products data - matches your exact usage
  Future<void> fetchData() async {
    try {
      // This matches your exact code pattern:
      // final response = await supabase.from('products').select().limit(20).execute();
      List<Map<String, dynamic>> products = await _supabaseService.getTableData('products');
      debugPrint('Fetched ${products.length} products:');
      for (var product in products) {
        debugPrint('Product: ${product['name']} - ₹${product['price']}');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  /// Example function to fetch products with custom limit
  Future<void> fetchProductsWithLimit(int limit) async {
    try {
      List<Map<String, dynamic>> products = await _supabaseService.getTableDataWithLimit('products', limit);
      debugPrint('Fetched ${products.length} products (limit: $limit):');
      for (var product in products) {
        debugPrint('Product: ${product['name']} - ₹${product['price']}');
      }
    } catch (e) {
      debugPrint('Error fetching products with limit: $e');
    }
  }

  /// Example function to search products
  Future<void> searchProducts(String query) async {
    try {
      List<Map<String, dynamic>> results = await _supabaseService.searchTableData(
        'products', 
        query, 
        ['name', 'description', 'category', 'ingredients']
      );
      debugPrint('Found ${results.length} products matching "$query":');
      for (var product in results) {
        debugPrint('Product: ${product['name']} - ₹${product['price']}');
      }
    } catch (e) {
      debugPrint('Error searching products: $e');
    }
  }

  /// Example function to fetch any table data
  Future<void> fetchTableData(String tableName) async {
    try {
      List<Map<String, dynamic>> data = await _supabaseService.getTableData(tableName);
      debugPrint('Fetched ${data.length} records from $tableName:');
      for (var record in data) {
        debugPrint('Record: $record');
      }
    } catch (e) {
      debugPrint('Error fetching data from $tableName: $e');
    }
  }

  /// Direct Supabase client usage - matches your exact pattern
  Future<void> fetchDataDirectly() async {
    try {
      // This is your exact code pattern:
      final supabase = Supabase.instance.client;
      final response = await supabase.from('products').select().limit(20);
      
      debugPrint('Direct fetch: ${response.length} products');
      for (var product in response) {
        debugPrint('Product: ${product['name']} - ₹${product['price']}');
      }
    } catch (e) {
      debugPrint('Error with direct Supabase call: $e');
    }
  }
}
