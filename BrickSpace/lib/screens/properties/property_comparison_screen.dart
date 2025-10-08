import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../models/property.dart';

class PropertyComparisonScreen extends StatefulWidget {
  const PropertyComparisonScreen({super.key});

  @override
  State<PropertyComparisonScreen> createState() => _PropertyComparisonScreenState();
}

class _PropertyComparisonScreenState extends State<PropertyComparisonScreen> {
  final List<String> _selectedProperties = [];
  final int _maxComparisons = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Properties'),
        actions: [
          if (_selectedProperties.isNotEmpty)
            TextButton(
              onPressed: _selectedProperties.length >= 2 ? _compareProperties : null,
              child: Text(
                'Compare (${_selectedProperties.length})',
                style: TextStyle(
                  color: _selectedProperties.length >= 2 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey,
                ),
              ),
            ),
        ],
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          if (propertyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Selection Summary
              if (_selectedProperties.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Row(
                    children: [
                      Icon(
                        Icons.compare_arrows,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedProperties.length}/$_maxComparisons properties selected',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _clearSelection,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ),

              // Properties List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: propertyProvider.properties.length,
                  itemBuilder: (context, index) {
                    final property = propertyProvider.properties[index];
                    final isSelected = _selectedProperties.contains(property.id);
                    final canSelect = _selectedProperties.length < _maxComparisons || isSelected;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: canSelect ? () => _toggleProperty(property.id) : null,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Selection Checkbox
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected 
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color: isSelected 
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),

                              // Property Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[300],
                                ),
                                child: property.images.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          property.images.first,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.home, color: Colors.grey);
                                          },
                                        ),
                                      )
                                    : const Icon(Icons.home, color: Colors.grey),
                              ),
                              const SizedBox(width: 16),

                              // Property Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property.title,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      property.formattedPrice,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            property.location,
                                            style: TextStyle(color: Colors.grey[600]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${property.bedrooms} bed • ${property.bathrooms} bath • ${property.area.toStringAsFixed(0)} ${property.areaUnit}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Favorite Button
                              Consumer<FavoritesProvider>(
                                builder: (context, favoritesProvider, child) {
                                  return IconButton(
                                    icon: Icon(
                                      favoritesProvider.isFavorite(property.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: favoritesProvider.isFavorite(property.id)
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      favoritesProvider.toggleFavorite(property.id, context);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
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

  void _toggleProperty(String propertyId) {
    setState(() {
      if (_selectedProperties.contains(propertyId)) {
        _selectedProperties.remove(propertyId);
      } else if (_selectedProperties.length < _maxComparisons) {
        _selectedProperties.add(propertyId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProperties.clear();
    });
  }

  void _compareProperties() {
    if (_selectedProperties.length >= 2) {
      // Navigate to comparison results screen
      context.push('/properties/compare-results', extra: _selectedProperties);
    }
  }
}
