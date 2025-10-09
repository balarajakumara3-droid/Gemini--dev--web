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
  String _sortBy = 'popular'; // popular | price_asc | price_desc | newest
  bool _sortAscending = true;
  // Basic geo-bounds filter (southWest/ northEast)
  double? _minLatitude;
  double? _maxLatitude;
  double? _minLongitude;
  double? _maxLongitude;

  List<Property> get properties => _filteredProperties;
  List<Property> get allProperties => _properties;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get filters => _filters;
  String get sortBy => _sortBy;

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
    // also clear geo bounds
    _minLatitude = null;
    _maxLatitude = null;
    _minLongitude = null;
    _maxLongitude = null;
    notifyListeners();
  }

  void setSort(String sortKey) {
    _sortBy = sortKey;
    switch (sortKey) {
      case 'price_asc':
        _sortAscending = true;
        break;
      case 'price_desc':
        _sortAscending = false;
        break;
      default:
        // popular/newest handled in _applySort
        _sortAscending = true;
    }
    _applyFilters();
  }

  void setGeoBounds({
    double? minLatitude,
    double? maxLatitude,
    double? minLongitude,
    double? maxLongitude,
  }) {
    _minLatitude = minLatitude;
    _maxLatitude = maxLatitude;
    _minLongitude = minLongitude;
    _maxLongitude = maxLongitude;
    _applyFilters();
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

      // Geo-bounds filter
      if (_minLatitude != null && property.latitude < _minLatitude!) return false;
      if (_maxLatitude != null && property.latitude > _maxLatitude!) return false;
      if (_minLongitude != null && property.longitude < _minLongitude!) return false;
      if (_maxLongitude != null && property.longitude > _maxLongitude!) return false;

      return true;
    }).toList();

    _applySort();
    notifyListeners();
  }

  void _applySort() {
    switch (_sortBy) {
      case 'price_asc':
        _filteredProperties.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        _filteredProperties.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
        _filteredProperties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'popular':
      default:
        // Popular as a proxy: featured first then newest
        _filteredProperties.sort((a, b) {
          if (a.isFeatured != b.isFeatured) {
            return (a.isFeatured ? -1 : 1);
          }
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
    }
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
