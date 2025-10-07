import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../widgets/custom_button.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final List<String> _propertyTypes = [
    'Apartment',
    'House',
    'Villa',
    'Studio',
    'Penthouse',
  ];

  final List<String> _amenities = [
    'Parking',
    'Gym',
    'Pool',
    'Balcony',
    'Air Conditioning',
    'Security',
    'Garden',
    'Fireplace',
    'Elevator',
    'Concierge',
  ];

  String _selectedPropertyType = '';
  String _selectedListingType = '';
  double _minPrice = 0;
  double _maxPrice = 1000000;
  int _minBedrooms = 0;
  int _minBathrooms = 0;
  List<String> _selectedAmenities = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  void _loadCurrentFilters() {
    final propertyProvider = context.read<PropertyProvider>();
    final filters = propertyProvider.filters;

    setState(() {
      _selectedPropertyType = filters['propertyType'] ?? '';
      _selectedListingType = filters['listingType'] ?? '';
      _minPrice = (filters['minPrice'] ?? 0).toDouble();
      _maxPrice = (filters['maxPrice'] ?? 1000000).toDouble();
      _minBedrooms = filters['bedrooms'] ?? 0;
      _minBathrooms = filters['bathrooms'] ?? 0;
      _selectedAmenities = List<String>.from(filters['amenities'] ?? []);
    });
  }

  void _applyFilters() {
    final propertyProvider = context.read<PropertyProvider>();
    
    final filters = <String, dynamic>{};
    
    if (_selectedPropertyType.isNotEmpty) {
      filters['propertyType'] = _selectedPropertyType.toLowerCase();
    }
    
    if (_selectedListingType.isNotEmpty) {
      filters['listingType'] = _selectedListingType;
    }
    
    if (_minPrice > 0) {
      filters['minPrice'] = _minPrice;
    }
    
    if (_maxPrice < 1000000) {
      filters['maxPrice'] = _maxPrice;
    }
    
    if (_minBedrooms > 0) {
      filters['bedrooms'] = _minBedrooms;
    }
    
    if (_minBathrooms > 0) {
      filters['bathrooms'] = _minBathrooms;
    }
    
    if (_selectedAmenities.isNotEmpty) {
      filters['amenities'] = _selectedAmenities;
    }
    
    propertyProvider.updateFilters(filters);
    context.pop();
  }

  void _clearFilters() {
    setState(() {
      _selectedPropertyType = '';
      _selectedListingType = '';
      _minPrice = 0;
      _maxPrice = 1000000;
      _minBedrooms = 0;
      _minBathrooms = 0;
      _selectedAmenities.clear();
    });
    
    context.read<PropertyProvider>().clearFilters();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Clear All'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Type
            _buildSectionTitle('Property Type'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _propertyTypes.map((type) {
                final isSelected = _selectedPropertyType == type;
                return FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPropertyType = selected ? type : '';
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Listing Type
            _buildSectionTitle('Listing Type'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildListingTypeChip('Rent', 'rent'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildListingTypeChip('Sale', 'sale'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Price Range
            _buildSectionTitle('Price Range'),
            const SizedBox(height: 12),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 1000000,
              divisions: 100,
              labels: RangeLabels(
                '\$${_minPrice.toStringAsFixed(0)}',
                '\$${_maxPrice.toStringAsFixed(0)}',
              ),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
            ),

            const SizedBox(height: 24),

            // Bedrooms
            _buildSectionTitle('Minimum Bedrooms'),
            const SizedBox(height: 12),
            Row(
              children: List.generate(5, (index) {
                final bedrooms = index;
                final isSelected = _minBedrooms == bedrooms;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(bedrooms == 0 ? 'Any' : '$bedrooms+'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _minBedrooms = selected ? bedrooms : 0;
                      });
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Bathrooms
            _buildSectionTitle('Minimum Bathrooms'),
            const SizedBox(height: 12),
            Row(
              children: List.generate(4, (index) {
                final bathrooms = index;
                final isSelected = _minBathrooms == bathrooms;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(bathrooms == 0 ? 'Any' : '$bathrooms+'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _minBathrooms = selected ? bathrooms : 0;
                      });
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Amenities
            _buildSectionTitle('Amenities'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _amenities.map((amenity) {
                final isSelected = _selectedAmenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAmenities.add(amenity);
                      } else {
                        _selectedAmenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Apply Button
            CustomButton(
              text: 'Apply Filters',
              onPressed: _applyFilters,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildListingTypeChip(String label, String value) {
    final isSelected = _selectedListingType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedListingType = isSelected ? '' : value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected 
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
