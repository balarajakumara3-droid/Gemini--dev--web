import 'package:flutter/foundation.dart';

import '../../../core/models/cart.dart';
import '../../../core/models/restaurant.dart';

class CartProvider extends ChangeNotifier {
  // Remove unused _apiService field

  Cart _cart = Cart.empty('');
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Cart get cart => _cart;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _cart.isEmpty;
  bool get isNotEmpty => _cart.isNotEmpty;
  int get itemCount => _cart.itemCount;
  double get subtotal => _cart.calculatedSubtotal;
  double get total => _cart.calculatedTotal;

  // Initialize cart for user
  void initializeCart(String userId) {
    _cart = Cart.empty(userId);
    notifyListeners();
  }

  // Clear cart completely
  void clearCart() {
    _cart = Cart.empty(_cart.userId);
    notifyListeners();
  }

  // Add item to cart
  void addItem(Food food, Restaurant restaurant, {
    List<AddonOption> selectedAddons = const [],
    String? specialInstructions,
    int quantity = 1,
  }) {
    try {
      _clearError();

      // Check if cart has items from different restaurant
      if (_cart.isNotEmpty && _cart.restaurantId != restaurant.id) {
        throw Exception('You can only order from one restaurant at a time. Clear cart to order from ${restaurant.name}');
      }

      // Create cart item
      final cartItem = CartItem(
        id: '${food.id}_${DateTime.now().millisecondsSinceEpoch}',
        food: food,
        quantity: quantity,
        selectedAddons: selectedAddons,
        specialInstructions: specialInstructions,
        addedAt: DateTime.now(),
      );

      // Update cart
      final updatedItems = List<CartItem>.from(_cart.items);
      
      // Check if same item (including addons) already exists
      final existingItemIndex = updatedItems.indexWhere((item) =>
          item.food.id == food.id &&
          _areAddonsEqual(item.selectedAddons, selectedAddons) &&
          item.specialInstructions == specialInstructions);

      if (existingItemIndex != -1) {
        // Update quantity of existing item
        updatedItems[existingItemIndex] = updatedItems[existingItemIndex].copyWith(
          quantity: updatedItems[existingItemIndex].quantity + quantity,
        );
      } else {
        // Add new item
        updatedItems.add(cartItem);
      }

      _cart = _cart.copyWith(
        restaurantId: restaurant.id,
        restaurantName: restaurant.name,
        items: updatedItems,
        deliveryFee: restaurant.deliveryFee,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Update item quantity
  void updateItemQuantity(String itemId, int quantity) {
    try {
      _clearError();

      if (quantity <= 0) {
        removeItem(itemId);
        return;
      }

      final updatedItems = _cart.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList();

      _cart = _cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Remove item from cart
  void removeItem(String itemId) {
    try {
      _clearError();

      final updatedItems = _cart.items.where((item) => item.id != itemId).toList();

      // If cart becomes empty, reset restaurant info
      if (updatedItems.isEmpty) {
        _cart = Cart.empty(_cart.userId);
      } else {
        _cart = _cart.copyWith(
          items: updatedItems,
          updatedAt: DateTime.now(),
        );
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }


  // Apply coupon/discount
  void applyCoupon(String couponCode, double discountAmount) {
    try {
      _clearError();

      _cart = _cart.copyWith(
        discount: discountAmount,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Remove coupon
  void removeCoupon() {
    _cart = _cart.copyWith(
      discount: 0.0,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  // Get item count for specific food
  int getItemQuantity(String foodId) {
    return _cart.items
        .where((item) => item.food.id == foodId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // Check if food is in cart
  bool isInCart(String foodId) {
    return _cart.items.any((item) => item.food.id == foodId);
  }

  // Get cart item by food id (for customization)
  CartItem? getCartItem(String foodId) {
    try {
      return _cart.items.firstWhere((item) => item.food.id == foodId);
    } catch (e) {
      return null;
    }
  }

  // Validate cart before checkout
  bool validateCart() {
    if (_cart.isEmpty) {
      _setError('Cart is empty');
      return false;
    }

    if (_cart.calculatedSubtotal < 0) {
      _setError('Invalid cart total');
      return false;
    }

    // Check if all items are available
    for (final item in _cart.items) {
      if (!item.food.isAvailable) {
        _setError('${item.food.name} is no longer available');
        return false;
      }
    }

    return true;
  }

  // Calculate delivery time estimate
  String getEstimatedDeliveryTime() {
    if (_cart.isEmpty) return '';
    
    // Base delivery time (can be fetched from restaurant)
    int baseMinutes = 30;
    
    // Add time based on number of items
    int itemMinutes = (_cart.itemCount / 5).ceil() * 5;
    
    int totalMinutes = baseMinutes + itemMinutes;
    
    return '$totalMinutes-${totalMinutes + 10} mins';
  }

  // Save cart state (for persistence)
  Map<String, dynamic> getCartState() {
    return _cart.toJson();
  }

  // Restore cart state (for persistence)
  void restoreCartState(Map<String, dynamic> cartData) {
    try {
      _cart = Cart.fromJson(cartData);
      notifyListeners();
    } catch (e) {
      _setError('Failed to restore cart');
    }
  }

  // Private helper methods
  bool _areAddonsEqual(List<AddonOption> addons1, List<AddonOption> addons2) {
    if (addons1.length != addons2.length) return false;
    
    final ids1 = addons1.map((addon) => addon.id).toSet();
    final ids2 = addons2.map((addon) => addon.id).toSet();
    
    return ids1.containsAll(ids2) && ids2.containsAll(ids1);
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}