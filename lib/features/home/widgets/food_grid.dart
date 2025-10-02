import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/services/json_food_service.dart';
import '../../food/screens/food_detail_screen.dart';

class FoodGrid extends StatefulWidget {
  const FoodGrid({Key? key}) : super(key: key);

  @override
  State<FoodGrid> createState() => _FoodGridState();
}

class _FoodGridState extends State<FoodGrid> {
  final JsonFoodService _foodService = JsonFoodService();
  List<Map<String, dynamic>> _foodItems = [];
  List<String> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFoodData();
  }

  Future<void> _loadFoodData() async {
    try {
      await _foodService.initialize();
      
      setState(() {
        _foodItems = _foodService.getAllFoodItems();
        _categories = _foodService.getCategories();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_error != null || _foodItems.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.restaurant_menu, size: 64, color: Colors.orange[300]),
                const SizedBox(height: 16),
                Text(
                  'Your Food Collection',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Delicious food items loaded from your data',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        // Categories section
        if (_categories.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(_categories[index]);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Food items section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'All Food Items',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Food grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _foodItems.length,
            itemBuilder: (context, index) {
              return _buildFoodCard(_foodItems[index]);
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildCategoryCard(String category) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: Colors.orange[700],
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant food':
        return Icons.restaurant;
      case 'homemade food':
        return Icons.home;
      case 'raw vegetables and fruits':
        return Icons.local_grocery_store;
      case 'packaged food':
        return Icons.inventory_2;
      default:
        return Icons.fastfood;
    }
  }

  Widget _buildFoodCard(Map<String, dynamic> item) {
    String name = _getValueFromRow(item, ['dish_name', 'name', 'title']) ?? 'Unknown Item';
    String foodType = _getValueFromRow(item, ['food_type', 'category', 'type']) ?? '';
    String price = _getValueFromRow(item, ['price', 'cost']) ?? '12.99';
    String imageUrl = _getValueFromRow(item, ['image_url', 'image']) ?? '';
    String ingredients = _getValueFromRow(item, ['ingredients']) ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(foodItem: item),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  child: imageUrl.isNotEmpty && _isValidImageUrl(imageUrl)
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.fastfood, size: 32, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.fastfood, size: 32, color: Colors.grey),
                          ),
                        ),
                ),
              ),
            ),
            
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Food type
                    if (foodType.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          foodType,
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Price and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${_parsePrice(price).toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            const SizedBox(width: 2),
                            Text('4.2', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getValueFromRow(Map<String, dynamic> row, List<String> possibleKeys) {
    for (String key in possibleKeys) {
      if (row.containsKey(key) && row[key] != null && row[key].toString().isNotEmpty) {
        return row[key].toString();
      }
      
      for (String rowKey in row.keys) {
        if (rowKey.toLowerCase() == key.toLowerCase() && 
            row[rowKey] != null && 
            row[rowKey].toString().isNotEmpty) {
          return row[rowKey].toString();
        }
      }
    }
    return null;
  }

  bool _isValidImageUrl(String url) {
    return url.startsWith('http') || 
           url.contains('.jpg') || 
           url.contains('.png') || 
           url.contains('.jpeg') || 
           url.contains('.webp');
  }

  double _parsePrice(String priceStr) {
    if (priceStr.isEmpty) return 12.99;
    String cleanPrice = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 12.99;
  }
}
