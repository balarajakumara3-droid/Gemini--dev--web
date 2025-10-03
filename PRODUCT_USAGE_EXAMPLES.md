# Product Usage Examples

This guide shows you how to use the products table in your Flutter app with Supabase.

## 1. Direct Supabase Query (Your Exact Code)

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

// Your exact query
final response = await supabase.from('products').select().limit(20);
```

## 2. Complete Example with Error Handling

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductListExample extends StatefulWidget {
  @override
  _ProductListExampleState createState() => _ProductListExampleState();
}

class _ProductListExampleState extends State<ProductListExample> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Your exact query
      final response = await supabase.from('products').select().limit(20);
      
      setState(() {
        products = List<Map<String, dynamic>>.from(response as List);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: _loadProducts,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(child: Text('No products found'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            leading: product['image_url'] != null
                ? Image.network(
                    product['image_url'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image);
                    },
                  )
                : Icon(Icons.image),
            title: Text(product['name'] ?? 'Unknown Product'),
            subtitle: Text(product['description'] ?? ''),
            trailing: Text(
              '\$${product['price']?.toString() ?? '0.00'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }
}
```

## 3. Using the ProductService (Recommended)

```dart
import 'package:provider/provider.dart';
import '../core/services/product_service.dart';

// In your widget
final productService = ProductService();

// Get all products
final products = await productService.getAllProducts();

// Get products by category
final italianProducts = await productService.getProductsByCategory('Italian');

// Search products
final searchResults = await productService.searchProducts('pizza');
```

## 4. Using the ProductProvider (State Management)

```dart
import 'package:provider/provider.dart';
import '../features/products/providers/product_provider.dart';

// In your widget
Consumer<ProductProvider>(
  builder: (context, productProvider, child) {
    if (productProvider.isLoading) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: productProvider.products.length,
      itemBuilder: (context, index) {
        final product = productProvider.products[index];
        return ListTile(
          title: Text(product['name']),
          subtitle: Text(product['description']),
          trailing: Text('\$${product['price']}'),
        );
      },
    );
  },
)
```

## 5. Navigation to Products Screen

```dart
// Navigate to the products screen
Navigator.pushNamed(context, AppRoutes.products);

// Or directly
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductsScreen(),
  ),
);
```

## 6. Different Query Variations

```dart
// Get all products
final allProducts = await supabase.from('products').select();

// Get products with specific columns
final products = await supabase
    .from('products')
    .select('name, price, image_url, category');

// Filter by category
final italianProducts = await supabase
    .from('products')
    .select()
    .eq('category', 'Italian');

// Search products
final searchResults = await supabase
    .from('products')
    .select()
    .ilike('name', '%pizza%');

// Order by price
final sortedProducts = await supabase
    .from('products')
    .select()
    .order('price', ascending: false);

// Pagination
final page1 = await supabase
    .from('products')
    .select()
    .range(0, 19); // First 20 items

final page2 = await supabase
    .from('products')
    .select()
    .range(20, 39); // Next 20 items
```

## 7. Error Handling Best Practices

```dart
Future<List<Map<String, dynamic>>> loadProducts() async {
  try {
    final response = await supabase.from('products').select().limit(20);
    return List<Map<String, dynamic>>.from(response as List);
  } on PostgrestException catch (e) {
    print('Database error: ${e.message}');
    return [];
  } catch (e) {
    print('Unexpected error: $e');
    return [];
  }
}
```

## 8. Real-time Updates

```dart
// Listen to changes in the products table
supabase
    .channel('products')
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'products',
      callback: (payload) {
        print('Products table changed: $payload');
        // Refresh your UI here
      },
    )
    .subscribe();
```

## Next Steps

1. **Import your products** using the CSV import guide
2. **Test the queries** in your Supabase dashboard
3. **Use the ProductService** for clean, maintainable code
4. **Implement the ProductProvider** for state management
5. **Add the ProductsScreen** to your app navigation

The products are now ready to be used throughout your Flutter food delivery app!
