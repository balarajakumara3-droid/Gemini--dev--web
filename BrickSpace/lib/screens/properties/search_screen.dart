import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/property_card.dart';
import '../../widgets/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        title: const Text('Search Properties'),
        actions: [
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
                    setState(() {
                      _searchQuery = query;
                    });
                    propertyProvider.searchProperties(query);
                  },
                  onFilterTap: () => context.push('/filters'),
                ),
              ),

              // Search Results
              Expanded(
                child: _searchQuery.isEmpty
                    ? _buildEmptySearchState(context)
                    : propertyProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : propertyProvider.properties.isEmpty
                            ? _buildNoResultsState(context)
                            : _buildSearchResults(context, propertyProvider, favoritesProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySearchState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Search Properties',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a location, property type, or keyword to find your perfect home',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/filters'),
              icon: const Icon(Icons.tune),
              label: const Text('Advanced Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
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
              'No Results Found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria or use different keywords',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.read<PropertyProvider>().clearFilters();
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  child: const Text('Clear Search'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => context.push('/filters'),
                  child: const Text('Use Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, PropertyProvider propertyProvider, FavoritesProvider favoritesProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${propertyProvider.properties.length} properties found for "$_searchQuery"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
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
          ),
        ),
      ],
    );
  }
}
