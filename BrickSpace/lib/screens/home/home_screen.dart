import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/property_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/featured_property_card.dart';
import '../location/location_selection_screen.dart';
import '../promotion/promotion_detail_screen.dart';
import '../../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    'All',
    'House',
    'Apartment',
    'Home',
  ];

  String _selectedCategory = 'All';
  String _currentLocation = 'Jakarta, Indonesia';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyProvider>().loadProperties();
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await LocationService.instance.getCurrentLocation();
      if (position != null && mounted) {
        setState(() {
          _currentLocation = LocationService.instance.currentLocation;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      // Keep default location
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            _buildTopSection(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Promotional Banners
                    _buildPromotionalBanners(),
                    
                    const SizedBox(height: 24),
                    
                    // Featured Estates
                    _buildFeaturedEstates(),
                    
                    const SizedBox(height: 24),
                    
                    // Top Locations
                    _buildTopLocations(),
                    
                    const SizedBox(height: 24),
                    
                    // Top Estate Agent
                    _buildTopEstateAgent(),
                    
                    const SizedBox(height: 24),
                    
                    // Explore Nearby Estates
                    _buildExploreNearbyEstates(),
                    
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location and Profile Row
          Row(
            children: [
              // Location Selector
              GestureDetector(
                onTap: () async {
                  final result = await context.push('/onboarding/location-selection');
                  if (result != null && mounted) {
                    // Handle location selection result
                    setState(() {
                      _currentLocation = result.toString();
                    });
                    // Update the location service
                    LocationService.instance.setLocation(result.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location updated to: $result'),
                        backgroundColor: const Color(0xFF2E7D32),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      _isLoadingLocation
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            )
                          : Text(
                              _currentLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _getCurrentLocation,
                        child: const Icon(Icons.refresh, size: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Notifications
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, size: 20),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Profile Picture
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.user;
                  return GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                      ),
                      child: user?.profileImage.isNotEmpty == true
                          ? (user!.profileImage.startsWith('http')
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(user.profileImage) as ImageProvider,
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(File(user.profileImage)) as ImageProvider,
                                ))
                          : CircleAvatar(
                              child: const Icon(Icons.person, size: 20),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Greeting
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;
              final firstName = user?.name.split(' ').first ?? 'User';
              return Text(
                'Hey, $firstName!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              );
            },
          ),
          const Text(
            'Let\'s start exploring',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Test Onboarding Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/onboarding/location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Location Setup'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/onboarding/property-types'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Property Types'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Search House, Apartment, etc',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Icon(Icons.mic, color: Colors.grey),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Category Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBanners() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildPromotionalCard(
            title: 'Halloween Sale!',
            imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400&h=200&fit=crop',
          ),
          const SizedBox(width: 16),
          _buildPromotionalCard(
            title: 'Summer Vacation',
            imageUrl: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&h=200&fit=crop',
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalCard({required String title, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        context.push('/promotion-detail');
      },
      child: Container(
        width: 280,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ), ); // Close GestureDetector
  }

  Widget _buildFeaturedEstates() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Estates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push('/featured-estates');
                },
                child: const Text(
                  'view all',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildPropertyCard(
                    title: index == 0 ? 'Sky Dandelions Apartment' : 'The Laurels Villa',
                    price: index == 0 ? '\$290/month' : '\$320/night',
                    rating: 4.3,
                    location: 'Jakarta, Indonesia',
                    imageUrl: index == 0 
                        ? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=200&fit=crop'
                        : 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=200&fit=crop',
                    type: index == 0 ? 'Apartment' : 'Villa',
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard({
    required String title,
    required String price,
    required double rating,
    required String location,
    required String imageUrl,
    required String type,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/properties/1'); // Navigate to property detail
      },
      child: Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with heart icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  width: 180,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () {
                    context.read<FavoritesProvider>().toggleFavorite('property_${index + 1}', context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, child) {
                        return Icon(
                          favoritesProvider.isFavorite('property_${index + 1}') 
                              ? Icons.favorite 
                              : Icons.favorite_border,
                          color: favoritesProvider.isFavorite('property_${index + 1}') 
                              ? const Color(0xFF2E7D32) 
                              : Colors.grey,
                          size: 16,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildTopLocations() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Locations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push('/top-locations');
                },
                child: const Text(
                  'explore',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final locations = [
                  {'name': 'Bali', 'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?w=100&h=100&fit=crop'},
                  {'name': 'Jakarta', 'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=100&h=100&fit=crop'},
                  {'name': 'Yogyakarta', 'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=100&h=100&fit=crop'},
                ];
                
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: index == 1 ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(locations[index]['image']!),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          locations[index]['name']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopEstateAgent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Estate Agent',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push('/agents');
                },
                child: const Text(
                  'explore',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                final agents = [
                  {'name': 'Amanda', 'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face'},
                  {'name': 'Anderson', 'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face'},
                  {'name': 'Samantha', 'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face'},
                  {'name': 'Andrew', 'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face'},
                ];
                
                return GestureDetector(
                  onTap: () {
                    context.push('/agents/${index + 1}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(agents[index]['image']!),
                          ),
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          agents[index]['name']!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
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
    );
  }

  Widget _buildExploreNearbyEstates() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore Nearby Estates',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final properties = [
                {'title': 'Wings Tower', 'price': '\$220/month', 'rating': 4.3, 'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=200&fit=crop'},
                {'title': 'Mill Sper House', 'price': '\$271/month', 'rating': 4.3, 'image': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=200&fit=crop'},
                {'title': 'Bungalow House', 'price': '\$235/month', 'rating': 4.3, 'image': 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=200&fit=crop'},
                {'title': 'Sky Dandelions', 'price': '\$290/month', 'rating': 4.3, 'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=200&fit=crop'},
              ];
              
              return _buildPropertyCard(
                title: properties[index]['title'] as String,
                price: properties[index]['price'] as String,
                rating: properties[index]['rating'] as double,
                location: 'Jakarta, Indonesia',
                imageUrl: properties[index]['image'] as String,
                type: 'House',
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.search, 'Search', false),
          _buildNavItem(Icons.chat, 'Chat', false),
          _buildNavItem(Icons.favorite, 'Favorites', false),
          _buildNavItem(Icons.person, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == 'Search') {
          context.push('/search');
        } else if (label == 'Chat') {
          context.push('/chat-history');
        } else if (label == 'Favorites') {
          context.push('/favorites');
        } else if (label == 'Profile') {
          context.push('/profile');
        }
        // Home is already selected, no action needed
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSelected)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}