import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../../checkout/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Dummy cart items for demonstration
  final List<Map<String, dynamic>> _dummyCartItems = [
    {
      'id': '1',
      'name': 'Margherita Pizza',
      'restaurant': 'Pizza Palace',
      'price': 299.0,
      'quantity': 1,
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100&h=100&fit=crop',
      'description': 'Fresh tomatoes, mozzarella, basil',
    },
    {
      'id': '2',
      'name': 'Chicken Burger',
      'restaurant': 'Burger House',
      'price': 249.0,
      'quantity': 2,
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=100&h=100&fit=crop',
      'description': 'Grilled chicken, lettuce, cheese',
    },
  ];

  bool get _hasItems => _dummyCartItems.isNotEmpty;
  
  double get _subtotal => _dummyCartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get _deliveryFee => 50.0;
  double get _taxes => _subtotal * 0.09; // 9% tax
  double get _total => _subtotal + _deliveryFee + _taxes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _hasItems
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _dummyCartItems.length,
                    itemBuilder: (context, index) {
                      final item = _dummyCartItems[index];
                      return _buildCartItem(item);
                    },
                  ),
                ),
                _buildCartSummary(),
              ],
            )
          : _buildEmptyCart(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some delicious items to get started!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to home or restaurant list
              Navigator.of(context).pop();
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Item Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.backgroundColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'] ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.fastfood,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'Unknown Item',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'from ${item['restaurant'] ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${(item['price'] ?? 0).toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity Controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: () {
                          _updateQuantity(item['id'], (item['quantity'] ?? 1) - 1);
                        },
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('${item['quantity'] ?? 1}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () {
                          _updateQuantity(item['id'], (item['quantity'] ?? 1) + 1);
                        },
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text('₹${_subtotal.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee'),
              Text('₹${_deliveryFee.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Taxes'),
              Text('₹${_taxes.toStringAsFixed(0)}'),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${_total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _proceedToCheckout();
              },
              child: const Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
  
  void _updateQuantity(String itemId, int newQuantity) {
    setState(() {
      final index = _dummyCartItems.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        if (newQuantity <= 0) {
          _dummyCartItems.removeAt(index);
        } else {
          _dummyCartItems[index]['quantity'] = newQuantity;
        }
      }
    });
  }

  void _proceedToCheckout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          subtotal: _subtotal,
          deliveryFee: _deliveryFee,
          taxes: _taxes,
          total: _total,
          cartItems: _dummyCartItems,
        ),
      ),
    );
  }
}