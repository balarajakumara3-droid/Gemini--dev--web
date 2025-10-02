import 'package:flutter/foundation.dart';
import 'excel_service.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import '../models/category.dart';

class FoodCatalogService {
  static final FoodCatalogService _instance = FoodCatalogService._internal();
  factory FoodCatalogService() => _instance;
  FoodCatalogService._internal();

  final ExcelService _excelService = ExcelService();
  final String _catalogFileName = 'food_images_catalog_urls.xlsx';

  /// Load all food catalog data from Excel
  Future<List<Map<String, dynamic>>> loadCatalogData() async {
    try {
      return await _excelService.readExcelData(_catalogFileName);
    } catch (e) {
      debugPrint('Error loading food catalog: $e');
      return [];
    }
  }

  /// Get all available categories from the catalog
  Future<List<Category>> getCategories() async {
    try {
      List<Map<String, dynamic>> data = await loadCatalogData();
      Set<String> categoryNames = {};
      
      for (var row in data) {
        String category = row['Category']?.toString() ?? '';
        if (category.isNotEmpty) {
          categoryNames.add(category);
        }
      }

      return categoryNames.map((name) => Category(
        id: name.toLowerCase().replaceAll(' ', '_'),
        name: name,
        description: 'Delicious $name items',
        imageUrl: _getCategoryImageUrl(name),
      )).toList();
    } catch (e) {
      debugPrint('Error getting categories: $e');
      return [];
    }
  }

  /// Get menu items from the catalog
  Future<List<MenuItem>> getMenuItems({String? category}) async {
    try {
      List<Map<String, dynamic>> data = await loadCatalogData();
      
      if (category != null) {
        data = data.where((row) => 
          row['Category']?.toString().toLowerCase() == category.toLowerCase()
        ).toList();
      }

      return data.map((row) => MenuItem(
        id: row['ID']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantId: row['Restaurant_ID']?.toString() ?? 'default_restaurant',
        categoryId: row['Category']?.toString().toLowerCase().replaceAll(' ', '_'),
        name: row['Name']?.toString() ?? 'Unknown Item',
        description: row['Description']?.toString() ?? '',
        price: _parsePrice(row['Price']?.toString()),
        imageUrl: row['Image_URL']?.toString() ?? '',
        isAvailable: _parseBoolean(row['Available']?.toString()),
        tags: _parseTags(row['Tags']?.toString()),
        preparationTimeMinutes: _parseInt(row['Prep_Time']?.toString()) ?? 15,
      )).toList();
    } catch (e) {
      debugPrint('Error getting menu items: $e');
      return [];
    }
  }

  /// Get restaurants from the catalog
  Future<List<Restaurant>> getRestaurants() async {
    try {
      List<Map<String, dynamic>> data = await loadCatalogData();
      Map<String, Map<String, dynamic>> restaurantMap = {};

      // Group items by restaurant
      for (var row in data) {
        String restaurantId = row['Restaurant_ID']?.toString() ?? 'default';
        String restaurantName = row['Restaurant_Name']?.toString() ?? 'Unknown Restaurant';
        
        if (!restaurantMap.containsKey(restaurantId)) {
          restaurantMap[restaurantId] = {
            'id': restaurantId,
            'name': restaurantName,
            'description': row['Restaurant_Description']?.toString() ?? 'Great food restaurant',
            'image_url': row['Restaurant_Image']?.toString() ?? '',
            'cuisines': <String>{},
            'rating': _parseDouble(row['Restaurant_Rating']?.toString()) ?? 4.0,
            'delivery_time': row['Delivery_Time']?.toString() ?? '30-45 mins',
            'delivery_fee': _parseDouble(row['Delivery_Fee']?.toString()) ?? 2.99,
            'minimum_order': _parseDouble(row['Minimum_Order']?.toString()) ?? 15.0,
            'is_open': _parseBoolean(row['Is_Open']?.toString()) ?? true,
          };
        }
        
        // Add cuisine to set
        String cuisine = row['Category']?.toString() ?? '';
        if (cuisine.isNotEmpty) {
          (restaurantMap[restaurantId]!['cuisines'] as Set<String>).add(cuisine);
        }
      }

      // Convert to Restaurant objects
      return restaurantMap.values.map((data) => Restaurant(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        imageUrl: data['image_url'],
        cuisines: (data['cuisines'] as Set<String>).toList(),
        rating: data['rating'],
        reviewCount: 100, // Default value
        deliveryTime: data['delivery_time'],
        deliveryFee: data['delivery_fee'],
        minimumOrder: data['minimum_order'],
        isOpen: data['is_open'],
        address: Address(
          street: '123 Food Street',
          city: 'Food City',
          state: 'FC',
          zipCode: '12345',
          country: 'Food Country',
        ),
      )).toList();
    } catch (e) {
      debugPrint('Error getting restaurants: $e');
      return [];
    }
  }

