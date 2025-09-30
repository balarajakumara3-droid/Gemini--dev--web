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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final DatabaseService _dbService = DatabaseService();
  bool _isLocationPermissionGranted = false;
  Future<List<Map<String, dynamic>>>? _supabaseRestaurantsFuture;
  
  // Swiggy-like categories with enhanced data
  final List<Map<String, String>> _categories = [
    {'name': 'Pizza', 'icon': '🍕', 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100&h=100&fit=crop'},
    {'name': 'Burger', 'icon': '🍔', 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=100&h=100&fit=crop'},
    {'name': 'Chinese', 'icon': '🥢', 'image': 'https://images.unsplash.com/photo-1559314809-0f31657def5e?w=100&h=100&fit=crop'},
    {'name': 'Indian', 'icon': '🍛', 'image': 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=100&h=100&fit=crop'},
    {'name': 'Dessert', 'icon': '🧁', 'image': 'https://images.unsplash.com/photo-1587668178277-295251f900ce?w=100&h=100&fit=crop'},
    {'name': 'Coffee', 'icon': '☕', 'image': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=100&h=100&fit=crop'},
    {'name': 'Thai', 'icon': '🌶️', 'image': 'https://images.unsplash.com/photo-1562565652-a0d8f0c59eb4?w=100&h=100&fit=crop'},
    {'name': 'Sushi', 'icon': '🍣', 'image': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=100&h=100&fit=crop'},
  ];
  
  // Offers/promotions data
  final List<Map<String, dynamic>> _offers = [
    {
      'title': '50% OFF UPTO ₹100',
      'subtitle': 'USE WELCOME50',
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=200&fit=crop',
      'color': Colors.orange,
    },
    {
      'title': 'FREE DELIVERY',
      'subtitle': 'On orders above ₹199',
      'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=200&fit=crop',
      'color': Colors.green,
    },
    {
      'title': '₹125 OFF',
      'subtitle': 'USE SAVE125',
      'image': 'https://images.unsplash.com/photo-1571407982964-b9c0b92ab40c?w=400&h=200&fit=crop',
      'color': Colors.purple,
    },
  ];
  
  // Enhanced restaurant dummy data (200 items)
  final List<Map<String, dynamic>> _dummyRestaurants = [
    // Top rated restaurants
    {'id': '1', 'name': 'Pizza Palace', 'cuisine': 'Italian, Pizza', 'rating': 4.5, 'deliveryTime': '25-30 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&h=200&fit=crop', 'isOpen': true, 'promoted': true, 'discount': '40% OFF'},
    {'id': '2', 'name': 'Burger House', 'cuisine': 'American, Burgers', 'rating': 4.4, 'deliveryTime': '20-25 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop', 'isOpen': true, 'promoted': true, 'discount': '₹100 OFF'},
    {'id': '3', 'name': 'Sushi Express', 'cuisine': 'Japanese, Sushi', 'rating': 4.7, 'deliveryTime': '30-35 min', 'deliveryFee': 3.99, 'image': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300&h=200&fit=crop', 'isOpen': true, 'promoted': true, 'discount': 'FREE DELIVERY'},
    {'id': '4', 'name': 'Spice Garden', 'cuisine': 'Indian, Curry', 'rating': 4.6, 'deliveryTime': '25-30 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300&h=200&fit=crop', 'isOpen': true, 'promoted': true, 'discount': '30% OFF'},
    {'id': '5', 'name': 'Sweet Dreams', 'cuisine': 'Desserts, Ice Cream', 'rating': 4.8, 'deliveryTime': '15-20 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1587668178277-295251f900ce?w=300&h=200&fit=crop', 'isOpen': true, 'promoted': true, 'discount': 'BUY 1 GET 1'},
    
    // Regular restaurants (195 more)
    {'id': '6', 'name': 'Slice Heaven', 'cuisine': 'Italian, Pizza', 'rating': 4.3, 'deliveryTime': '20-25 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '7', 'name': 'Grill Masters', 'cuisine': 'American, Burgers', 'rating': 4.4, 'deliveryTime': '15-20 min', 'deliveryFee': 1.49, 'image': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '8', 'name': 'Dragon Wok', 'cuisine': 'Chinese, Stir Fry', 'rating': 4.3, 'deliveryTime': '25-30 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1559314809-0f31657def5e?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '9', 'name': 'Thai Spice', 'cuisine': 'Thai, Curry', 'rating': 4.4, 'deliveryTime': '20-25 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1562565652-a0d8f0c59eb4?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '10', 'name': 'Coffee Central', 'cuisine': 'Coffee, Beverages', 'rating': 4.5, 'deliveryTime': '10-15 min', 'deliveryFee': 0.99, 'image': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300&h=200&fit=crop', 'isOpen': true},
    // Add more restaurants to reach 200 total
    {'id': '11', 'name': 'Ramen House', 'cuisine': 'Japanese, Noodles', 'rating': 4.6, 'deliveryTime': '25-30 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1617093727343-374698b1b08d?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '12', 'name': 'Taco Fiesta', 'cuisine': 'Mexican, Tacos', 'rating': 4.3, 'deliveryTime': '15-20 min', 'deliveryFee': 1.49, 'image': 'https://images.unsplash.com/photo-1565299585323-38174c4a6c07?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '13', 'name': 'Cake Corner', 'cuisine': 'Bakery, Cakes', 'rating': 4.6, 'deliveryTime': '25-30 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '14', 'name': 'Green Garden', 'cuisine': 'Healthy, Salads', 'rating': 4.5, 'deliveryTime': '20-25 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '15', 'name': 'BBQ Smokehouse', 'cuisine': 'BBQ, Smoked Meat', 'rating': 4.6, 'deliveryTime': '35-40 min', 'deliveryFee': 3.99, 'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=300&h=200&fit=crop', 'isOpen': true},
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _requestLocationPermission();
    _supabaseRestaurantsFuture = _dbService.getRestaurantsHybrid().then((restaurants) => 
        restaurants.map((r) => r.toJson()).toList());
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
      if (mounted) {
        Provider.of<RestaurantProvider>(context, listen: false)
            .setUserLocation(AppConfig.defaultLatitude, AppConfig.defaultLongitude);
      }
    }
  }

  Future<void> _loadRestaurants() async {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    await restaurantProvider.fetchRestaurantsWithSupabase();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSwiggyAppBar(),
          _buildLocationBanner(),
          _buildSearchBar(),
          _buildOffersCarousel(),
          _buildCategoriesGrid(),
          _buildPromotedRestaurants(),
          _buildAllRestaurants(),
        ],
      ),
    );
  }

  // Swiggy-like App Bar
  Widget _buildSwiggyAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 0,
      flexibleSpace: Container(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Home',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isLocationPermissionGranted ? 'Current Location' : 'Select Location',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    authProvider.user?.name?.substring(0, 1).toUpperCase() ?? 'G',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Location permission banner
  Widget _buildLocationBanner() {
    if (_isLocationPermissionGranted) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_off, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location access is off',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Turn on location to find restaurants near you',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: _requestLocationPermission,
              child: const Text('Enable'),
            ),
          ],
        ),
      ),
    );
  }

  // Swiggy-style search bar
  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/search'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Text(
                  'Search for restaurants and food',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Offers carousel like Swiggy
  Widget _buildOffersCarousel() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppStrings.offers,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                final offer = _offers[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        offer['color'].withOpacity(0.8),
                        offer['color'],
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Categories grid
  Widget _buildCategoriesGrid() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'What\'s on your mind?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to category screen
                  Navigator.pushNamed(context, '/search', arguments: category['name']);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            category['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    category['icon']!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Promoted restaurants section
  Widget _buildPromotedRestaurants() {
    final promotedRestaurants = _dummyRestaurants.where((r) => r['promoted'] == true).toList();
    
    if (promotedRestaurants.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Top picks for you',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: promotedRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = promotedRestaurants[index];
                return _buildPromotedRestaurantCard(restaurant);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPromotedRestaurantCard(Map<String, dynamic> restaurant) {
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
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      restaurant['image'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Icon(
                          Icons.restaurant,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                if (restaurant['discount'] != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        restaurant['discount'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant['cuisine'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant['rating']}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['deliveryTime'],
                        style: const TextStyle(color: AppTheme.textSecondary),
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

  // All restaurants section
  Widget _buildAllRestaurants() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All restaurants',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_dummyRestaurants.length} restaurants delivering to you',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ...(_dummyRestaurants.map((restaurant) => _buildRestaurantListItem(restaurant)).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantListItem(Map<String, dynamic> restaurant) {
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  restaurant['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    child: const Icon(
                      Icons.restaurant,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant['name'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (restaurant['discount'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            restaurant['discount'],
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant['cuisine'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant['rating']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['deliveryTime'],
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        restaurant['deliveryFee'] == 0 
                            ? 'FREE' 
                            : '₹${restaurant['deliveryFee']}',
                        style: TextStyle(
                          color: restaurant['deliveryFee'] == 0 
                              ? AppTheme.successColor 
                              : AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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

    {'id': '163', 'name': 'Sandwich Shop', 'cuisine': 'Deli, Sandwiches', 'rating': 4.2, 'deliveryTime': '20-25 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '164', 'name': 'Hot Dog Haven', 'cuisine': 'American, Hot Dogs', 'rating': 4.0, 'deliveryTime': '10-15 min', 'deliveryFee': 1.49, 'image': 'https://images.unsplash.com/photo-1612392062798-2397609a71fd?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '165', 'name': 'Fish & Chips', 'cuisine': 'British, Seafood', 'rating': 4.4, 'deliveryTime': '25-30 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1544982503-9f984c14501a?w=300&h=200&fit=crop', 'isOpen': false},
    // Additional restaurants to reach 200 total
    {'id': '166', 'name': 'Mediterranean Delight', 'cuisine': 'Mediterranean, Greek', 'rating': 4.5, 'deliveryTime': '30-35 min', 'deliveryFee': 3.49, 'image': 'https://images.unsplash.com/photo-1529059997568-3d847b1154f0?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '167', 'name': 'BBQ Smokehouse', 'cuisine': 'BBQ, Smoked Meat', 'rating': 4.6, 'deliveryTime': '35-40 min', 'deliveryFee': 3.99, 'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '168', 'name': 'Pasta La Vista', 'cuisine': 'Italian, Pasta', 'rating': 4.4, 'deliveryTime': '25-30 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '169', 'name': 'Noodle Express', 'cuisine': 'Asian, Noodles', 'rating': 4.3, 'deliveryTime': '20-25 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '170', 'name': 'Waffle Wonderland', 'cuisine': 'Breakfast, Waffles', 'rating': 4.5, 'deliveryTime': '15-20 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '171', 'name': 'Pancake Paradise', 'cuisine': 'Breakfast, Pancakes', 'rating': 4.4, 'deliveryTime': '20-25 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '172', 'name': 'Steak Station', 'cuisine': 'Steakhouse, Meat', 'rating': 4.7, 'deliveryTime': '40-45 min', 'deliveryFee': 4.99, 'image': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '173', 'name': 'Seafood Shack', 'cuisine': 'Seafood, Fresh Fish', 'rating': 4.6, 'deliveryTime': '35-40 min', 'deliveryFee': 3.99, 'image': 'https://images.unsplash.com/photo-1615141982883-c7ad0e69fd62?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '174', 'name': 'Wings & Things', 'cuisine': 'American, Wings', 'rating': 4.2, 'deliveryTime': '25-30 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '175', 'name': 'Bagel Barn', 'cuisine': 'Breakfast, Bagels', 'rating': 4.3, 'deliveryTime': '15-20 min', 'deliveryFee': 1.49, 'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '176', 'name': 'Taco Truck', 'cuisine': 'Mexican, Street Food', 'rating': 4.1, 'deliveryTime': '10-15 min', 'deliveryFee': 0.99, 'image': 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '177', 'name': 'Korean Kitchen', 'cuisine': 'Korean, Kimchi', 'rating': 4.5, 'deliveryTime': '30-35 min', 'deliveryFee': 3.49, 'image': 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '178', 'name': 'French Bistro', 'cuisine': 'French, Fine Dining', 'rating': 4.8, 'deliveryTime': '45-50 min', 'deliveryFee': 5.99, 'image': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '179', 'name': 'Dim Sum Palace', 'cuisine': 'Chinese, Dim Sum', 'rating': 4.4, 'deliveryTime': '35-40 min', 'deliveryFee': 3.99, 'image': 'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '180', 'name': 'Crepe Corner', 'cuisine': 'French, Crepes', 'rating': 4.3, 'deliveryTime': '20-25 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1506459225024-1428097a7e18?w=300&h=200&fit=crop', 'isOpen': true},
    // Continue with more varieties...
    {'id': '181', 'name': 'Pretzel Place', 'cuisine': 'German, Pretzels', 'rating': 4.2, 'deliveryTime': '15-20 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1609501676725-7186f506c3e8?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '182', 'name': 'Gyro Galaxy', 'cuisine': 'Greek, Gyros', 'rating': 4.4, 'deliveryTime': '20-25 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1529059997568-3d847b1154f0?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '183', 'name': 'Lobster Roll Co', 'cuisine': 'Seafood, Rolls', 'rating': 4.6, 'deliveryTime': '30-35 min', 'deliveryFee': 4.49, 'image': 'https://images.unsplash.com/photo-1559925393-8be0ec4767c8?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '184', 'name': 'Chili House', 'cuisine': 'American, Chili', 'rating': 4.1, 'deliveryTime': '25-30 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1571197119669-c7c9b5442faf?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '185', 'name': 'Falafel Factory', 'cuisine': 'Middle Eastern, Falafel', 'rating': 4.3, 'deliveryTime': '20-25 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '186', 'name': 'Shawarma Stop', 'cuisine': 'Middle Eastern, Shawarma', 'rating': 4.2, 'deliveryTime': '15-20 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '187', 'name': 'Empanada Express', 'cuisine': 'Latin, Empanadas', 'rating': 4.4, 'deliveryTime': '20-25 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '188', 'name': 'Soup & Salad', 'cuisine': 'Healthy, Soups', 'rating': 4.5, 'deliveryTime': '25-30 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '189', 'name': 'Cheese Please', 'cuisine': 'Deli, Cheese', 'rating': 4.3, 'deliveryTime': '20-25 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '190', 'name': 'Muffin Mania', 'cuisine': 'Bakery, Muffins', 'rating': 4.2, 'deliveryTime': '15-20 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '191', 'name': 'Pie Paradise', 'cuisine': 'Bakery, Pies', 'rating': 4.6, 'deliveryTime': '30-35 min', 'deliveryFee': 3.49, 'image': 'https://images.unsplash.com/photo-1464349095431-9ac39bcb3327?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '192', 'name': 'Sub Station', 'cuisine': 'Deli, Subs', 'rating': 4.1, 'deliveryTime': '15-20 min', 'deliveryFee': 1.49, 'image': 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '193', 'name': 'Fondue Fun', 'cuisine': 'Swiss, Fondue', 'rating': 4.7, 'deliveryTime': '40-45 min', 'deliveryFee': 4.99, 'image': 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '194', 'name': 'Quinoa Queen', 'cuisine': 'Healthy, Quinoa', 'rating': 4.4, 'deliveryTime': '25-30 min', 'deliveryFee': 3.49, 'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '195', 'name': 'Smoothie Bowl', 'cuisine': 'Healthy, Bowls', 'rating': 4.5, 'deliveryTime': '15-20 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1553909489-cd47e0ef937f?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '196', 'name': 'Cereal Cafe', 'cuisine': 'Breakfast, Cereal', 'rating': 4.0, 'deliveryTime': '10-15 min', 'deliveryFee': 1.49, 'image': 'https://images.unsplash.com/photo-1574425577270-0d79e31a2b33?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '197', 'name': 'Toast & Jam', 'cuisine': 'Breakfast, Toast', 'rating': 4.3, 'deliveryTime': '10-15 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '198', 'name': 'Hummus Heaven', 'cuisine': 'Middle Eastern, Hummus', 'rating': 4.4, 'deliveryTime': '20-25 min', 'deliveryFee': 2.49, 'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '199', 'name': 'Pickle Palace', 'cuisine': 'Deli, Pickles', 'rating': 4.1, 'deliveryTime': '15-20 min', 'deliveryFee': 1.99, 'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop', 'isOpen': true},
    {'id': '200', 'name': 'Midnight Snacks', 'cuisine': 'Late Night, Snacks', 'rating': 4.2, 'deliveryTime': '20-25 min', 'deliveryFee': 2.99, 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop', 'isOpen': true}
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _requestLocationPermission();
    // Initialize Supabase restaurant fetch
    _supabaseRestaurantsFuture = _dbService.getRestaurantsHybrid().then((restaurants) => 
        restaurants.map((r) => r.toJson()).toList());
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
    // Use the new Supabase-enabled method
    await restaurantProvider.fetchRestaurantsWithSupabase();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _loadRestaurants,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildLocationSection(),
            _buildSearchSection(),
            _buildCategoriesSection(),
            _buildOffersSection(),
            _buildSupabaseRestaurantsSection(),
          _buildPopularRestaurantsSection(),
            _buildRestaurantsSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${_getGreeting()}!',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                authProvider.user?.name ?? 'Guest',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.science), // Demo button
          onPressed: () {
            Navigator.pushNamed(context, '/supabase-demo');
          },
          tooltip: 'Supabase Demo',
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Navigate to notifications
          },
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _isLocationPermissionGranted 
                  ? Icons.location_on 
                  : Icons.location_off,
              color: _isLocationPermissionGranted 
                  ? AppTheme.primaryColor 
                  : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deliver to',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    _isLocationPermissionGranted 
                        ? 'Current Location' 
                        : 'Location not available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to address selection
              },
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/search');
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.textMuted.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.searchRestaurants,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.categories,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show all categories
                  },
                  child: const Text(AppStrings.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _buildCategoryItem(category);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, String> category) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: category['image'] != null
                  ? Image.network(
                      category['image']!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            category['icon'] ?? '🍽️',
                            style: const TextStyle(fontSize: 24),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        category['icon'] ?? '🍽️',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['name'] ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.offers,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '50% OFF',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'On your first order',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply offer
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('Order Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupabaseRestaurantsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Restaurants (Supabase)',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _supabaseRestaurantsFuture = _dbService.getRestaurantsHybrid()
                          .then((restaurants) => restaurants.map((r) => r.toJson()).toList());
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _supabaseRestaurantsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppTheme.errorColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load restaurants',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Error: ${snapshot.error}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.errorColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 48,
                            color: AppTheme.textMuted,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No restaurants found',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  final restaurants = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return _buildSupabaseRestaurantCard(restaurant);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupabaseRestaurantCard(Map<String, dynamic> restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              restaurant: {
                'id': restaurant['id'] ?? 'unknown',
                'name': restaurant['name'] ?? 'Unknown Restaurant',
                'cuisine': restaurant['cuisine'] ?? 'Various',
                'rating': restaurant['rating'] ?? 4.0,
                'deliveryTime': restaurant['delivery_time'] ?? '30-35 min',
                'deliveryFee': restaurant['delivery_fee'] ?? 2.99,
                'image': restaurant['image_url'] ?? '',
                'isOpen': restaurant['is_open'] ?? true,
              },
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: AppTheme.primaryColor.withOpacity(0.1),
            ),
            child: Stack(
              children: [
                Center(
                  child: restaurant['image_url'] != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            restaurant['image_url'],
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.restaurant,
                              size: 48,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.restaurant,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                ),
                // Live indicator
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Name
                Text(
                  restaurant['name'] ?? 'Unknown Restaurant',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // Cuisine
                Text(
                  restaurant['cuisine'] ?? 'Various',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Rating and Info
                Row(
                  children: [
                    if (restaurant['rating'] != null) ...[
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: AppTheme.accentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['rating'].toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (restaurant['delivery_time'] != null) ...[
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['delivery_time'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (restaurant['is_open'] == true) 
                        ? AppTheme.successColor.withOpacity(0.1)
                        : AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (restaurant['is_open'] == true) ? 'Open Now' : 'Closed',
                    style: TextStyle(
                      color: (restaurant['is_open'] == true) 
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantsSection() {
    return Consumer<RestaurantProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.restaurants.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (provider.restaurants.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.restaurant_outlined,
                      size: 64,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No restaurants found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    AppStrings.restaurants,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              
              final restaurant = provider.restaurants[index - 1];
              return _buildRestaurantCard(restaurant);
            },
            childCount: provider.restaurants.length + 1,
          ),
        );
      },
    );
  }

  Widget _buildRestaurantCard(dynamic restaurant) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Image
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: AppTheme.backgroundColor,
            ),
            child: const Center(
              child: Icon(
                Icons.restaurant,
                size: 48,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Name and Favorite Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Sample Restaurant',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // Toggle favorite
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Cuisines
                Text(
                  'Italian, Fast Food',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Rating, Time, and Distance
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 4),
                    const Text('4.2'),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    const Text('30-40 mins'),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    const Text('2.5 km'),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Delivery fee
                Text(
                  'Free Delivery',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildPopularRestaurantsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Restaurants',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show all restaurants
                  },
                  child: const Text(AppStrings.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: _dummyRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = _dummyRestaurants[index];
                  return _buildDummyRestaurantCard(restaurant);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDummyRestaurantCard(Map<String, dynamic> restaurant) {
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
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: AppTheme.primaryColor.withOpacity(0.1),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      restaurant['image'] ?? '',
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  // Status indicator
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: restaurant['isOpen'] == true 
                            ? AppTheme.successColor 
                            : AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        restaurant['isOpen'] == true ? 'OPEN' : 'CLOSED',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () {
                          // Toggle favorite
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    restaurant['name'] ?? 'Unknown Restaurant',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Cuisine
                  Text(
                    restaurant['cuisine'] ?? 'Various',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and Info
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: AppTheme.accentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant['rating'] ?? 0.0}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant['deliveryTime'] ?? 'N/A',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Delivery fee
                  Text(
                    restaurant['deliveryFee'] == 0 
                        ? 'Free Delivery'
                        : 'Delivery ₹${restaurant['deliveryFee']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: restaurant['deliveryFee'] == 0 
                          ? AppTheme.successColor 
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}