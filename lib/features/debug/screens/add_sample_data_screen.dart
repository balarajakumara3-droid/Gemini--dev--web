import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddSampleDataScreen extends StatefulWidget {
  const AddSampleDataScreen({super.key});

  @override
  State<AddSampleDataScreen> createState() => _AddSampleDataScreenState();
}

class _AddSampleDataScreenState extends State<AddSampleDataScreen> {
  bool _isLoading = false;
  String _status = '';

  final List<Map<String, dynamic>> _sampleProducts = [
    {
      'name': 'Margherita Pizza',
      'price': 299.00,
      'image_url': 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
      'description': 'Classic Italian pizza with tomato sauce, mozzarella, and fresh basil',
      'category': 'Pizza',
      'is_available': true,
      'rating': 4.5,
      'preparation_time': 15,
      'ingredients': 'Tomato sauce, Mozzarella, Basil, Olive oil',
      'calories': 350,
    },
    {
      'name': 'Chicken Burger',
      'price': 199.00,
      'image_url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      'description': 'Juicy grilled chicken breast with lettuce, tomato, and mayo',
      'category': 'Burger',
      'is_available': true,
      'rating': 4.3,
      'preparation_time': 12,
      'ingredients': 'Chicken breast, Lettuce, Tomato, Mayo, Bun',
      'calories': 420,
    },
    {
      'name': 'Chicken Biryani',
      'price': 249.00,
      'image_url': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400',
      'description': 'Fragrant basmati rice with tender chicken and aromatic spices',
      'category': 'Indian',
      'is_available': true,
      'rating': 4.7,
      'preparation_time': 20,
      'ingredients': 'Basmati rice, Chicken, Onions, Spices, Yogurt',
      'calories': 580,
    },
    {
      'name': 'Sushi Roll',
      'price': 399.00,
      'image_url': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      'description': 'Fresh salmon and avocado roll with wasabi and soy sauce',
      'category': 'Sushi',
      'is_available': true,
      'rating': 4.6,
      'preparation_time': 10,
      'ingredients': 'Salmon, Avocado, Rice, Nori, Wasabi',
      'calories': 280,
    },
    {
      'name': 'Caesar Salad',
      'price': 149.00,
      'image_url': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
      'description': 'Fresh romaine lettuce with parmesan cheese and caesar dressing',
      'category': 'Salad',
      'is_available': true,
      'rating': 4.2,
      'preparation_time': 8,
      'ingredients': 'Romaine lettuce, Parmesan, Croutons, Caesar dressing',
      'calories': 180,
    },
  ];

  Future<void> _addSampleData() async {
    setState(() {
      _isLoading = true;
      _status = 'Adding sample data...';
    });

    try {
      final supabase = Supabase.instance.client;
      
      // Clear existing data first
      await supabase.from('Products').delete().neq('id', '00000000-0000-0000-0000-000000000000');
      _status = 'Cleared existing data. Adding new products...';
      
      // Add sample products
      for (int i = 0; i < _sampleProducts.length; i++) {
        await supabase.from('Products').insert(_sampleProducts[i]);
        _status = 'Added product ${i + 1}/${_sampleProducts.length}: ${_sampleProducts[i]['name']}';
        setState(() {});
      }
      
      _status = '✅ Successfully added ${_sampleProducts.length} products!';
      
    } catch (e) {
      _status = '❌ Error: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sample Data'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Sample Products',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('This will add ${_sampleProducts.length} sample products to your Products table.'),
                    const SizedBox(height: 8),
                    const Text(
                      'Products to be added:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ..._sampleProducts.map((product) => Text('• ${product['name']} - ₹${product['price']}')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _addSampleData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Adding Data...'),
                      ],
                    )
                  : const Text('Add Sample Data'),
            ),
            const SizedBox(height: 16),
            if (_status.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _status.contains('✅') 
                      ? Colors.green.shade50 
                      : _status.contains('❌') 
                          ? Colors.red.shade50 
                          : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _status.contains('✅') 
                        ? Colors.green 
                        : _status.contains('❌') 
                            ? Colors.red 
                            : Colors.blue,
                  ),
                ),
                child: Text(
                  _status,
                  style: TextStyle(
                    color: _status.contains('✅') 
                        ? Colors.green.shade800 
                        : _status.contains('❌') 
                            ? Colors.red.shade800 
                            : Colors.blue.shade800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
