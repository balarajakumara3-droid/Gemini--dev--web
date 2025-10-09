import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New Property Alert',
      message: 'A new luxury villa has been listed in your preferred location.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'property',
    ),
    NotificationItem(
      id: '2',
      title: 'Price Drop',
      message: 'The price of Sky Dandelions Apartment has dropped by 15%.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: 'price',
    ),
    NotificationItem(
      id: '3',
      title: 'Agent Message',
      message: 'Sarah Johnson sent you a message about your inquiry.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      type: 'message',
    ),
    NotificationItem(
      id: '4',
      title: 'Viewing Reminder',
      message: 'Your property viewing is scheduled for tomorrow at 2 PM.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      type: 'reminder',
    ),
    NotificationItem(
      id: '5',
      title: 'New Feature',
      message: 'Check out our new mortgage calculator tool!',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
      type: 'feature',
    ),
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          _buildFilterTabs(),
          
          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getFilteredNotifications().length,
              itemBuilder: (context, index) {
                final notification = _getFilteredNotifications()[index];
                return _buildNotificationItem(notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterTab('All', _selectedFilter == 'All'),
          _buildFilterTab('Unread', _selectedFilter == 'Unread'),
          _buildFilterTab('Property', _selectedFilter == 'Property'),
          _buildFilterTab('Messages', _selectedFilter == 'Messages'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 20,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: notification.isRead ? Colors.white : const Color(0xFFE8F5E9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _onNotificationTap(notification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(notification.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconForType(notification.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: notification.isRead ? Colors.black87 : Colors.black,
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: notification.isRead ? Colors.grey[700] : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'property':
        return Icons.home;
      case 'price':
        return Icons.trending_down;
      case 'message':
        return Icons.message;
      case 'reminder':
        return Icons.calendar_today;
      case 'feature':
        return Icons.lightbulb;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconBackgroundColor(String type) {
    switch (type) {
      case 'property':
        return const Color(0xFF2196F3);
      case 'price':
        return const Color(0xFF4CAF50);
      case 'message':
        return const Color(0xFFFF9800);
      case 'reminder':
        return const Color(0xFF9C27B0);
      case 'feature':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF607D8B);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _onNotificationTap(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    switch (notification.type) {
      case 'message':
        context.push('/chat?agentName=Sarah%20Johnson&agentImage=https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face');
        break;
      case 'property':
      case 'price':
        context.push('/properties/1');
        break;
      case 'reminder':
        context.push('/schedule-visit/1');
        break;
      case 'feature':
      default:
        // no-op or navigate to feature page
        break;
    }
  }

  List<NotificationItem> _getFilteredNotifications() {
    switch (_selectedFilter) {
      case 'All':
        return _notifications;
      case 'Unread':
        return _notifications.where((notification) => !notification.isRead).toList();
      case 'Property':
        return _notifications.where((notification) => notification.type == 'property').toList();
      case 'Messages':
        return _notifications.where((notification) => notification.type == 'message').toList();
      default:
        return _notifications;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });
}