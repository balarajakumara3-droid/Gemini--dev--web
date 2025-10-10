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
        print('Loaded favorites: $_favoriteIds');
      }
    } catch (e) {
      print('Error loading favorites: $e');
      // Handle error silently
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('favorites', json.encode(_favoriteIds));
      print('Saved favorites: $_favoriteIds');
    } catch (e) {
      print('Error saving favorites: $e');
      // Handle error silently
    }
  }

  bool isFavorite(String propertyId) {
    final result = _favoriteIds.contains(propertyId);
    print('isFavorite($propertyId): $result');
    return result;
  }

  Future<void> toggleFavorite(String propertyId, BuildContext context) async {
    print('Toggling favorite for property: $propertyId');
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
      _showNotification(context, 'Removed from favorites', Icons.favorite_border);
      print('Removed from favorites: $propertyId');
    } else {
      _favoriteIds.add(propertyId);
      _showNotification(context, 'Added to favorites', Icons.favorite);
      print('Added to favorites: $propertyId');
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
    print('Adding to favorites: $propertyId');
    if (!_favoriteIds.contains(propertyId)) {
      _favoriteIds.add(propertyId);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String propertyId) async {
    print('Removing from favorites: $propertyId');
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
      await _saveFavorites();
      notifyListeners();
    }
  }

  void updateFavoriteProperties(List<Property> allProperties) {
    try {
      print('Updating favorite properties. Favorite IDs: $_favoriteIds');
      print('All properties count: ${allProperties.length}');
      _favoriteProperties = allProperties
          .where((property) {
            final isFavorite = _favoriteIds.contains(property.id);
            print('Property ${property.id} is favorite: $isFavorite');
            return isFavorite;
          })
          .toList();
      print('Favorite properties updated. Count: ${_favoriteProperties.length}');
      notifyListeners();
    } catch (e) {
      print('Error updating favorite properties: $e');
      _favoriteProperties = [];
      notifyListeners();
    }
  }

  void clearFavorites() {
    print('Clearing all favorites');
    _favoriteIds.clear();
    _favoriteProperties.clear();
    _saveFavorites();
    notifyListeners();
  }
}