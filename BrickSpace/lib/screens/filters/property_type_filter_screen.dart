import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyTypeFilterScreen extends StatefulWidget {
  const PropertyTypeFilterScreen({super.key});

  @override
  State<PropertyTypeFilterScreen> createState() => _PropertyTypeFilterScreenState();
}

class _PropertyTypeFilterScreenState extends State<PropertyTypeFilterScreen> {
  final Set<String> _selectedTypes = {};

  final List<Map<String, dynamic>> _propertyTypes = [
    {
      'id': 'house',
      'name': 'House',
      'icon': Icons.home,
      'description': 'Single family homes',
      'count': 324,
    },
    {
      'id': 'apartment',
      'name': 'Apartment',
      'icon': Icons.apartment,
      'description': 'Multi-unit buildings',
      'count': 456,
    },
    {
      'id': 'villa',
      'name': 'Villa',
      'icon': Icons.villa,
      'description': 'Luxury villas',
      'count': 189,
    },
    {
      'id': 'condo',
      'name': 'Condo',
      'icon': Icons.business,
      'description': 'Condominium units',
      'count': 267,
    },
    {
      'id': 'townhouse',
      'name': 'Townhouse',
      'icon': Icons.holiday_village,
      'description': 'Row houses',
      'count': 145,
    },
    {
      'id': 'studio',
      'name': 'Studio',
      'icon': Icons.bed,
      'description': 'Compact living',
      'count': 203,
    },
    {
      'id': 'penthouse',
      'name': 'Penthouse',
      'icon': Icons.roofing,
      'description': 'Top floor luxury',
      'count': 87,
    },
    {
      'id': 'duplex',
      'name': 'Duplex',
      'icon': Icons.stairs,
      'description': 'Two-story units',
      'count': 112,
    },
  ];

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
          'Property Type',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedTypes.clear();
              });
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Selected count
          if (_selectedTypes.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedTypes.length} property type(s) selected',
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Property Types Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.82,
              ),
              itemCount: _propertyTypes.length,
              itemBuilder: (context, index) {
                final propertyType = _propertyTypes[index];
                final isSelected = _selectedTypes.contains(propertyType['id']);
                
                return _buildPropertyTypeCard(
                  propertyType: propertyType,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTypes.remove(propertyType['id']);
                      } else {
                        _selectedTypes.add(propertyType['id']);
                      }
                    });
                  },
                );
              },
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedTypes.isEmpty
                      ? null
                      : () {
                          context.pop({
                            'propertyTypes': _selectedTypes.toList(),
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedTypes.isEmpty
                        ? 'Select at least one type'
                        : 'Apply Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedTypes.isEmpty ? Colors.grey[600] : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeCard({
    required Map<String, dynamic> propertyType,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                propertyType['icon'],
                size: 32,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Property Type Name
            Text(
              propertyType['name'],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
              ),
            ),
            
            const SizedBox(height: 2),
            
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                propertyType['description'],
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${propertyType['count']} units',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[700],
                ),
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
