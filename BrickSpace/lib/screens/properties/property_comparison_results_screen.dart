import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../models/property.dart';

class PropertyComparisonResultsScreen extends StatelessWidget {
  final List<String> propertyIds;

  const PropertyComparisonResultsScreen({
    super.key,
    required this.propertyIds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareComparison(context),
          ),
        ],
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          final properties = propertyProvider.properties
              .where((p) => propertyIds.contains(p.id))
              .toList();

          if (properties.isEmpty) {
            return const Center(
              child: Text('No properties to compare'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Properties Header
                _buildPropertiesHeader(context, properties),
                const SizedBox(height: 24),

                // Comparison Table
                _buildComparisonTable(context, properties),
                const SizedBox(height: 24),

                // Key Features Comparison
                _buildFeaturesComparison(context, properties),
                const SizedBox(height: 24),

                // Price Analysis
                _buildPriceAnalysis(context, properties),
                const SizedBox(height: 24),

                // Recommendations
                _buildRecommendations(context, properties),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertiesHeader(BuildContext context, List<Property> properties) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comparing ${properties.length} Properties',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: properties.map((property) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 120,
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
                        const SizedBox(height: 8),
                        Text(
                          property.title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          property.formattedPrice,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable(BuildContext context, List<Property> properties) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Feature', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ...properties.map((p) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        p.title.split(' ').take(2).join(' '),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
                // Price row
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Price'),
                    ),
                    ...properties.map((p) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        p.formattedPrice,
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
                // Bedrooms row
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Bedrooms'),
                    ),
                    ...properties.map((p) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        p.bedrooms.toString(),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
                // Bathrooms row
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Bathrooms'),
                    ),
                    ...properties.map((p) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        p.bathrooms.toString(),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
                // Area row
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Area'),
                    ),
                    ...properties.map((p) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${p.area.toStringAsFixed(0)} ${p.areaUnit}',
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
                // Property Type row
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Property Type'),
                    ),
                    ...properties.map((p) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        p.propertyType,
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
                // Location row
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Location'),
                    ),
                    ...properties.map((p) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        p.location,
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesComparison(BuildContext context, List<Property> properties) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Features',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...properties.map((property) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: property.amenities.take(6).map((amenity) {
                        return Chip(
                          label: Text(amenity),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAnalysis(BuildContext context, List<Property> properties) {
    final prices = properties.map((p) => p.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Analysis',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPriceCard(
                    context,
                    'Lowest',
                    '\$${minPrice.toStringAsFixed(0)}',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPriceCard(
                    context,
                    'Average',
                    '\$${avgPrice.toStringAsFixed(0)}',
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPriceCard(
                    context,
                    'Highest',
                    '\$${maxPrice.toStringAsFixed(0)}',
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, List<Property> properties) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...properties.map((property) {
              String recommendation = '';
              Color color = Colors.green;
              
              if (property.price == properties.map((p) => p.price).reduce((a, b) => a < b ? a : b)) {
                recommendation = 'Best Value - Lowest price with good features';
                color = Colors.green;
              } else if (property.area == properties.map((p) => p.area).reduce((a, b) => a > b ? a : b)) {
                recommendation = 'Largest Space - Most square footage';
                color = Colors.blue;
              } else if (property.amenities.length == properties.map((p) => p.amenities.length).reduce((a, b) => a > b ? a : b)) {
                recommendation = 'Most Amenities - Best equipped property';
                color = Colors.purple;
              } else {
                recommendation = 'Good Option - Balanced features and price';
                color = Colors.orange;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            recommendation,
                            style: TextStyle(color: color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _shareComparison(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comparison shared!')),
    );
  }
}
