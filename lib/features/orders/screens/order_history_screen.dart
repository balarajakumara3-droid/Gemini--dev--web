import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/order_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildOngoingOrders(orderProvider),
              _buildOrderHistory(orderProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOngoingOrders(OrderProvider orderProvider) {
    // Mock ongoing orders
    final ongoingOrders = [
      _MockOrder(
        id: '1',
        restaurantName: 'Pizza Palace',
        status: 'Preparing',
        total: 450.0,
        items: ['Margherita Pizza', 'Garlic Bread'],
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        estimatedDelivery: DateTime.now().add(const Duration(minutes: 25)),
      ),
    ];

    if (ongoingOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No ongoing orders',
        subtitle: 'Your active orders will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ongoingOrders.length,
      itemBuilder: (context, index) {
        final order = ongoingOrders[index];
        return _buildOngoingOrderCard(order);
      },
    );
  }

  Widget _buildOrderHistory(OrderProvider orderProvider) {
    // Mock order history
    final historyOrders = [
      _MockOrder(
        id: '2',
        restaurantName: 'Burger House',
        status: 'Delivered',
        total: 320.0,
        items: ['Classic Burger', 'French Fries', 'Coke'],
        orderTime: DateTime.now().subtract(const Duration(days: 1)),
        estimatedDelivery: DateTime.now().subtract(const Duration(days: 1, hours: -1)),
      ),
      _MockOrder(
        id: '3',
        restaurantName: 'Sushi Express',
        status: 'Delivered',
        total: 680.0,
        items: ['California Roll', 'Salmon Sashimi', 'Miso Soup'],
        orderTime: DateTime.now().subtract(const Duration(days: 3)),
        estimatedDelivery: DateTime.now().subtract(const Duration(days: 3, hours: -1)),
      ),
    ];

    if (historyOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No order history',
        subtitle: 'Your past orders will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: historyOrders.length,
      itemBuilder: (context, index) {
        final order = historyOrders[index];
        return _buildHistoryOrderCard(order);
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingOrderCard(_MockOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.restaurantName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.items.join(', '),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${order.total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Arriving in ${_getEstimatedTime(order.estimatedDelivery)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _trackOrder(order);
                },
                child: const Text('Track Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryOrderCard(_MockOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.restaurantName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDate(order.orderTime),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.items.join(', '),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${order.total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _reorderItems(order);
                      },
                      child: const Text('Reorder'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        _rateOrder(order);
                      },
                      child: const Text('Rate'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
        return AppTheme.warningColor;
      case 'on the way':
        return AppTheme.infoColor;
      case 'delivered':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getEstimatedTime(DateTime estimatedDelivery) {
    final difference = estimatedDelivery.difference(DateTime.now());
    if (difference.inMinutes <= 0) {
      return 'Any moment';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _trackOrder(_MockOrder order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking order ${order.id}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _reorderItems(_MockOrder order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reordering from ${order.restaurantName}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _rateOrder(_MockOrder order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rating order from ${order.restaurantName}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}

class _MockOrder {
  final String id;
  final String restaurantName;
  final String status;
  final double total;
  final List<String> items;
  final DateTime orderTime;
  final DateTime estimatedDelivery;

  _MockOrder({
    required this.id,
    required this.restaurantName,
    required this.status,
    required this.total,
    required this.items,
    required this.orderTime,
    required this.estimatedDelivery,
  });
}