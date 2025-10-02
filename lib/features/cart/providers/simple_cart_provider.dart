import 'package:flutter/foundation.dart';

class SimpleCartProvider extends ChangeNotifier {
  final Map<String, Map<String, dynamic>> _cartItems = {};
  double _deliveryFee = 40.0;
  double _discount = 0.0;

  // Getters
  Map<String, Map<String, dynamic>> get cartItems => _cartItems;
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;
  int get itemCount => _cartItems.values.fold(0, (sum, item) => sum + (item['quantity'] as int));
  
  double get subtotal {
    return _cartItems.values.fold(0.0, (sum, item) {
      return sum + (item['price'] as double) * (item['quantity'] as int);
    });
  }
  
  double get total => subtotal + _deliveryFee - _discount;
  double get deliveryFee => _deliveryFee;
  double get discount => _discount;

  // Add item to cart
  void addItem(Map<String, dynamic> foodItem) {
    String itemId = foodItem.hashCode.toString();
    String name = _getValueFromRow(foodItem, ['dish_name', 'name', 'title']) ?? 'Unknown Item';
    String imageUrl = _getValueFromRow(foodItem, ['image_url', 'image']) ?? '';
    double price = _parsePrice(_getValueFromRow(foodItem, ['price', 'cost']) ?? '12.99');

    if (_cartItems.containsKey(itemId)) {
      _cartItems[itemId]!['quantity'] += 1;
    } else {
      _cartItems[itemId] = {
        'id': itemId,
        'name': name,
        'price': price,
        'quantity': 1,
        'image_url': imageUrl,
        'original_data': foodItem,
      };
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String itemId) {
    _cartItems.remove(itemId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
    } else if (_cartItems.containsKey(itemId)) {
      _cartItems[itemId]!['quantity'] = quantity;
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Get item quantity
  int getItemQuantity(String itemId) {
    return _cartItems[itemId]?['quantity'] ?? 0;
  }

  // Check if item is in cart
  bool isInCart(String itemId) {
    return _cartItems.containsKey(itemId);
  }

  // Apply discount
  void applyDiscount(double discountAmount) {
    _discount = discountAmount;
    notifyListeners();
  }

  // Helper methods
  String? _getValueFromRow(Map<String, dynamic> row, List<String> possibleKeys) {
    for (String key in possibleKeys) {
      if (row.containsKey(key) && row[key] != null && row[key].toString().isNotEmpty) {
        return row[key].toString();
      }
      
      for (String rowKey in row.keys) {
        if (rowKey.toLowerCase() == key.toLowerCase() && 
            row[rowKey] != null && 
            row[rowKey].toString().isNotEmpty) {
          return row[rowKey].toString();
        }
      }
    }
    return null;
  }

  double _parsePrice(String priceStr) {
    if (priceStr.isEmpty) return 12.99;
    String cleanPrice = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 12.99;
  }
}
