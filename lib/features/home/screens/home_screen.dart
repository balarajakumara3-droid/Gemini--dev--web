import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/app_config.dart';
import '../providers/restaurant_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../restaurant/screens/restaurant_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLocationPermissionGranted = false;
  
  // Dummy restaurant data with better images
  final List<Map<String, dynamic>> _dummyRestaurants = [
    {
      'id': '1',
      'name': 'Domino\'s Pizza',
      'cuisine_type': 'Pizzas, Italian, Pastas, Desserts',
      'rating': 4.3,
      'delivery_time': '25-30',
      'delivery_fee': 0,
      'image_url': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=250&fit=crop',
      'is_open': true,
      'discount': '₹125 OFF ABOVE ₹199',
      'promoted': true
    },
    {
      'id': '2',
      'name': 'McDonald\'s',
      'cuisine_type': 'Burgers, Beverages, Cafe, Desserts',
      'rating': 4.4,
      'delivery_time': '20-25',
      'delivery_fee': 0,
      'image_url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=250&fit=crop',
      'is_open': true,
      'discount': '₹100 OFF ABOVE ₹199',
      'promoted': false
    },
    {
      'id': '3',
      'name': 'KFC',
      'cuisine_type': 'Burgers, Fast Food, Rolls',
      'rating': 4.2,
      'delivery_time': '30-35',
      'delivery_fee': 3.0,
      'image_url': 'https://images.unsplash.com/photo-1527477396002-952d92456975?w=400&h=250&fit=crop',
      'is_open': true,
      'discount': 'ITEMS AT ₹179',
      'promoted': true
    },
    {
      'id': '4',
      'name': 'Subway',
      'cuisine_type': 'Healthy Food, Salads, Snacks, Desserts',
      'rating': 4.1,
      'delivery_time': '35-40',
      'delivery_fee': 2.0,
      'image_url': 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400&h=250&fit=crop',
      'is_open': true,
      'discount': 'UPTO 20% OFF',
      'promoted': false
    },
    {
      'id': '5',
      'name': 'Starbucks Coffee',
      'cuisine_type': 'Cafe, Beverages, Snacks, Desserts',
      'rating': 4.5,
      'delivery_time': '25-30',
      'delivery_fee': 4.0,
      'image_url': 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=400&h=250&fit=crop',
      'is_open': true,
      'discount': 'UPTO 15% OFF',
      'promoted': false
    },
    {
      'id': '6',
      'name': 'Burger King',
      'cuisine_type': 'Burgers, American',
      'rating': 4.0,
      'delivery_time': '45-50',
      'delivery_fee': 0,
      'image_url': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=250&fit=crop',
      'is_open': false,
      'discount': 'ITEMS AT ₹129',
      'promoted': false
    }
  ];

  // Dummy food categories with images
  final List<Map<String, dynamic>> _dummyCategories = [
    {
      'id': '1',
      'name': 'Pizza',
      'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100&h=100&fit=crop'
    },
    {
      'id': '2',
      'name': 'Burgers',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=100&h=100&fit=crop'
    },
    {
      'id': '3',
      'name': 'Chinese',
      'image': 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=100&h=100&fit=crop'
    },
    {
      'id': '4',
      'name': 'Desserts',
      'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=100&h=100&fit=crop'
    },
    {
      'id': '5',
      'name': 'Beverages',
      'image': 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=100&h=100&fit=crop'
    },
    {
      'id': '6',
      'name': 'Indian',
      'image': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=100&h=100&fit=crop'
    }
  ];

  // Dummy offers/banners
  final List<Map<String, dynamic>> _dummyOffers = [
    {
      'id': '1',
      'title': 'Welcome Offer',
      'subtitle': 'Get 60% OFF on your first order',
      'image': 'https://images.unsplash.com/photo-1571091655789-405eb7a3a3a8?w=400&h=200&fit=crop',
      'color': AppTheme.primaryColor
    },
    {
      'id': '2',
      'title': 'Free Delivery',
      'subtitle': 'Free delivery on orders above ₹199',
      'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=200&fit=crop',
      'color': AppTheme.successColor
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _requestLocationPermission();
    await _loadRestaurants();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _isLocationPermissionGranted = true;
      });
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (mounted) {
        Provider.of<RestaurantProvider>(context, listen: false)
            .setUserLocation(position.latitude, position.longitude);
      }
    } catch (e) {
      // Use default location if current location fails
      if (mounted) {
        Provider.of<RestaurantProvider>(context, listen: false)
            .setUserLocation(AppConfig.defaultLatitude, AppConfig.defaultLongitude);
      }
    }
  }

  Future<void> _loadRestaurants() async {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    // Load dummy data into provider
    restaurantProvider.loadDummyRestaurants(_dummyRestaurants);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _loadRestaurants,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(),
            _buildSearchSection(),
            _buildOffersSection(),
            _buildCategoriesSection(),
            _buildSectionHeader('Popular Restaurants'),
            _buildRestaurantsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.2),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _isLocationPermissionGranted 
                                          ? Icons.location_on 
                                          : Icons.location_off,
                                      color: AppTheme.primaryColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        _isLocationPermissionGranted 
                                            ? 'Home'
                                            : 'Add Address',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppTheme.textSecondary,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                Text(
                                  _isLocationPermissionGranted 
                                      ? 'Mumbai, Maharashtra 400001, India'
                                      : 'Please add your delivery address',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 20,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/search');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppTheme.primaryColor, size: 20),
                SizedBox(width: 12),
                Text(
                  'Search for dishes & restaurants',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(Icons.mic, color: AppTheme.textSecondary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffersSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: PageView.builder(
          itemCount: _dummyOffers.length,
          itemBuilder: (context, index) {
            final offer = _dummyOffers[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    offer['color'],
                    offer['color'].withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: offer['image'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                      placeholder: (context, url) => Container(
                        color: offer['color'].withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: offer['color'],
                        child: const Icon(Icons.image, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer['subtitle'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'What\'s on your mind?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _dummyCategories.length,
                itemBuilder: (context, index) {
                  final category = _dummyCategories[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to category
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: category['image'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.fastfood),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.fastfood),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantsSection() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final restaurant = _dummyRestaurants[index];
            return _buildRestaurantCard(restaurant);
          },
          childCount: _dummyRestaurants.length,
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    final isOpen = restaurant['is_open'] ?? true;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: restaurant['image_url'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.restaurant,
                          color: AppTheme.primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                // Promoted tag
                if (restaurant['promoted'] == true)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PROMOTED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Discount banner
                if (restaurant['discount'] != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        restaurant['discount'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // Closed overlay
                if (!isOpen)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          'CLOSED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Restaurant Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant['name'] ?? 'Unknown Restaurant',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${restaurant['rating'] ?? 0.0}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant['cuisine_type'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant['delivery_time']} mins',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.currency_rupee,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      Text(
                        restaurant['delivery_fee'] == 0 
                            ? 'Free delivery' 
                            : '₹${restaurant['delivery_fee']} delivery',
                        style: TextStyle(
                          fontSize: 12,
                          color: restaurant['delivery_fee'] == 0 
                              ? AppTheme.successColor 
                              : AppTheme.textSecondary,
                          fontWeight: restaurant['delivery_fee'] == 0 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}