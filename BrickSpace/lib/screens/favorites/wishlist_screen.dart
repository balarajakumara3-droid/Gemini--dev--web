import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/property.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/property_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final propertyProvider = context.read<PropertyProvider>();
      final favoritesProvider = context.read<FavoritesProvider>();
      
      // Load properties first, then update favorites
      if (propertyProvider.allProperties.isEmpty) {
        propertyProvider.loadProperties().then((_) {
          favoritesProvider.updateFavoriteProperties(propertyProvider.allProperties);
        });
      } else {
        favoritesProvider.updateFavoriteProperties(propertyProvider.allProperties);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer3<AuthProvider, PropertyProvider, FavoritesProvider>(
        builder: (context, authProvider, propertyProvider, favoritesProvider, child) {
          // Check if we have favorites to display
          if (favoritesProvider.favoriteProperties.isEmpty && favoritesProvider.favoriteIds.isNotEmpty) {
            // If we have favorite IDs but no favorite properties, update them
            favoritesProvider.updateFavoriteProperties(propertyProvider.allProperties);
          }

          final favoriteProperties = favoritesProvider.favoriteProperties;
          
          if (favoriteProperties.isEmpty) {
            return _buildEmptyState(context);
          }
          
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You have ${favoriteProperties.length} properties in your wishlist',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: favoriteProperties.length,
                    itemBuilder: (context, index) {
                      final property = favoriteProperties[index];
                      return PropertyCard(
                        property: property,
                        isFavorite: true,
                        onFavoriteToggle: () {
                          favoritesProvider.toggleFavorite(property.id, context);
                        },
                        onTap: () {
                          context.push('/properties/${property.id}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start adding properties to your wishlist',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen to browse properties
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Browse Properties',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}