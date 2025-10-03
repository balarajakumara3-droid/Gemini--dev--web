import 'package:flutter/foundation.dart';

import '../../../core/models/restaurant.dart';
import '../../../core/models/offer.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/database_service.dart';

class RestaurantProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final DatabaseService _databaseService = DatabaseService();

  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  List<String> _categories = [];
  List<Offer> _offers = [];
  Restaurant? _selectedRestaurant;
  List<FoodCategory> _menu = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCategory = 'All';
  String _sortBy = 'popularity';
  
  // Location data
  double? _userLatitude;
  double? _userLongitude;

  // Getters
  List<Restaurant> get restaurants => _filteredRestaurants;
  List<Restaurant> get allRestaurants => _restaurants;
  List<String> get categories => _categories;
  List<Offer> get offers => _offers;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  List<FoodCategory> get menu => _menu;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentCategory => _currentCategory;
  String get sortBy => _sortBy;

  // Initialize with user location
  void setUserLocation(double latitude, double longitude) {
    _userLatitude = latitude;
    _userLongitude = longitude;
    notifyListeners();
  }

  // Fetch restaurants with Supabase integration
  Future<void> fetchRestaurantsWithSupabase({
    bool refresh = false,
    String? category,
    String? sortBy,
  }) async {
    try {
      if (!refresh && _restaurants.isNotEmpty) {
        _applyFilters();
        return;
      }

      _setLoading(true);
      _clearError();

      // Try Supabase first for real-time data
      final supabaseRestaurants = await _databaseService.getRestaurantsHybrid();
      
      if (supabaseRestaurants.isNotEmpty) {
        _restaurants = supabaseRestaurants;
        _extractCategories();
        _applyFilters();
        return;
      }

      // Fallback to Supabase service
      final restaurantData = await _supabaseService.getRestaurants();
      _restaurants = restaurantData.map((data) => Restaurant.fromJson(data)).toList();
      _extractCategories();
      _applyFilters();

      // Cache restaurants locally
      for (final restaurant in _restaurants) {
        await _databaseService.cacheRestaurant(restaurant);
      }

    } catch (e) {
      _setError(_getErrorMessage(e));
      
      // Try to load from cache if everything fails
      if (_restaurants.isEmpty) {
        await _loadFromCache();
      }
    } finally {
      _setLoading(false);
    }
  }

  // Fetch restaurants by location using Supabase
  Future<void> fetchRestaurantsByLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final restaurantData = await _databaseService.getRestaurantsByLocation(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );

      // Convert Map data to Restaurant objects
      _restaurants = restaurantData.map((data) => Restaurant.fromJson(data)).toList();
      _extractCategories();
      _applyFilters();
      
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Search restaurants using Supabase
  Future<void> searchRestaurantsSupabase(String query) async {
    try {
      _setLoading(true);
      _clearError();

      final restaurantData = await _databaseService.searchRestaurants(query);
      // Convert Map data to Restaurant objects
      _filteredRestaurants = restaurantData.map((data) => Restaurant.fromJson(data)).toList();
      notifyListeners();
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Fetch restaurants
  Future<void> fetchRestaurants({
    bool refresh = false,
    String? category,
    String? sortBy,
  }) async {
    try {
      // Route all loads through Supabase-first flow
      await fetchRestaurantsWithSupabase(
        refresh: refresh,
        category: category,
        sortBy: sortBy,
      );
      
      notifyListeners();
    } finally {
      // fetchRestaurantsWithSupabase handles loading/error
    }
  }

  // Fetch restaurant details
  Future<void> fetchRestaurantDetails(String restaurantId) async {
    try {
      _setLoading(true);
      _clearError();

      // Try to get from cache first
      _selectedRestaurant = await _databaseService.getCachedRestaurant(restaurantId);
      
      if (_selectedRestaurant != null) {
        notifyListeners();
      }

      // Fetch fresh data from Supabase
      final restaurantData = await _supabaseService.getRestaurantById(restaurantId);
      if (restaurantData != null) {
        _selectedRestaurant = Restaurant.fromJson(restaurantData);
      }
      
      // Cache the updated data
      await _databaseService.cacheRestaurant(_selectedRestaurant!);
      
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Fetch restaurant menu
  Future<void> fetchRestaurantMenu(String restaurantId) async {
    try {
      _setLoading(true);
      _clearError();
      // Load menu from Supabase `menu_items` and map to our model
      final rows = await _databaseService.getRestaurantMenu(restaurantId);
      final items = rows.map((row) {
        final String imageUrl = (row['image_url'] as String?)?.trim().isNotEmpty == true
            ? row['image_url'] as String
            : '';
        return Food(
          id: (row['id'] ?? '').toString(),
          name: row['name'] ?? '',
          description: row['description'] ?? '',
          imageUrl: imageUrl,
          price: (row['price'] is num) ? (row['price'] as num).toDouble() : 0.0,
          category: 'Menu',
        );
      }).toList();

      // No fallback to removed legacy tables

      _menu = [
        FoodCategory(
          id: 'menu_${restaurantId}',
          name: 'Menu',
          description: '',
          items: items,
        ),
      ];
      
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Search restaurants
  Future<void> searchRestaurants({
    required String query,
    String? category,
    String? cuisine,
    double? minRating,
    double? maxDeliveryTime,
    bool? isVegetarian,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final restaurantData = await _supabaseService.searchRestaurants(query);
      _filteredRestaurants = restaurantData.map((data) => Restaurant.fromJson(data)).toList();
      
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Filter by category
  void filterByCategory(String category) {
    _currentCategory = category;
    _applyFilters();
  }

  // Sort restaurants
  void sortRestaurants(String sortBy) {
    _sortBy = sortBy;
    _applySorting();
  }

  // Apply filters and sorting
  void _applyFilters() {
    List<Restaurant> filtered = List.from(_restaurants);

    // Filter by category
    if (_currentCategory != 'All') {
      filtered = filtered.where((restaurant) =>
          restaurant.cuisines.any((cuisine) =>
              cuisine.toLowerCase().contains(_currentCategory.toLowerCase()))).toList();
    }

    _filteredRestaurants = filtered;
    _applySorting();
  }

  // Apply sorting
  void _applySorting() {
    switch (_sortBy) {
      case 'rating':
        _filteredRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'delivery_time':
        _filteredRestaurants.sort((a, b) {
          final aTime = _parseDeliveryTime(a.deliveryTime);
          final bTime = _parseDeliveryTime(b.deliveryTime);
          return aTime.compareTo(bTime);
        });
        break;
      case 'delivery_fee':
        _filteredRestaurants.sort((a, b) => a.deliveryFee.compareTo(b.deliveryFee));
        break;
      case 'distance':
        _filteredRestaurants.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'popularity':
      default:
        _filteredRestaurants.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }
    
    notifyListeners();
  }

  // Extract unique categories from restaurants
  void _extractCategories() {
    final categorySet = <String>{'All'};
    
    for (final restaurant in _restaurants) {
      categorySet.addAll(restaurant.cuisines);
    }
    
    _categories = categorySet.toList();
  }

  // Load restaurants from cache
  Future<void> _loadFromCache() async {
    try {
      // This is a simplified version - in real implementation,
      // you might want to cache the restaurant list as well
      _filteredRestaurants = [];
      notifyListeners();
    } catch (e) {
      // Ignore cache errors
    }
  }

  // Parse delivery time string to minutes for sorting
  int _parseDeliveryTime(String timeString) {
    try {
      // Extract numbers from strings like "30-40 mins" or "45 mins"
      final regex = RegExp(r'(\d+)');
      final match = regex.firstMatch(timeString);
      return match != null ? int.parse(match.group(1)!) : 999;
    } catch (e) {
      return 999;
    }
  }

  // Get restaurants by category
  List<Restaurant> getRestaurantsByCategory(String category) {
    if (category == 'All') return _restaurants;
    
    return _restaurants.where((restaurant) =>
        restaurant.cuisines.any((cuisine) =>
            cuisine.toLowerCase().contains(category.toLowerCase()))).toList();
  }

  // Get featured restaurants (high rated, popular)
  List<Restaurant> getFeaturedRestaurants() {
    return _restaurants
        .where((restaurant) => restaurant.rating >= 4.0)
        .take(10)
        .toList();
  }

  // Get restaurants with offers
  List<Restaurant> getRestaurantsWithOffers() {
    return _restaurants
        .where((restaurant) => restaurant.offers.isNotEmpty)
        .toList();
  }

  // Get nearby restaurants (within certain distance)
  List<Restaurant> getNearbyRestaurants({double maxDistance = 5.0}) {
    return _restaurants
        .where((restaurant) => restaurant.distance <= maxDistance)
        .toList();
  }

  // Get vegetarian restaurants
  List<Restaurant> getVegetarianRestaurants() {
    return _restaurants
        .where((restaurant) => restaurant.isPureVeg || restaurant.isVegetarian)
        .toList();
  }

  // Clear selected restaurant
  void clearSelectedRestaurant() {
    _selectedRestaurant = null;
    _menu = [];
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await fetchRestaurants(refresh: true);
  }

  // Fetch initial data for the home screen
  Future<void> fetchInitialData() async {
    try {
      _setLoading(true);
      _clearError();
      
      // Attempt to fetch from Supabase with fallback
      await fetchRestaurantsWithSupabase(refresh: true);
      
      // Also fetch offers
      await fetchOffers();
      
    } catch (e) {
      _setError('Failed to load initial data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch offers from Supabase
  Future<void> fetchOffers() async {
    try {
      final offersData = await _databaseService.supabase
          .from('offers')
          .select()
          .eq('is_active', true)
          .gte('end_date', DateTime.now().toIso8601String());
      
      _offers = offersData.map((json) => Offer.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching offers: $e');
      // Don't throw error for offers as they're not critical
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

  String _getErrorMessage(dynamic error) {
    return error.toString();
  }
}