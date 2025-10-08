import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PropertyCategoriesScreen extends StatefulWidget {
  const PropertyCategoriesScreen({super.key});

  @override
  State<PropertyCategoriesScreen> createState() => _PropertyCategoriesScreenState();
}

class _PropertyCategoriesScreenState extends State<PropertyCategoriesScreen> {
  final List<PropertyCategory> _categories = [
    PropertyCategory(
      id: 'house',
      name: 'House',
      icon: Icons.home,
      propertiesCount: 1240,
      imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=200&fit=crop',
    ),
    PropertyCategory(
      id: 'apartment',
      name: 'Apartment',
      icon: Icons.apartment,
      propertiesCount: 890,
      imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=200&fit=crop',
    ),
    PropertyCategory(
      id: 'villa',
      name: 'Villa',
      icon: Icons.villa,
      propertiesCount: 420,
      imageUrl: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=200&fit=crop',
    ),
    PropertyCategory(
      id: 'condo',
      name: 'Condo',
      icon: Icons.business,
      propertiesCount: 650,
      imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=200&fit=crop',
    ),
    PropertyCategory(
      id: 'townhouse',
      name: 'Townhouse',
      icon: Icons.home_work,
      propertiesCount: 320,
      imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=200&fit=crop',
    ),
    PropertyCategory(
      id: 'land',
      name: 'Land',
      icon: Icons.landscape,
      propertiesCount: 180,
      imageUrl: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=200&fit=crop',
    ),
    PropertyCategory(
      id: 'office',
      name: 'Office',
      icon: Icons.business_center,
      propertiesCount: 95,
      imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=200&fit=crop',
    ),
    PropertyCategory(
      id: 'shop',
      name: 'Shop',
      icon: Icons.store,
      propertiesCount: 75,
      imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=300&h=200&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text(
          'Property Categories',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(_categories[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(PropertyCategory category) {
    return GestureDetector(
      onTap: () => _onCategoryTap(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Category Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                category.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Dark overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Category Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${category.propertiesCount} properties',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategoryTap(PropertyCategory category) {
    // Navigate to properties list filtered by category
    context.push('/properties?category=${category.id}');
  }
}

class PropertyCategory {
  final String id;
  final String name;
  final IconData icon;
  final int propertiesCount;
  final String imageUrl;

  PropertyCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.propertiesCount,
    required this.imageUrl,
  });
}