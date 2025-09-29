import 'package:flutter/foundation.dart';

import '../../../core/models/restaurant.dart';
import '../../../core/models/user.dart';
import '../../../core/services/database_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _favorites.isEmpty;
  bool get isNotEmpty => _favorites.isNotEmpty;
  int get count => _favorites.length;

  // Initialize favorites for user
  Future<void> initializeFavorites(String userId) async {
    await loadFavorites(userId);
  }

  // Load favorites from database
  Future<void> loadFavorites(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      _favorites = await _databaseService.getFavorites(userId);
      
    } catch (e) {
      _setError('Failed to load favorites: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Add restaurant to favorites
  Future<bool> addToFavorites(String userId, Restaurant restaurant) async {
    try {
      _clearError();

      // Check if already in favorites
      if (await isFavorite(userId, restaurant.id)) {
        _setError('${restaurant.name} is already in your favorites');
        return false;
      }

      await _databaseService.addToFavorites(userId, restaurant);
      
      // Add to local list
      _favorites.insert(0, {
        'id': '${userId}_${restaurant.id}',
        'user_id': userId,
        'restaurant_id': restaurant.id,
        'restaurant_name': restaurant.name,
        'restaurant_image': restaurant.imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Failed to add to favorites: ${e.toString()}');
      return false;
    }
  }

  // Remove restaurant from favorites
  Future<bool> removeFromFavorites(String userId, String restaurantId) async {
    try {
      _clearError();

      await _databaseService.removeFromFavorites(userId, restaurantId);
      
      // Remove from local list
      _favorites.removeWhere((favorite) => 
          favorite['restaurant_id'] == restaurantId);

      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Failed to remove from favorites: ${e.toString()}');
      return false;
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String userId, Restaurant restaurant) async {
    final isCurrentlyFavorite = await isFavorite(userId, restaurant.id);
    
    if (isCurrentlyFavorite) {
      return await removeFromFavorites(userId, restaurant.id);
    } else {
      return await addToFavorites(userId, restaurant);
    }
  }

  // Check if restaurant is in favorites
  Future<bool> isFavorite(String userId, String restaurantId) async {
    try {
      return await _databaseService.isFavorite(userId, restaurantId);
    } catch (e) {
      return false;
    }
  }

  // Get favorite restaurant IDs
  List<String> getFavoriteRestaurantIds() {
    return _favorites
        .map((favorite) => favorite['restaurant_id'] as String)
        .toList();
  }

  // Get favorite by restaurant ID
  Map<String, dynamic>? getFavoriteByRestaurantId(String restaurantId) {
    try {
      return _favorites.firstWhere(
        (favorite) => favorite['restaurant_id'] == restaurantId,
      );
    } catch (e) {
      return null;
    }
  }

  // Clear all favorites for user
  Future<bool> clearAllFavorites(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      // Remove all favorites from database
      for (final favorite in _favorites) {
        await _databaseService.removeFromFavorites(
          userId, 
          favorite['restaurant_id']
        );
      }

      _favorites.clear();
      notifyListeners();
      return true;
      
    } catch (e) {
      _setError('Failed to clear favorites: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get favorites count for a specific user
  int getFavoritesCount(String userId) {
    return _favorites
        .where((favorite) => favorite['user_id'] == userId)
        .length;
  }

  // Search favorites
  List<Map<String, dynamic>> searchFavorites(String query) {
    if (query.isEmpty) return _favorites;
    
    return _favorites.where((favorite) {
      final restaurantName = (favorite['restaurant_name'] as String).toLowerCase();
      return restaurantName.contains(query.toLowerCase());
    }).toList();
  }

  // Sort favorites
  void sortFavorites(String sortBy) {
    switch (sortBy) {
      case 'name':
        _favorites.sort((a, b) => 
            (a['restaurant_name'] as String).compareTo(b['restaurant_name'] as String));
        break;
      case 'date_added':
        _favorites.sort((a, b) => 
            DateTime.parse(b['created_at'] as String)
                .compareTo(DateTime.parse(a['created_at'] as String)));
        break;
      default:
        break;
    }
    notifyListeners();
  }

  // Get recently added favorites
  List<Map<String, dynamic>> getRecentFavorites({int limit = 5}) {
    final sortedFavorites = List<Map<String, dynamic>>.from(_favorites);
    sortedFavorites.sort((a, b) => 
        DateTime.parse(b['created_at'] as String)
            .compareTo(DateTime.parse(a['created_at'] as String)));
    
    return sortedFavorites.take(limit).toList();
  }

  // Check if favorites list is empty for user
  bool isEmptyForUser(String userId) {
    return !_favorites.any((favorite) => favorite['user_id'] == userId);
  }

  // Export favorites (for backup/sharing)
  Map<String, dynamic> exportFavorites(String userId) {
    final userFavorites = _favorites
        .where((favorite) => favorite['user_id'] == userId)
        .toList();
    
    return {
      'user_id': userId,
      'favorites': userFavorites,
      'exported_at': DateTime.now().toIso8601String(),
      'count': userFavorites.length,
    };
  }

  // Import favorites (from backup)
  Future<bool> importFavorites(String userId, List<Map<String, dynamic>> favoritesData) async {
    try {
      _setLoading(true);
      _clearError();

      for (final favoriteData in favoritesData) {
        // Create a restaurant object from the data
        final restaurant = Restaurant(
          id: favoriteData['restaurant_id'],
          name: favoriteData['restaurant_name'],
          description: '',
          imageUrl: favoriteData['restaurant_image'] ?? '',
          cuisines: [],
          rating: 0.0,
          reviewCount: 0,
          deliveryTime: '',
          deliveryFee: 0.0,
          minimumOrder: 0.0,
          isOpen: true,
          address: Address(
            id: '',
            title: '',
            addressLine1: '',
            city: '',
            state: '',
            pincode: '',
            country: '',
            latitude: 0.0,
            longitude: 0.0,
          ),
        );

        await addToFavorites(userId, restaurant);
      }

      return true;
      
    } catch (e) {
      _setError('Failed to import favorites: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Clean up resources
  @override
  void dispose() {
    _favorites.clear();
    super.dispose();
  }
}