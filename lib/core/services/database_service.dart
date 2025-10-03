import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/restaurant.dart';
import '../models/user.dart';
import '../models/order.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  final supabase = Supabase.instance.client;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'food_delivery.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Favorites table
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        restaurant_id TEXT NOT NULL,
        restaurant_name TEXT NOT NULL,
        restaurant_image TEXT NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(user_id, restaurant_id)
      )
    ''');

    // Cache table for restaurants
    await db.execute('''
      CREATE TABLE restaurant_cache (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at TEXT NOT NULL,
        expires_at TEXT NOT NULL
      )
    ''');

    // User addresses cache
    await db.execute('''
      CREATE TABLE user_addresses (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        address_line_1 TEXT NOT NULL,
        address_line_2 TEXT,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        pincode TEXT NOT NULL,
        country TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Search history
    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        query TEXT NOT NULL,
        search_type TEXT NOT NULL,
        searched_at TEXT NOT NULL
      )
    ''');

    // Order cache for offline viewing
    await db.execute('''
      CREATE TABLE order_cache (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        data TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Example upgrade logic
      // await db.execute('ALTER TABLE favorites ADD COLUMN new_column TEXT');
    }
  }

  // Favorites methods
  Future<void> addToFavorites(String userId, Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'id': '${userId}_${restaurant.id}',
        'user_id': userId,
        'restaurant_id': restaurant.id,
        'restaurant_name': restaurant.name,
        'restaurant_image': restaurant.imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFromFavorites(String userId, String restaurantId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'user_id = ? AND restaurant_id = ?',
      whereArgs: [userId, restaurantId],
    );
  }

  Future<bool> isFavorite(String userId, String restaurantId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'user_id = ? AND restaurant_id = ?',
      whereArgs: [userId, restaurantId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final db = await database;
    return await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // Supabase Integration Methods
  
  /// Fetches all restaurants from Supabase backend
  /// This function runs on the user's phone and makes a secure API call
  /// to your Supabase backend (e.g., https://<project-id>.supabase.co/rest/v1/restaurants?select=*)
  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      // The 'from('restaurants').select()' is a Dart command
      // The supabase_flutter package translates this into a secure API call
      final data = await supabase.from('restaurants').select();

      // Map Supabase row shape (with integer id, minimal columns)
      // into the rich Restaurant model shape our app expects.
      final List<Map<String, dynamic>> mapped = data.map<Map<String, dynamic>>((row) {
        final dynamic addressJson = row['address'];
        return {
          'id': (row['id'] ?? '').toString(),
          'name': row['name'] ?? '',
          'description': row['description'] ?? '',
          // Your schema uses logo_url
          'image_url': (row['logo_url'] as String?)?.trim().isNotEmpty == true
              ? row['logo_url'] as String
              : '',
          // Surface cuisine type for UI chips
          'cuisines': (row['cuisine_type'] is String && (row['cuisine_type'] as String).isNotEmpty)
              ? <String>[row['cuisine_type'] as String]
              : <String>[],
          'cuisine_type': row['cuisine_type'] ?? '',
          'rating': (row['rating'] is num) ? (row['rating'] as num).toDouble() : 0.0,
          'review_count': 0,
          // Provide sane defaults the UI expects
          'delivery_time': '30-40',
          'delivery_fee': 0.0,
          'minimum_order': 0.0,
          'is_open': row['is_active'] == null ? true : (row['is_active'] as bool),
          'is_vegetarian': false,
          'is_pure_veg': false,
          // Map address jsonb from Supabase into the app's address shape
          'address': addressJson is Map<String, dynamic>
              ? {
                  'id': 'addr_${row['id'] ?? '0'}',
                  'user_id': '',
                  'name': addressJson['name'] ?? 'Address',
                  'address_line1': addressJson['line1'] ?? addressJson['address_line1'] ?? '',
                  'address_line2': addressJson['line2'] ?? addressJson['address_line2'] ?? '',
                  'city': addressJson['city'] ?? '',
                  'state': addressJson['state'] ?? '',
                  'pincode': addressJson['postal_code'] ?? addressJson['pincode'] ?? '',
                  'country': addressJson['country'] ?? '',
                  'latitude': addressJson['latitude'],
                  'longitude': addressJson['longitude'],
                  'is_default': false,
                }
              : {
                  'id': 'addr_${row['id'] ?? '0'}',
                  'user_id': '',
                  'name': 'Address',
                  'address_line1': '',
                  'address_line2': '',
                  'city': '',
                  'state': '',
                  'pincode': '',
                  'country': '',
                  'latitude': null,
                  'longitude': null,
                  'is_default': false,
                },
          'offers': <String>[],
          'menu': <Map<String, dynamic>>[],
          'distance': 0.0,
        };
      }).toList();

      return mapped;
    } catch (e) {
      // Handle any errors, e.g., show a message to the user
      print('Error fetching restaurants: $e');
      return [];
    }
  }

  /// Fetches restaurants with location-based filtering
  Future<List<Map<String, dynamic>>> getRestaurantsByLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final data = await supabase
          .from('restaurants')
          .select()
          .filter('latitude', 'gte', latitude - (radiusKm / 111.0))
          .filter('latitude', 'lte', latitude + (radiusKm / 111.0))
          .filter('longitude', 'gte', longitude - (radiusKm / 111.0))
          .filter('longitude', 'lte', longitude + (radiusKm / 111.0));
      return data;
    } catch (e) {
      print('Error fetching restaurants by location: $e');
      return [];
    }
  }

  /// Fetches restaurant menu items
  Future<List<Map<String, dynamic>>> getRestaurantMenu(String restaurantId) async {
    try {
      final data = await supabase
          .from('menu_items')
          .select()
          .eq('restaurant_id', restaurantId);
      return data;
    } catch (e) {
      print('Error fetching menu: $e');
      return [];
    }
  }

  /// Search restaurants by name or cuisine
  Future<List<Map<String, dynamic>>> searchRestaurants(String query) async {
    try {
      final data = await supabase
          .from('restaurants')
          .select()
          .ilike('name', '%$query%');
      // Map to UI-friendly result rows
      return data.map<Map<String, dynamic>>((row) => {
        'type': 'restaurant',
        'id': (row['id'] ?? '').toString(),
        'name': row['name'] ?? '',
        'subtitle': row['location'] ?? '',
        'image': (row['image'] as String?)?.trim().isNotEmpty == true
            ? row['image'] as String
            : '',
        'rating': (row['rating'] is num) ? (row['rating'] as num).toDouble() : 0.0,
      }).toList();
    } catch (e) {
      print('Error searching restaurants: $e');
      return [];
    }
  }

  /// Search foods (menu items) by name/description
  Future<List<Map<String, dynamic>>> searchFoods(String query) async {
    try {
      final data = await supabase
          .from('menu_items')
          .select('id, name, description, price, image, restaurant_id, restaurants(name)')
          .ilike('name', '%$query%');
      return data.map<Map<String, dynamic>>((row) => {
        'type': 'food',
        'id': (row['id'] ?? '').toString(),
        'name': row['name'] ?? '',
        'subtitle': (row['restaurants'] != null && row['restaurants']['name'] != null)
            ? row['restaurants']['name'] as String
            : (row['description'] ?? ''),
        'image': (row['image'] as String?)?.trim().isNotEmpty == true
            ? row['image'] as String
            : '',
        'price': (row['price'] is num) ? (row['price'] as num).toDouble() : 0.0,
      }).toList();
    } catch (e) {
      print('Error searching foods: $e');
      return [];
    }
  }

  /// Hybrid method: Try Supabase first, fallback to local cache
  Future<List<Restaurant>> getRestaurantsHybrid() async {
    try {
      // Try to fetch from Supabase first
      final supabaseData = await getRestaurants();
      
      if (supabaseData.isNotEmpty) {
        // Convert to Restaurant objects and cache locally
        final restaurants = supabaseData.map((json) => Restaurant.fromJson(json)).toList();
        
        // Cache the restaurants locally for offline access
        for (final restaurant in restaurants) {
          await cacheRestaurant(restaurant);
        }
        
        return restaurants;
      }
    } catch (e) {
      print('Restaurants table fetch failed: $e');
    }
    
    // Fallback to local cache if everything fails
    // This would require implementing a method to get all cached restaurants
    // For now, return empty list
    return [];
  }

  // Restaurant cache methods
  Future<void> cacheRestaurant(Restaurant restaurant, {Duration? ttl}) async {
    final db = await database;
    final expiresAt = DateTime.now().add(ttl ?? const Duration(hours: 1));
    
    await db.insert(
      'restaurant_cache',
      {
        'id': restaurant.id,
        'data': jsonEncode(restaurant.toJson()),
        'cached_at': DateTime.now().toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Restaurant?> getCachedRestaurant(String restaurantId) async {
    final db = await database;
    final result = await db.query(
      'restaurant_cache',
      where: 'id = ? AND expires_at > ?',
      whereArgs: [restaurantId, DateTime.now().toIso8601String()],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final data = jsonDecode(result.first['data'] as String);
      return Restaurant.fromJson(data);
    }
    return null;
  }

  Future<void> clearExpiredCache() async {
    final db = await database;
    await db.delete(
      'restaurant_cache',
      where: 'expires_at <= ?',
      whereArgs: [DateTime.now().toIso8601String()],
    );
  }

  // User addresses methods
  Future<void> saveUserAddress(Address address, String userId) async {
    final db = await database;
    
    // If this is set as default, unset all other defaults first
    if (address.isDefault) {
      await db.update(
        'user_addresses',
        {'is_default': 0},
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    }

    await db.insert(
      'user_addresses',
      {
        'id': address.id,
        'user_id': userId,
        'title': address.title,
        'address_line_1': address.addressLine1,
        'address_line_2': address.addressLine2,
        'city': address.city,
        'state': address.state,
        'pincode': address.pincode,
        'country': address.country,
        'latitude': address.latitude,
        'longitude': address.longitude,
        'is_default': address.isDefault ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Address>> getUserAddresses(String userId) async {
    final db = await database;
    final result = await db.query(
      'user_addresses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'is_default DESC, title ASC',
    );

    return result.map((row) => Address(
      id: row['id'] as String,
      title: row['title'] as String,
      addressLine1: row['address_line_1'] as String,
      addressLine2: row['address_line_2'] as String? ?? '',
      city: row['city'] as String,
      state: row['state'] as String,
      pincode: row['pincode'] as String,
      country: row['country'] as String,
      latitude: row['latitude'] as double,
      longitude: row['longitude'] as double,
      isDefault: (row['is_default'] as int) == 1,
    )).toList();
  }

  Future<void> deleteUserAddress(String addressId) async {
    final db = await database;
    await db.delete(
      'user_addresses',
      where: 'id = ?',
      whereArgs: [addressId],
    );
  }

  // Search history methods
  Future<void> addSearchQuery(String userId, String query, String searchType) async {
    final db = await database;
    
    // Remove existing query if it exists
    await db.delete(
      'search_history',
      where: 'user_id = ? AND query = ? AND search_type = ?',
      whereArgs: [userId, query, searchType],
    );

    // Add new query
    await db.insert(
      'search_history',
      {
        'user_id': userId,
        'query': query,
        'search_type': searchType,
        'searched_at': DateTime.now().toIso8601String(),
      },
    );

    // Keep only recent 50 searches
    await db.execute('''
      DELETE FROM search_history 
      WHERE user_id = ? AND id NOT IN (
        SELECT id FROM search_history 
        WHERE user_id = ? 
        ORDER BY searched_at DESC 
        LIMIT 50
      )
    ''', [userId, userId]);
  }

  Future<List<String>> getSearchHistory(String userId, String searchType) async {
    final db = await database;
    final result = await db.query(
      'search_history',
      columns: ['query'],
      where: 'user_id = ? AND search_type = ?',
      whereArgs: [userId, searchType],
      orderBy: 'searched_at DESC',
      limit: 10,
    );

    return result.map((row) => row['query'] as String).toList();
  }

  Future<void> clearSearchHistory(String userId) async {
    final db = await database;
    await db.delete(
      'search_history',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Order cache methods
  Future<void> cacheOrder(Order order) async {
    final db = await database;
    await db.insert(
      'order_cache',
      {
        'id': order.id,
        'user_id': order.userId,
        'data': jsonEncode(order.toJson()),
        'cached_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Order>> getCachedOrders(String userId) async {
    final db = await database;
    final result = await db.query(
      'order_cache',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'cached_at DESC',
    );

    return result.map((row) {
      final data = jsonDecode(row['data'] as String);
      return Order.fromJson(data);
    }).toList();
  }

  Future<Order?> getCachedOrder(String orderId) async {
    final db = await database;
    final result = await db.query(
      'order_cache',
      where: 'id = ?',
      whereArgs: [orderId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final data = jsonDecode(result.first['data'] as String);
      return Order.fromJson(data);
    }
    return null;
  }

  // Utility methods
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete('restaurant_cache');
    await db.delete('order_cache');
  }

  Future<void> clearUserData(String userId) async {
    final db = await database;
    await db.delete('favorites', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('user_addresses', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('search_history', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('order_cache', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}