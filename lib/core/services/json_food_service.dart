import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class JsonFoodService {
  static final JsonFoodService _instance = JsonFoodService._internal();
  factory JsonFoodService() => _instance;
  JsonFoodService._internal();

  List<Map<String, dynamic>> _foodItems = [];
  List<String> _categories = [];
  bool _isInitialized = false;

  /// Initialize the service by loading JSON data
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      debugPrint('Initializing JSON Food Service...');
      
      // Load JSON data from assets
      final String jsonString = await rootBundle.loadString('assets/data/food_data.json');
      final dynamic jsonData = json.decode(jsonString);
      
      // Extract food items array
      if (jsonData is List) {
        _foodItems = List<Map<String, dynamic>>.from(jsonData);
        debugPrint('Loaded ${_foodItems.length} food items from JSON array');
      } else if (jsonData is Map && jsonData.containsKey('foods') && jsonData['foods'] is List) {
        _foodItems = List<Map<String, dynamic>>.from(jsonData['foods']);
        debugPrint('Loaded ${_foodItems.length} food items from JSON object');
      } else {
        debugPrint('Invalid JSON format, using sample data');
        _createSampleData();
      }
      
      // Extract unique categories
      Set<String> categorySet = {};
      for (var item in _foodItems) {
        String category = _getValueFromRow(item, ['food_type', 'category', 'type', 'cuisine']) ?? '';
        if (category.isNotEmpty) {
          categorySet.add(category);
        }
      }
      _categories = categorySet.toList()..sort();
      
      _isInitialized = true;
      debugPrint('JSON Food Service initialized with ${_foodItems.length} items and ${_categories.length} categories');
      
    } catch (e) {
      debugPrint('Error loading JSON: $e');
      _createSampleData();
      _isInitialized = true;
    }
  }

  /// Get all food items
  List<Map<String, dynamic>> getAllFoodItems() {
    return List<Map<String, dynamic>>.from(_foodItems);
  }

  /// Get food items by category
  List<Map<String, dynamic>> getFoodItemsByCategory(String category) {
    return _foodItems.where((item) {
      String itemCategory = _getValueFromRow(item, ['food_type', 'category', 'type', 'cuisine']) ?? '';
      return itemCategory.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  /// Get all categories
  List<String> getCategories() {
    return List<String>.from(_categories);
  }

  /// Search food items
  List<Map<String, dynamic>> searchFoodItems(String query) {
    if (query.isEmpty) return getAllFoodItems();
    
    final lowercaseQuery = query.toLowerCase();
    return _foodItems.where((item) {
      final name = _getValueFromRow(item, ['dish_name', 'name', 'title']) ?? '';
      final category = _getValueFromRow(item, ['food_type', 'category', 'type']) ?? '';
      final ingredients = _getValueFromRow(item, ['ingredients', 'description']) ?? '';
      
      return name.toLowerCase().contains(lowercaseQuery) ||
             category.toLowerCase().contains(lowercaseQuery) ||
             ingredients.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Create sample data if JSON loading fails
  void _createSampleData() {
    _foodItems = [
      {
        'dish_name': 'Margherita Pizza',
        'food_type': 'Italian',
        'image_url': 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
        'ingredients': 'Tomato sauce, Mozzarella cheese, Fresh basil',
        'price': '12.99',
        'nutritional_profile': {'calories_kcal': 280, 'protein_g': 12, 'fat_g': 10, 'carbohydrate_g': 36},
      },
      {
        'dish_name': 'Cheeseburger',
        'food_type': 'American',
        'image_url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        'ingredients': 'Beef patty, Cheese, Lettuce, Tomato, Onion',
        'price': '8.99',
        'nutritional_profile': {'calories_kcal': 540, 'protein_g': 25, 'fat_g': 31, 'carbohydrate_g': 40},
      },
      {
        'dish_name': 'Chicken Biryani',
        'food_type': 'Indian',
        'image_url': 'https://images.unsplash.com/photo-1563379091339-03246963d4d6?w=400',
        'ingredients': 'Basmati rice, Chicken, Spices, Yogurt',
        'price': '15.99',
        'nutritional_profile': {'calories_kcal': 450, 'protein_g': 30, 'fat_g': 15, 'carbohydrate_g': 50},
      },
      {
        'dish_name': 'Caesar Salad',
        'food_type': 'Healthy',
        'image_url': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
        'ingredients': 'Romaine lettuce, Parmesan cheese, Croutons, Caesar dressing',
        'price': '9.99',
        'nutritional_profile': {'calories_kcal': 200, 'protein_g': 8, 'fat_g': 15, 'carbohydrate_g': 12},
      },
      {
        'dish_name': 'Pad Thai',
        'food_type': 'Thai',
        'image_url': 'https://images.unsplash.com/photo-1559314809-0f31657def5e?w=400',
        'ingredients': 'Rice noodles, Shrimp, Bean sprouts, Peanuts',
        'price': '13.99',
        'nutritional_profile': {'calories_kcal': 400, 'protein_g': 20, 'fat_g': 12, 'carbohydrate_g': 55},
      },
      {
        'dish_name': 'Sushi Roll',
        'food_type': 'Japanese',
        'image_url': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        'ingredients': 'Sushi rice, Salmon, Avocado, Nori',
        'price': '16.99',
        'nutritional_profile': {'calories_kcal': 300, 'protein_g': 18, 'fat_g': 8, 'carbohydrate_g': 35},
      },
    ];

    _categories = ['Italian', 'American', 'Indian', 'Healthy', 'Thai', 'Japanese'];
    debugPrint('Created sample food data with ${_foodItems.length} items');
  }

  /// Helper method to get value from row with multiple possible keys
  String? _getValueFromRow(Map<String, dynamic> row, List<String> possibleKeys) {
    for (String key in possibleKeys) {
      if (row.containsKey(key) && row[key] != null && row[key].toString().isNotEmpty) {
        return row[key].toString();
      }
      
      // Try case-insensitive match
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
}
