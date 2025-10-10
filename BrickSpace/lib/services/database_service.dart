import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property.dart';
import '../models/user.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User methods
  Future<void> saveUser(User user) async {
    await _prefs.setString('user', jsonEncode(user.toJson()));
  }

  User? getUser() {
    final userString = _prefs.getString('user');
    if (userString != null) {
      final userJson = jsonDecode(userString);
      return User.fromJson(userJson);
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove('user');
  }

  // Favorites methods
  Future<void> addFavorite(String propertyId) async {
    final favorites = getFavorites();
    if (!favorites.contains(propertyId)) {
      favorites.add(propertyId);
      await _prefs.setStringList('favorites', favorites);
    }
  }

  Future<void> removeFavorite(String propertyId) async {
    final favorites = getFavorites();
    favorites.remove(propertyId);
    await _prefs.setStringList('favorites', favorites);
  }

  List<String> getFavorites() {
    return _prefs.getStringList('favorites') ?? [];
  }

  bool isFavorite(String propertyId) {
    return getFavorites().contains(propertyId);
  }

  // Recently viewed properties
  Future<void> addRecentlyViewed(String propertyId) async {
    final viewed = getRecentlyViewed();
    viewed.remove(propertyId); // Remove if already exists
    viewed.insert(0, propertyId); // Add to beginning
    // Keep only last 20 items
    if (viewed.length > 20) {
      viewed.removeRange(20, viewed.length);
    }
    await _prefs.setStringList('recently_viewed', viewed);
  }

  List<String> getRecentlyViewed() {
    return _prefs.getStringList('recently_viewed') ?? [];
  }

  // Search history
  Future<void> addSearchQuery(String query) async {
    final history = getSearchHistory();
    history.remove(query); // Remove if already exists
    history.insert(0, query); // Add to beginning
    // Keep only last 20 items
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    await _prefs.setStringList('search_history', history);
  }

  List<String> getSearchHistory() {
    return _prefs.getStringList('search_history') ?? [];
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove('search_history');
  }

  // Property comparisons
  Future<void> savePropertyComparison(List<String> propertyIds) async {
    final comparisons = getPropertyComparisonsAsStrings();
    final comparisonEntry = {
      'ids': propertyIds,
      'timestamp': DateTime.now().toIso8601String(),
    };
    comparisons.insert(0, jsonEncode(comparisonEntry));
    // Keep only last 10 comparisons
    if (comparisons.length > 10) {
      comparisons.removeRange(10, comparisons.length);
    }
    await _prefs.setStringList('property_comparisons', comparisons);
  }

  List<String> getPropertyComparisonsAsStrings() {
    return _prefs.getStringList('property_comparisons') ?? [];
  }

  List<Map<String, dynamic>> getPropertyComparisons() {
    final comparisons = getPropertyComparisonsAsStrings();
    return comparisons.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // Property alerts
  Future<void> addPropertyAlert(Map<String, dynamic> alert) async {
    final alerts = getPropertyAlertsAsStrings();
    alerts.add(jsonEncode(alert));
    await _prefs.setStringList('property_alerts', alerts);
  }

  List<String> getPropertyAlertsAsStrings() {
    return _prefs.getStringList('property_alerts') ?? [];
  }

  List<Map<String, dynamic>> getPropertyAlerts() {
    final alerts = getPropertyAlertsAsStrings();
    return alerts.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> removePropertyAlert(int index) async {
    final alertStrings = getPropertyAlertsAsStrings();
    if (index >= 0 && index < alertStrings.length) {
      alertStrings.removeAt(index);
      await _prefs.setStringList('property_alerts', alertStrings);
    }
  }
}