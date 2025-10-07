import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DebugProductsScreen extends StatefulWidget {
  const DebugProductsScreen({super.key});

  @override
  State<DebugProductsScreen> createState() => _DebugProductsScreenState();
}

class _DebugProductsScreenState extends State<DebugProductsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _error;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _testSupabaseConnection();
  }

  Future<void> _testSupabaseConnection() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // NOTE: Supabase/PostgREST lower-cases unquoted identifiers.
      // Use the actual table name present in your schema cache.
      // We'll avoid selecting specific columns for count and avoid ordering
      // by columns that may not exist in the user's table.

      final countList = await _supabase
          .from('products')
          .select('id');

      final count = (countList as List).length;

      // Fetch a few rows without relying on created_at
      final response = await _supabase
          .from('products')
          .select()
          .limit(10);
      
      setState(() {
        _count = count;
        _products = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _testSupabaseConnection,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Testing Supabase connection...'),
                  ],
                ),
              )
            else if (_error != null)
              Column(
                children: [
                  const Text(
                    'Error:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _testSupabaseConnection,
                    child: const Text('Retry'),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Products in Database: $_count',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sample Products:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] ?? 'No name',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('ID: ${product['id']}'),
                                Text('Price: \$${product['price']}'),
                                if (product['category'] != null)
                                  Text('Category: ${product['category']}'),
                                if (product['description'] != null)
                                  Text('Description: ${product['description']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}