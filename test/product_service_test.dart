import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_delivery_app/core/services/product_service.dart';

void main() {
  group('ProductService Tests', () {
    late ProductService productService;
    late SupabaseClient supabase;

    setUpAll(() async {
      // Initialize Supabase if not already initialized
      try {
        await Supabase.initialize(
          url: 'https://jndmejkpnefigtjpbzmn.supabase.co',
          anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpuZG1lamtwbmVmaWd0anBiem1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMjMzNTgsImV4cCI6MjA3NDY5OTM1OH0.u7cVWlEx8SKzNboAxDc7XPdV0XZ4YBwmWSQjSM_2Z1k',
        );
      } catch (e) {
        // Already initialized
      }
      productService = ProductService();
      supabase = Supabase.instance.client;
    });

    test('Should fetch products from Supabase', () async {
      // First check if we can connect to Supabase and get a count
      final countResponse = await supabase
          .from('products')
          .select('id', const FetchOptions(count: CountOption.exact));
      
      final count = countResponse.count ?? 0;
      print('Total products in database: $count');
      
      // Try to fetch products
      final products = await productService.getAllProducts();
      print('Products fetched: ${products.length}');
      
      // Print first few products to see what's in them
      for (int i = 0; i < products.length && i < 3; i++) {
        print('Product $i: ${products[i]}');
      }
      
      expect(products, isA<List<Map<String, dynamic>>>());
    });
  });
}