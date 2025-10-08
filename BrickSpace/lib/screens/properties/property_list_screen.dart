import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/property_card.dart';
import '../../widgets/search_bar_widget.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'newest';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyProvider>().loadProperties();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => context.push('/filters'),
          ),
        ],
      ),
      body: Consumer2<PropertyProvider, FavoritesProvider>(
        builder: (context, propertyProvider, favoritesProvider, child) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarWidget(
                  onSearch: (query) {
                    propertyProvider.searchProperties(query);
                  },
                  onFilterTap: () => context.push('/filters'),
                ),
              ),

              // Sort Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Sort by:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'newest',
                              child: Text('Newest'),
                            ),
                            DropdownMenuItem(
                              value: 'price_low',
                              child: Text('Price: Low to High'),
                            ),
                            DropdownMenuItem(
                              value: 'price_high',
                              child: Text('Price: High to Low'),
                            ),
                            DropdownMenuItem(
                              value: 'area_large',
                              child: Text('Area: Largest First'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sortBy = value;
                              });
                              _sortProperties();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Properties List
              Expanded(
                child: propertyProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : propertyProvider.properties.isEmpty
                        ? _buildEmptyState(context)
                        : _isGridView
                            ? _buildGridView(context, propertyProvider, favoritesProvider)
                            : _buildListView(context, propertyProvider, favoritesProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<PropertyProvider>().clearFilters();
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, PropertyProvider propertyProvider, FavoritesProvider favoritesProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: propertyProvider.properties.length,
      itemBuilder: (context, index) {
        final property = propertyProvider.properties[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PropertyCard(
            property: property,
            onTap: () => context.push('/properties/${property.id}'),
            onFavoriteToggle: () {
                  favoritesProvider.toggleFavorite(property.id, context);
            },
            isFavorite: favoritesProvider.isFavorite(property.id),
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, PropertyProvider propertyProvider, FavoritesProvider favoritesProvider) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: propertyProvider.properties.length,
      itemBuilder: (context, index) {
        final property = propertyProvider.properties[index];
        return PropertyCard(
          property: property,
          onTap: () => context.push('/properties/${property.id}'),
          onFavoriteToggle: () {
                  favoritesProvider.toggleFavorite(property.id, context);
          },
          isFavorite: favoritesProvider.isFavorite(property.id),
        );
      },
    );
  }

  void _sortProperties() {
    final propertyProvider = context.read<PropertyProvider>();
    // In a real app, you would implement sorting logic here
    // For now, we'll just reload the properties
    propertyProvider.loadProperties();
  }
}
