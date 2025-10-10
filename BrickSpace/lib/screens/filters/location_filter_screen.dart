import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationFilterScreen extends StatefulWidget {
  const LocationFilterScreen({super.key});

  @override
  State<LocationFilterScreen> createState() => _LocationFilterScreenState();
}

class _LocationFilterScreenState extends State<LocationFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedLocations = {};

  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Jakarta, Indonesia',
      'properties': 245,
      'icon': Icons.location_city,
    },
    {
      'name': 'Bali, Indonesia',
      'properties': 189,
      'icon': Icons.beach_access,
    },
    {
      'name': 'Surabaya, Indonesia',
      'properties': 156,
      'icon': Icons.location_city,
    },
    {
      'name': 'Bandung, Indonesia',
      'properties': 134,
      'icon': Icons.landscape,
    },
    {
      'name': 'Yogyakarta, Indonesia',
      'properties': 98,
      'icon': Icons.temple_buddhist,
    },
    {
      'name': 'Medan, Indonesia',
      'properties': 87,
      'icon': Icons.location_city,
    },
    {
      'name': 'Semarang, Indonesia',
      'properties': 76,
      'icon': Icons.location_city,
    },
    {
      'name': 'Makassar, Indonesia',
      'properties': 65,
      'icon': Icons.sailing,
    },
  ];

  List<Map<String, dynamic>> get _filteredLocations {
    if (_searchQuery.isEmpty) {
      return _locations;
    }
    return _locations.where((location) {
      return location['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Location',
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
                _selectedLocations.clear();
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
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search location...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Selected count
          if (_selectedLocations.isNotEmpty)
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
                    '${_selectedLocations.length} location(s) selected',
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Locations List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredLocations.length,
              itemBuilder: (context, index) {
                final location = _filteredLocations[index];
                final isSelected = _selectedLocations.contains(location['name']);
                
                return _buildLocationCard(
                  location: location,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedLocations.remove(location['name']);
                      } else {
                        _selectedLocations.add(location['name']);
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
                  onPressed: _selectedLocations.isEmpty
                      ? null
                      : () {
                          context.pop({
                            'locations': _selectedLocations.toList(),
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
                    _selectedLocations.isEmpty
                        ? 'Select at least one location'
                        : 'Apply Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedLocations.isEmpty ? Colors.grey[600] : Colors.white,
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

  Widget _buildLocationCard({
    required Map<String, dynamic> location,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                location['icon'],
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[600],
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Location Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${location['properties']} properties',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
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
