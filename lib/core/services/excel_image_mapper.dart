import 'package:flutter/foundation.dart';
import 'excel_service.dart';
import '../app_config.dart';

class ExcelImageMapper {
  static final ExcelImageMapper _instance = ExcelImageMapper._internal();
  factory ExcelImageMapper() => _instance;
  ExcelImageMapper._internal();

  final ExcelService _excelService = ExcelService();
  final String _catalogFileName = 'food_images_catalog_urls.xlsx';
  
  Map<String, String> _imageUrlCache = {};
  Map<String, List<Map<String, dynamic>>> _categoryCache = {};
  bool _isInitialized = false;

  /// Initialize the mapper by loading and caching Excel data
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      List<Map<String, dynamic>> data = await _excelService.readExcelData(_catalogFileName);
      
      // Cache image URLs by food name/category
      for (var row in data) {
        String name = row['Name']?.toString().toLowerCase() ?? '';
        String category = row['Category']?.toString().toLowerCase() ?? '';
        String imageUrl = row['Image_URL']?.toString() ?? '';
        
        if (name.isNotEmpty && imageUrl.isNotEmpty) {
          _imageUrlCache[name] = imageUrl;
        }
        
        // Group by category
        if (category.isNotEmpty) {
          if (!_categoryCache.containsKey(category)) {
            _categoryCache[category] = [];
          }
          _categoryCache[category]!.add(row);
        }
      }
      
      _isInitialized = true;
      debugPrint('Excel Image Mapper initialized with ${_imageUrlCache.length} images');
    } catch (e) {
      debugPrint('Error initializing Excel Image Mapper: $e');
    }
  }

  /// Get image URL for a specific food item name
  Future<String?> getImageUrlByName(String foodName) async {
    await initialize();
    return _imageUrlCache[foodName.toLowerCase()];
  }

  /// Get all food items for a specific category
  Future<List<Map<String, dynamic>>> getFoodItemsByCategory(String category) async {
    await initialize();
    return _categoryCache[category.toLowerCase()] ?? [];
  }

  /// Get all available categories from Excel
  Future<List<String>> getAvailableCategories() async {
    await initialize();
    return _categoryCache.keys.toList();
  }

  /// Get image URL for category (first image from that category)
  Future<String> getCategoryImageUrl(String category) async {
    await initialize();
    
    List<Map<String, dynamic>> items = _categoryCache[category.toLowerCase()] ?? [];
    if (items.isNotEmpty) {
      String imageUrl = items.first['Image_URL']?.toString() ?? '';
      if (imageUrl.isNotEmpty) {
        return imageUrl;
      }
    }
    
    // Fallback to local assets
    return AppAssets.getCategoryImage(category);
  }

  /// Search for food items by name
  Future<List<Map<String, dynamic>>> searchFoodItems(String query) async {
    await initialize();
    
    List<Map<String, dynamic>> allData = await _excelService.readExcelData(_catalogFileName);
    
    return allData.where((row) {
      String name = row['Name']?.toString().toLowerCase() ?? '';
      String description = row['Description']?.toString().toLowerCase() ?? '';
      String category = row['Category']?.toString().toLowerCase() ?? '';
      
      String searchQuery = query.toLowerCase();
      
      return name.contains(searchQuery) || 
             description.contains(searchQuery) || 
             category.contains(searchQuery);
    }).toList();
  }

  /// Get random food items for featured/recommended section
  Future<List<Map<String, dynamic>>> getRandomFoodItems(int count) async {
    await initialize();
    
    List<Map<String, dynamic>> allData = await _excelService.readExcelData(_catalogFileName);
    allData.shuffle();
    return allData.take(count).toList();
  }

  /// Get food items with images only
  Future<List<Map<String, dynamic>>> getFoodItemsWithImages() async {
    await initialize();
    
    List<Map<String, dynamic>> allData = await _excelService.readExcelData(_catalogFileName);
    
    return allData.where((row) {
      String imageUrl = row['Image_URL']?.toString() ?? '';
      return imageUrl.isNotEmpty && (imageUrl.startsWith('http') || imageUrl.startsWith('www'));
    }).toList();
  }

  /// Get restaurant data from Excel
  Future<List<Map<String, dynamic>>> getRestaurantData() async {
    await initialize();
    
    List<Map<String, dynamic>> allData = await _excelService.readExcelData(_catalogFileName);
    Map<String, Map<String, dynamic>> restaurantMap = {};
    
    for (var row in allData) {
      String restaurantName = row['Restaurant_Name']?.toString() ?? 'Unknown Restaurant';
      String restaurantId = restaurantName.toLowerCase().replaceAll(' ', '_');
      
      if (!restaurantMap.containsKey(restaurantId)) {
        restaurantMap[restaurantId] = {
          'id': restaurantId,
          'name': restaurantName,
          'image_url': row['Restaurant_Image']?.toString() ?? '',
          'cuisine_types': <String>{},
          'menu_items': <Map<String, dynamic>>[],
        };
      }
      
      // Add cuisine type
      String category = row['Category']?.toString() ?? '';
      if (category.isNotEmpty) {
        (restaurantMap[restaurantId]!['cuisine_types'] as Set<String>).add(category);
      }
      
      // Add menu item
      (restaurantMap[restaurantId]!['menu_items'] as List<Map<String, dynamic>>).add(row);
    }
    
    return restaurantMap.values.map((restaurant) => {
      ...restaurant,
      'cuisine_types': (restaurant['cuisine_types'] as Set<String>).toList(),
    }).toList();
  }

  /// Create updated AppAssets constants based on Excel data
  Future<Map<String, String>> generateAppAssetsFromExcel() async {
    await initialize();
    
    Map<String, String> assets = {};
    
    // Generate category assets
    for (String category in _categoryCache.keys) {
      String imageUrl = await getCategoryImageUrl(category);
      String constantName = 'category${_toCamelCase(category)}';
      assets[constantName] = imageUrl;
    }
    
    // Generate food item assets (first 20 items)
    List<Map<String, dynamic>> foodItems = await getFoodItemsWithImages();
    for (int i = 0; i < foodItems.length && i < 20; i++) {
      var item = foodItems[i];
      String name = item['Name']?.toString() ?? '';
      String imageUrl = item['Image_URL']?.toString() ?? '';
      
      if (name.isNotEmpty && imageUrl.isNotEmpty) {
        String constantName = 'food${_toCamelCase(name)}';
        assets[constantName] = imageUrl;
      }
    }
    
    return assets;
  }

  /// Helper method to convert string to camelCase
  String _toCamelCase(String text) {
    return text
        .split(' ')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join('');
  }

  /// Get Excel data structure info
  Future<Map<String, dynamic>> getDataStructureInfo() async {
    try {
      List<String> headers = await _excelService.getColumnHeaders(_catalogFileName);
      List<Map<String, dynamic>> sampleData = await _excelService.readExcelData(_catalogFileName);
      
      return {
        'headers': headers,
        'total_rows': sampleData.length,
        'sample_data': sampleData.take(3).toList(),
        'categories': await getAvailableCategories(),
        'images_count': (await getFoodItemsWithImages()).length,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Clear cache and reinitialize
  Future<void> refresh() async {
    _imageUrlCache.clear();
    _categoryCache.clear();
    _isInitialized = false;
    await initialize();
  }
}
