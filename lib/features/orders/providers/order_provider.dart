import 'package:flutter/foundation.dart';

import '../../../core/models/order.dart';
import '../../../core/models/cart.dart';
import '../../../core/models/user.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/database_service.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();

  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<Order> get activeOrders => _orders.where((order) => order.isActive).toList();
  List<Order> get completedOrders => _orders.where((order) => order.isCompleted).toList();
  List<Order> get cancelledOrders => _orders.where((order) => order.isCancelled).toList();

  // Create new order
  Future<bool> createOrder({
    required Cart cart,
    required Address deliveryAddress,
    required PaymentMethod paymentMethod,
    String? couponCode,
    String? specialInstructions,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Create order from cart
      final order = Order.fromCart(
        cart,
        deliveryAddress,
        paymentMethod,
        couponCode: couponCode,
        specialInstructions: specialInstructions,
      );

      // Send to API
      final createdOrder = await _apiService.createOrder(order);
      
      // Cache locally
      await _databaseService.cacheOrder(createdOrder);
      
      // Add to orders list
      _orders.insert(0, createdOrder);
      _currentOrder = createdOrder;
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Fetch orders from API
  Future<void> fetchOrders({bool refresh = false}) async {
    try {
      if (!refresh && _orders.isNotEmpty) return;
      
      _setLoading(true);
      _clearError();

      final orders = await _apiService.getOrders();
      
      _orders = orders;
      
      // Cache orders locally
      for (final order in orders) {
        await _databaseService.cacheOrder(order);
      }
      
    } catch (e) {
      _setError(_getErrorMessage(e));
      
      // Load from cache if API fails
      await _loadOrdersFromCache();
    } finally {
      _setLoading(false);
    }
  }

  // Get order details
  Future<void> fetchOrderDetails(String orderId) async {
    try {
      _setLoading(true);
      _clearError();

      // Try cache first
      _currentOrder = await _databaseService.getCachedOrder(orderId);
      
      if (_currentOrder != null) {
        notifyListeners();
      }

      // Fetch fresh data
      _currentOrder = await _apiService.getOrderDetails(orderId);
      
      // Update in orders list
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _currentOrder!;
      }
      
      // Cache updated order
      await _databaseService.cacheOrder(_currentOrder!);
      
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId, String reason) async {
    try {
      _setLoading(true);
      _clearError();

      await _apiService.cancelOrder(orderId, reason);
      
      // Update local order status
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: OrderStatus.cancelled,
          cancellationReason: reason,
        );
        
        // Cache updated order
        await _databaseService.cacheOrder(_orders[index]);
      }
      
      // Update current order if it's the one being cancelled
      if (_currentOrder?.id == orderId) {
        _currentOrder = _currentOrder!.copyWith(
          status: OrderStatus.cancelled,
          cancellationReason: reason,
        );
      }
      
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Track order (real-time updates)
  Future<void> trackOrder(String orderId) async {
    try {
      _clearError();

      // Fetch latest order status
      await fetchOrderDetails(orderId);
      
      // In a real app, you might set up a WebSocket connection
      // or periodic polling for real-time updates
      
    } catch (e) {
      _setError(_getErrorMessage(e));
    }
  }

  // Reorder - create new order from existing order
  Future<Cart> reorder(Order order) async {
    try {
      _clearError();

      // Create new cart from order items
      final cart = Cart(
        id: 'reorder_${DateTime.now().millisecondsSinceEpoch}',
        userId: order.userId,
        restaurantId: order.restaurantId,
        restaurantName: order.restaurantName,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        taxes: order.taxes,
        discount: 0.0, // Reset discount for new order
        total: order.subtotal + order.deliveryFee + order.taxes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      return cart;
      
    } catch (e) {
      _setError(_getErrorMessage(e));
      rethrow;
    }
  }

  // Rate and review order
  Future<bool> rateOrder(String orderId, {
    required double rating,
    String? review,
    double? deliveryRating,
    double? foodRating,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // API call to submit rating and review
      // Implementation depends on your backend
      
      await Future.delayed(const Duration(seconds: 1));
      
      // Update local order (placeholder)
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        // In real implementation, you'd update with rating info
        notifyListeners();
      }
      
      return true;
      
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Get orders by date range
  List<Order> getOrdersByDateRange(DateTime startDate, DateTime endDate) {
    return _orders.where((order) =>
        order.orderTime.isAfter(startDate) &&
        order.orderTime.isBefore(endDate)).toList();
  }

  // Get recent orders
  List<Order> getRecentOrders({int limit = 5}) {
    final sortedOrders = List<Order>.from(_orders);
    sortedOrders.sort((a, b) => b.orderTime.compareTo(a.orderTime));
    return sortedOrders.take(limit).toList();
  }

  // Calculate total spent
  double getTotalSpent() {
    return _orders
        .where((order) => order.status != OrderStatus.cancelled)
        .fold(0.0, (sum, order) => sum + order.total);
  }

  // Get order statistics
  Map<String, dynamic> getOrderStatistics() {
    final totalOrders = _orders.length;
    final completedOrders = _orders.where((order) => order.isCompleted).length;
    final cancelledOrders = _orders.where((order) => order.isCancelled).length;
    final totalSpent = getTotalSpent();
    
    return {
      'total_orders': totalOrders,
      'completed_orders': completedOrders,
      'cancelled_orders': cancelledOrders,
      'active_orders': activeOrders.length,
      'total_spent': totalSpent,
      'average_order_value': totalOrders > 0 ? totalSpent / totalOrders : 0.0,
    };
  }

  // Clear current order
  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  // Refresh orders
  Future<void> refresh() async {
    await fetchOrders(refresh: true);
  }

  // Load orders from cache
  Future<void> _loadOrdersFromCache() async {
    try {
      // This would require storing user ID
      // For now, we'll leave it empty
      _orders = [];
      notifyListeners();
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }
    return error.toString();
  }

  @override
  void dispose() {
    _orders.clear();
    _currentOrder = null;
    super.dispose();
  }
}