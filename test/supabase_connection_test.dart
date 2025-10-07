import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_delivery_app/core/services/product_service.dart';

void main() {
  group('Supabase Connection Test', () {
    late ProductService productService;
    
    setUp(() {
      productService = ProductService();
    });

    test('Test product fetching', () async {
      // This test will help us understand what's happening with the data
      print('Testing product fetching...');
      
      try {
        final products = await productService.getAllProducts();
        print('Products fetched: ${products.length}');
        
        // Print details of first few products
        for (int i = 0; i < products.length && i < 3; i++) {
          print('Product $i: ${products[i]}');
        }
      } catch (e) {
        print('Error fetching products: $e');
        rethrow;
      }
    });
  });
}