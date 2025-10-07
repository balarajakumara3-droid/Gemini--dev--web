import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyTypesSelectionScreen extends StatefulWidget {
  const PropertyTypesSelectionScreen({super.key});

  @override
  State<PropertyTypesSelectionScreen> createState() => _PropertyTypesSelectionScreenState();
}

class _PropertyTypesSelectionScreenState extends State<PropertyTypesSelectionScreen> {
  final List<Map<String, dynamic>> _propertyTypes = [
    {
      'name': 'House',
      'image': 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Apartment',
      'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Villa',
      'image': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Condo',
      'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Townhouse',
      'image': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Penthouse',
      'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Studio',
      'image': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Loft',
      'image': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=300&h=200&fit=crop',
      'selected': false,
    },
    {
      'name': 'Duplex',
      'image': 'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=300&h=200&fit=crop',
      'selected': false,
    },
  ];

  void _toggleSelection(int index) {
    setState(() {
      _propertyTypes[index]['selected'] = !_propertyTypes[index]['selected'];
    });
  }

  List<Map<String, dynamic>> get _selectedPropertyTypes {
    return _propertyTypes.where((property) => property['selected'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Account Setup / Pr...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.go('/home');
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select your preferable real estate type',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can edit this later on your account setting.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Property Types Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
                ),
                itemCount: _propertyTypes.length,
                itemBuilder: (context, index) {
                  final property = _propertyTypes[index];
                  final isSelected = property['selected'] as bool;
                  
                  return GestureDetector(
                    onTap: () => _toggleSelection(index),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    property['image'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                property['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? const Color(0xFF4CAF50) : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show more property types
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Show More',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedPropertyTypes.isNotEmpty
                        ? () {
                            context.go('/home');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPropertyTypes.isNotEmpty 
                          ? const Color(0xFF4CAF50) 
                          : Colors.grey[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}