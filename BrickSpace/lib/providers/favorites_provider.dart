import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/property.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  List<Property> _favoriteProperties = [];

  List<String> get favoriteIds => _favoriteIds;
  List<Property> get favoriteProperties => _favoriteProperties;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorites');
      if (favoritesJson != null) {
        _favoriteIds = List<String>.from(json.decode(favoritesJson));
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('favorites', json.encode(_favoriteIds));
    } catch (e) {
      // Handle error silently
    }
  }

  bool isFavorite(String propertyId) {
    return _favoriteIds.contains(propertyId);
  }

  Future<void> toggleFavorite(String propertyId, BuildContext context) async {
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
      _showNotification(context, 'Removed from favorites', Icons.favorite_border);
    } else {
      _favoriteIds.add(propertyId);
      _showNotification(context, 'Added to favorites', Icons.favorite);
    }
    
    await _saveFavorites();
    notifyListeners();
  }

  void _showNotification(BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> addToFavorites(String propertyId) async {
    if (!_favoriteIds.contains(propertyId)) {
      _favoriteIds.add(propertyId);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String propertyId) async {
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
      await _saveFavorites();
      notifyListeners();
    }
  }

  void updateFavoriteProperties(List<Property> allProperties) {
    _favoriteProperties = allProperties
        .where((property) => _favoriteIds.contains(property.id))
        .toList();
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    _favoriteProperties.clear();
    _saveFavorites();
    notifyListeners();
  }
}
