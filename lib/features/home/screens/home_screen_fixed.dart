import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/app_config.dart';
import '../../../core/services/database_service.dart';
import '../providers/restaurant_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../restaurant/screens/restaurant_detail_screen.dart';

class HomeScreenFixed extends StatefulWidget {
  const HomeScreenFixed({super.key});

  @override
  State<HomeScreenFixed> createState() => _HomeScreenFixedState();
}

class _HomeScreenFixedState extends State<HomeScreenFixed> {
  final ScrollController _scrollController = ScrollController();
  final DatabaseService _dbService = DatabaseService();
  bool _isLocationPermissionGranted = false;
  Future<List<Map<String, dynamic>>>? _supabaseRestaurantsFuture;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Delivery'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant,
              size: 100,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Food Delivery!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailScreen(
                      restaurant: {
                        'id': 'sample_id',
                        'name': 'Sample Restaurant',
                        'cuisine': 'Italian, Fast Food',
                        'rating': 4.2,
                        'deliveryTime': '30-40 min',
                        'deliveryFee': 0,
                        'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop',
                        'isOpen': true,
                      },
                    ),
                  ),
                );
              },
              child: const Text('View Sample Restaurant'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: const Text('View Cart'),
            ),
          ],
        ),
      ),
    );
  }
}