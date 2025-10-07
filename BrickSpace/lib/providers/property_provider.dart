import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/property_service.dart';

class PropertyProvider extends ChangeNotifier {
  List<Property> _properties = [];
  List<Property> _filteredProperties = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};

  List<Property> get properties => _filteredProperties;
  List<Property> get allProperties => _properties;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get filters => _filters;

  final PropertyService _propertyService = PropertyService();

  PropertyProvider() {
    loadProperties();
  }

  Future<void> loadProperties() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _properties = await _propertyService.getProperties();
      _filteredProperties = List.from(_properties);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProperties(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    _filters = {..._filters, ...newFilters};
    _applyFilters();
  }

  void clearFilters() {
    _filters.clear();
    _searchQuery = '';
    _filteredProperties = List.from(_properties);
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProperties = _properties.where((property) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!property.title.toLowerCase().contains(query) &&
            !property.location.toLowerCase().contains(query) &&
            !property.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Price range filter
      if (_filters.containsKey('minPrice')) {
        if (property.price < _filters['minPrice']) return false;
      }
      if (_filters.containsKey('maxPrice')) {
        if (property.price > _filters['maxPrice']) return false;
      }

      // Property type filter
      if (_filters.containsKey('propertyType') && _filters['propertyType'].isNotEmpty) {
        if (property.propertyType != _filters['propertyType']) return false;
      }

      // Listing type filter
      if (_filters.containsKey('listingType') && _filters['listingType'].isNotEmpty) {
        if (property.listingType != _filters['listingType']) return false;
      }

      // Bedrooms filter
      if (_filters.containsKey('bedrooms')) {
        if (property.bedrooms < _filters['bedrooms']) return false;
      }

      // Bathrooms filter
      if (_filters.containsKey('bathrooms')) {
        if (property.bathrooms < _filters['bathrooms']) return false;
      }

      // Amenities filter
      if (_filters.containsKey('amenities') && _filters['amenities'].isNotEmpty) {
        final requiredAmenities = List<String>.from(_filters['amenities']);
        if (!requiredAmenities.every((amenity) => property.amenities.contains(amenity))) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }

  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Property> getFeaturedProperties() {
    return _properties.where((property) => property.isFeatured).toList();
  }

  List<Property> getPropertiesByType(String type) {
    return _properties.where((property) => property.propertyType == type).toList();
  }

  List<Property> getPropertiesByListingType(String listingType) {
    return _properties.where((property) => property.listingType == listingType).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
