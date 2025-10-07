import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/property_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final propertyProvider = context.read<PropertyProvider>();
      final favoritesProvider = context.read<FavoritesProvider>();
      
      // Load properties first, then update favorites
      propertyProvider.loadProperties().then((_) {
        favoritesProvider.updateFavoriteProperties(propertyProvider.allProperties);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              if (favoritesProvider.favoriteProperties.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return TextButton(
                onPressed: () {
                  _showClearFavoritesDialog(context);
                },
                child: const Text('Clear All'),
              );
            },
          ),
        ],
      ),
      body: Consumer2<PropertyProvider, FavoritesProvider>(
        builder: (context, propertyProvider, favoritesProvider, child) {
          if (propertyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (favoritesProvider.favoriteProperties.isEmpty) {
            return _buildEmptyFavoritesState(context);
          }

          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${favoritesProvider.favoriteProperties.length} Saved Properties',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    if (favoritesProvider.favoriteProperties.isNotEmpty)
                      TextButton.icon(
                        onPressed: () => context.push('/map'),
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('View on Map'),
                      ),
                  ],
                ),
              ),

              // Favorites List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: favoritesProvider.favoriteProperties.length,
                  itemBuilder: (context, index) {
                    final property = favoritesProvider.favoriteProperties[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PropertyCard(
                        property: property,
                        onTap: () => context.push('/properties/${property.id}'),
                        onFavoriteToggle: () {
                              favoritesProvider.toggleFavorite(property.id, context);
                        },
                        isFavorite: true, // Always true in favorites screen
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyFavoritesState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring properties and save your favorites by tapping the heart icon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.explore),
              label: const Text('Explore Properties'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'Are you sure you want to remove all properties from your favorites? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FavoritesProvider>().clearFavorites();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
