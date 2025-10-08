import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyTypesSelectionScreen extends StatefulWidget {
  const PropertyTypesSelectionScreen({super.key});

  @override
  State<PropertyTypesSelectionScreen> createState() => _PropertyTypesSelectionScreenState();
}

class _PropertyTypesSelectionScreenState extends State<PropertyTypesSelectionScreen> {
  final List<Map<String, dynamic>> _propertyTypes = [
    {'name': 'House', 'icon': Icons.home, 'selected': false},
    {'name': 'Apartment', 'icon': Icons.apartment, 'selected': false},
    {'name': 'Villa', 'icon': Icons.villa, 'selected': false},
    {'name': 'Townhouse', 'icon': Icons.home_work, 'selected': false},
    {'name': 'Condo', 'icon': Icons.business, 'selected': false},
    {'name': 'Land', 'icon': Icons.landscape, 'selected': false},
    {'name': 'Office', 'icon': Icons.business_center, 'selected': false},
    {'name': 'Shop', 'icon': Icons.store, 'selected': false},
    {'name': 'Warehouse', 'icon': Icons.warehouse, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    print('PropertyTypesSelectionScreen: initState called - SIMPLIFIED VERSION');
  }

  void _toggleSelection(int index) {
    setState(() {
      _propertyTypes[index]['selected'] = !_propertyTypes[index]['selected'];
    });
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
          'Property Types',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your preferable real estate type',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose the types of properties you\'re interested in',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              // Property Types Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _propertyTypes.length,
                  itemBuilder: (context, index) {
                    final property = _propertyTypes[index];
                    final isSelected = property['selected'] as bool;
                    
                    return GestureDetector(
                      onTap: () => _toggleSelection(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    property['icon'] as IconData,
                                    size: 32,
                                    color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[600],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    property['name'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF4CAF50),
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Show More Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle show more
                  },
                  child: const Text(
                    'Show More',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    print('PropertyTypesSelectionScreen: Navigating to home');
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}