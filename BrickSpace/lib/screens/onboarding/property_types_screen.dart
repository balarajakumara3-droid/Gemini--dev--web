import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';

class PropertyTypesScreen extends StatefulWidget {
  const PropertyTypesScreen({super.key});

  @override
  State<PropertyTypesScreen> createState() => _PropertyTypesScreenState();
}

class _PropertyTypesScreenState extends State<PropertyTypesScreen> {
  List<String> _selectedPropertyTypes = [];
  final List<PropertyType> _propertyTypes = [
    PropertyType(
      name: 'House',
      image: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Apartment',
      image: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Villa',
      image: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Condo',
      image: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Townhouse',
      image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Penthouse',
      image: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Studio',
      image: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Loft',
      image: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Duplex',
      image: 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Bungalow',
      image: 'https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Mansion',
      image: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=300&h=300&fit=crop',
      isSelected: false,
    ),
    PropertyType(
      name: 'Cottage',
      image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=300&h=300&fit=crop',
      isSelected: false,
    ),
  ];

  void _toggleSelection(int index) {
    setState(() {
      _propertyTypes[index].isSelected = !_propertyTypes[index].isSelected;
      
      // Update selected property types list
      if (_propertyTypes[index].isSelected) {
        _selectedPropertyTypes.add(_propertyTypes[index].name);
      } else {
        _selectedPropertyTypes.remove(_propertyTypes[index].name);
      }
    });
  }

  int get _selectedCount => _propertyTypes.where((type) => type.isSelected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Account Setup / Preferable',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select your preferable',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'real estate type',
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _propertyTypes.length,
                itemBuilder: (context, index) {
                  final propertyType = _propertyTypes[index];
                  return GestureDetector(
                    onTap: () => _toggleSelection(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: propertyType.isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.grey[300]!,
                          width: propertyType.isSelected ? 2 : 1,
                        ),
                        boxShadow: propertyType.isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF2E7D32).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            // Property Image
                            Positioned.fill(
                              child: Image.network(
                                propertyType.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.home,
                                      color: Colors.grey,
                                      size: 32,
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Overlay
                            if (propertyType.isSelected)
                              Container(
                                color: const Color(0xFF2E7D32).withOpacity(0.3),
                              ),

                            // Selection Indicator
                            if (propertyType.isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E7D32),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),

                            // Property Name
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  propertyType.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Show More Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle show more functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('More property types coming soon!'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
          ),

          const SizedBox(height: 24),

          // Continue Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPropertyTypes.isNotEmpty
                    ? () {
                        // Save property types to onboarding provider
                        final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
                        onboardingProvider.setPropertyTypes(_selectedPropertyTypes);
                        onboardingProvider.nextStep();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
          ),

          const SizedBox(height: 32),

          // Progress Indicator
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class PropertyType {
  final String name;
  final String image;
  bool isSelected;

  PropertyType({
    required this.name,
    required this.image,
    required this.isSelected,
  });
}