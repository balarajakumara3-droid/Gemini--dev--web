import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MapFilterScreen extends StatefulWidget {
  const MapFilterScreen({super.key});

  @override
  State<MapFilterScreen> createState() => _MapFilterScreenState();
}

class _MapFilterScreenState extends State<MapFilterScreen> {
  RangeValues _priceRange = const RangeValues(100, 2000);
  RangeValues _areaRange = const RangeValues(500, 5000);
  int _selectedBedrooms = 0; // 0 means any
  int _selectedBathrooms = 0; // 0 means any
  String _selectedPropertyType = 'any';
  final List<String> _selectedAmenities = [];
  
  final List<String> _propertyTypes = [
    'any', 'house', 'apartment', 'villa', 'condo', 'townhouse'
  ];
  
  final List<String> _amenities = [
    'Parking', 'Gym', 'Pool', 'Balcony', 'Air Conditioning', 
    'Garden', 'Security', 'Fireplace', 'Storage', 'Near University'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text(
          'Filter Properties',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildSectionTitle('Price Range (per month)'),
                  const SizedBox(height: 16),
                  _buildPriceRangeSlider(),
                  const SizedBox(height: 24),
                  
                  // Area Range
                  _buildSectionTitle('Area (sq ft)'),
                  const SizedBox(height: 16),
                  _buildAreaRangeSlider(),
                  const SizedBox(height: 24),
                  
                  // Bedrooms
                  _buildSectionTitle('Bedrooms'),
                  const SizedBox(height: 16),
                  _buildBedroomSelector(),
                  const SizedBox(height: 24),
                  
                  // Bathrooms
                  _buildSectionTitle('Bathrooms'),
                  const SizedBox(height: 16),
                  _buildBathroomSelector(),
                  const SizedBox(height: 24),
                  
                  // Property Type
                  _buildSectionTitle('Property Type'),
                  const SizedBox(height: 16),
                  _buildPropertyTypeSelector(),
                  const SizedBox(height: 24),
                  
                  // Amenities
                  _buildSectionTitle('Amenities'),
                  const SizedBox(height: 16),
                  _buildAmenitiesSelector(),
                ],
              ),
            ),
          ),
          
          // Apply Button
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          values: _priceRange,
          min: 50,
          max: 5000,
          divisions: 100,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('\$${_priceRange.start.round()}'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('\$${_priceRange.end.round()}'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAreaRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          values: _areaRange,
          min: 100,
          max: 10000,
          divisions: 100,
          labels: RangeLabels(
            '${_areaRange.start.round()}',
            '${_areaRange.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _areaRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${_areaRange.start.round()} sq ft'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${_areaRange.end.round()} sq ft'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBedroomSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          final label = index == 0 ? 'Any' : '${index}+';
          final isSelected = _selectedBedrooms == index;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedBedrooms = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBathroomSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          final label = index == 0 ? 'Any' : '${index}+';
          final isSelected = _selectedBathrooms == index;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedBathrooms = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyTypeSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _propertyTypes.length,
        itemBuilder: (context, index) {
          final type = _propertyTypes[index];
          final isSelected = _selectedPropertyType == type;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPropertyType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Text(
                    type.capitalize(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmenitiesSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _amenities.map((amenity) {
        final isSelected = _selectedAmenities.contains(amenity);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedAmenities.remove(amenity);
              } else {
                _selectedAmenities.add(amenity);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
              ),
            ),
            child: Text(
              amenity,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _applyFilters,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Apply Filters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _applyFilters() {
    // In a real app, this would apply the filters and navigate back to the map
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filters applied successfully'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
    
    context.pop();
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(100, 2000);
      _areaRange = const RangeValues(500, 5000);
      _selectedBedrooms = 0;
      _selectedBathrooms = 0;
      _selectedPropertyType = 'any';
      _selectedAmenities.clear();
    });
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}