  /// Search for food items by name or description
  Future<List<MenuItem>> searchFoodItems(String query) async {
    try {
      List<Map<String, dynamic>> data = await _excelService.searchInExcel(
        _catalogFileName, 
        query,
        caseSensitive: false
      );

      return data.map((row) => MenuItem(
        id: row['ID']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantId: row['Restaurant_ID']?.toString() ?? 'default_restaurant',
        categoryId: row['Category']?.toString().toLowerCase().replaceAll(' ', '_'),
        name: row['Name']?.toString() ?? 'Unknown Item',
        description: row['Description']?.toString() ?? '',
        price: _parsePrice(row['Price']?.toString()),
        imageUrl: row['Image_URL']?.toString() ?? '',
        isAvailable: _parseBoolean(row['Available']?.toString()),
        tags: _parseTags(row['Tags']?.toString()),
        preparationTimeMinutes: _parseInt(row['Prep_Time']?.toString()) ?? 15,
      )).toList();
    } catch (e) {
      debugPrint('Error searching food items: $e');
      return [];
    }
  }

  /// Get food items by restaurant
  Future<List<MenuItem>> getFoodItemsByRestaurant(String restaurantId) async {
    try {
      List<Map<String, dynamic>> data = await loadCatalogData();
      
      data = data.where((row) => 
        row['Restaurant_ID']?.toString() == restaurantId
      ).toList();

      return data.map((row) => MenuItem(
        id: row['ID']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantId: restaurantId,
        categoryId: row['Category']?.toString().toLowerCase().replaceAll(' ', '_'),
        name: row['Name']?.toString() ?? 'Unknown Item',
        description: row['Description']?.toString() ?? '',
        price: _parsePrice(row['Price']?.toString()),
        imageUrl: row['Image_URL']?.toString() ?? '',
        isAvailable: _parseBoolean(row['Available']?.toString()),
        tags: _parseTags(row['Tags']?.toString()),
        preparationTimeMinutes: _parseInt(row['Prep_Time']?.toString()) ?? 15,
      )).toList();
    } catch (e) {
      debugPrint('Error getting food items by restaurant: $e');
      return [];
    }
  }

  /// Get catalog statistics
  Future<Map<String, int>> getCatalogStats() async {
    try {
      List<Map<String, dynamic>> data = await loadCatalogData();
      
      Set<String> restaurants = {};
      Set<String> categories = {};
      int totalItems = data.length;
      int availableItems = 0;

      for (var row in data) {
        restaurants.add(row['Restaurant_ID']?.toString() ?? '');
        categories.add(row['Category']?.toString() ?? '');
        if (_parseBoolean(row['Available']?.toString()) == true) {
          availableItems++;
        }
      }

      return {
        'total_items': totalItems,
        'available_items': availableItems,
        'restaurants': restaurants.length,
        'categories': categories.length,
      };
    } catch (e) {
      debugPrint('Error getting catalog stats: $e');
      return {};
    }
  }

  // Helper methods
  double _parsePrice(String? priceStr) {
    if (priceStr == null || priceStr.isEmpty) return 0.0;
    // Remove currency symbols and parse
    String cleanPrice = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  double? _parseDouble(String? str) {
    if (str == null || str.isEmpty) return null;
    return double.tryParse(str);
  }

  int? _parseInt(String? str) {
    if (str == null || str.isEmpty) return null;
    return int.tryParse(str);
  }

  bool _parseBoolean(String? str) {
    if (str == null || str.isEmpty) return true;
    return str.toLowerCase() == 'true' || str == '1' || str.toLowerCase() == 'yes';
  }

  List<String> _parseTags(String? tagsStr) {
    if (tagsStr == null || tagsStr.isEmpty) return [];
    return tagsStr.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
  }

  String _getCategoryImageUrl(String categoryName) {
    // Map category names to your local assets
    switch (categoryName.toLowerCase()) {
      case 'pizza':
        return 'assets/images/food/categories/pizza.png';
      case 'burger':
      case 'burgers':
        return 'assets/images/food/categories/burger.png';
      case 'sushi':
        return 'assets/images/food/categories/sushi.png';
      case 'indian':
        return 'assets/images/food/categories/indian.png';
      case 'chinese':
        return 'assets/images/food/categories/chinese.png';
      case 'italian':
        return 'assets/images/food/categories/italian.png';
      case 'dessert':
      case 'desserts':
        return 'assets/images/food/categories/dessert.png';
      case 'beverage':
      case 'beverages':
      case 'drinks':
        return 'assets/images/food/categories/beverage.png';
      default:
        return 'assets/images/placeholder.png';
    }
  }
}
