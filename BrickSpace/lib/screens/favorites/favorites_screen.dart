import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../models/property.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Load properties and update favorites when the screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFavorites();
    });
  }

  void _refreshFavorites() {
    try {
      final propertyProvider = context.read<PropertyProvider>();
      final favoritesProvider = context.read<FavoritesProvider>();
      
      // Ensure properties are loaded
      if (propertyProvider.allProperties.isEmpty) {
        propertyProvider.loadProperties().then((_) {
          favoritesProvider.updateFavoriteProperties(propertyProvider.allProperties);
        }).catchError((error) {
          print('Error loading properties: $error');
        });
      } else {
        favoritesProvider.updateFavoriteProperties(propertyProvider.allProperties);
      }
    } catch (e) {
      print('Error refreshing favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.view_module, color: Colors.black87),
            onPressed: () {
              // Toggle between list and grid view
            },
          ),
        ],
      ),
      body: Consumer2<PropertyProvider, FavoritesProvider>(
        builder: (context, propertyProvider, favoritesProvider, child) {
          // Check if we have favorites to display
          if (favoritesProvider.favoriteProperties.isEmpty && favoritesProvider.favoriteIds.isNotEmpty) {
            favoritesProvider.updateFavoriteProperties(propertyProvider.allProperties);
          }

          if (propertyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4CAF50),
              ),
            );
          }

          if (favoritesProvider.favoriteProperties.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Save properties you love to easily find them later',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Explore Properties',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header with count
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${favoritesProvider.favoriteProperties.length} Properties',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // Clear all favorites with confirmation
                        _showClearAllDialog(context, favoritesProvider);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Clear All'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              // Property List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _refreshFavorites();
                  },
                  color: const Color(0xFF4CAF50),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoritesProvider.favoriteProperties.length,
                    itemBuilder: (context, index) {
                      final property = favoritesProvider.favoriteProperties[index];
                      return _buildPropertyCard(property, favoritesProvider);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  void _showClearAllDialog(BuildContext context, FavoritesProvider favoritesProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Favorites?'),
        content: const Text('Are you sure you want to remove all properties from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Create a copy of the property IDs to avoid concurrent modification
              final propertyIds = favoritesProvider.favoriteProperties
                  .map((property) => property.id)
                  .toList();
              
              // Clear all favorites using the copied IDs
              for (var propertyId in propertyIds) {
                favoritesProvider.toggleFavorite(propertyId, context);
              }
              
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All favorites cleared'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Property property, FavoritesProvider favoritesProvider) {
    return Dismissible(
      key: ValueKey('${property.id}_${DateTime.now().millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        // Save property details before removal
        final propertyId = property.id;
        final propertyTitle = property.title;
        
        // Wait for animation to complete before modifying provider
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Now safely remove from favorites
        if (mounted) {
          favoritesProvider.toggleFavorite(propertyId, context);
          
          // Show snackbar with undo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$propertyTitle removed from favorites'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Undo',
                textColor: Colors.white,
                onPressed: () {
                  favoritesProvider.toggleFavorite(propertyId, context);
                },
              ),
            ),
          );
        }
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: () {
            context.push('/properties/${property.id}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: property.imageUrls.isNotEmpty
                      ? Image.network(
                          property.imageUrls.first,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.home, color: Colors.grey, size: 40),
                            );
                          },
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.home, color: Colors.grey, size: 40),
                        ),
                ),
                const SizedBox(width: 12),
                // Property details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        property.propertyInfo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            property.formattedPrice,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              favoritesProvider.toggleFavorite(property.id, context);
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 24,
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
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      selectedItemColor: const Color(0xFF4CAF50),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          activeIcon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/search');
            break;
          case 2:
            // Already on favorites
            break;
          case 3:
            context.go('/chat-history');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
    );
  }
}
