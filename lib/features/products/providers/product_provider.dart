import 'package:flutter/foundation.dart';
import '../../../core/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Getters
  List<Map<String, dynamic>> get products => _filteredProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Load all products
  Future<void> loadProducts() async {
    _setLoading(true);
    try {
      debugPrint('Starting to load products...');
      _products = await _productService.getAllProducts();
      debugPrint('Loaded ${_products.length} products from service');
      _categories = await _productService.getCategories();
      debugPrint('Loaded ${_categories.length} categories');
      _categories.insert(0, 'All'); // Add "All" option
      _applyFilters();
      _error = null;
      debugPrint('Finished loading products, filtered products count: ${_filteredProducts.length}');
    } catch (e, stackTrace) {
      _error = e.toString();
      debugPrint('Error loading products: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      _setLoading(false);
    }
  }

  /// Load products by category
  Future<void> loadProductsByCategory(String category) async {
    _setLoading(true);
    try {
      if (category == 'All') {
        _products = await _productService.getAllProducts();
      } else {
        _products = await _productService.getProductsByCategory(category);
      }
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading products by category: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Search products
  Future<void> searchProducts(String query) async {
    _setLoading(true);
    try {
      if (query.isEmpty) {
        _products = await _productService.getAllProducts();
      } else {
        _products = await _productService.searchProducts(query);
      }
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error searching products: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Set category filter
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Get product by ID
  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      return await _productService.getProductById(id);
    } catch (e) {
      debugPrint('Error getting product by ID: $e');
      return null;
    }
  }

  /// Add new product
  Future<bool> addProduct({
    required String name,
    required double price,
    String? imageUrl,
    String? description,
    String? category,
  }) async {
    try {
      final success = await _productService.addProduct(
        name: name,
        price: price,
        imageUrl: imageUrl,
        description: description,
        category: category,
      );
      
      if (success) {
        await loadProducts(); // Refresh the list
      }
      return success;
    } catch (e) {
      debugPrint('Error adding product: $e');
      return false;
    }
  }

  /// Update product
  Future<bool> updateProduct(String id, Map<String, dynamic> updates) async {
    try {
      final success = await _productService.updateProduct(id, updates);
      if (success) {
        await loadProducts(); // Refresh the list
      }
      return success;
    } catch (e) {
      debugPrint('Error updating product: $e');
      return false;
    }
  }

  /// Delete product
  Future<bool> deleteProduct(String id) async {
    try {
      final success = await _productService.deleteProduct(id);
      if (success) {
        await loadProducts(); // Refresh the list
      }
      return success;
    } catch (e) {
      debugPrint('Error deleting product: $e');
      return false;
    }
  }

  /// Apply current filters to products
  void _applyFilters() {
    debugPrint('Applying filters, products count: ${_products.length}');
    _filteredProducts = List.from(_products);
    debugPrint('Copied to filtered products, count: ${_filteredProducts.length}');
    
    // Apply category filter
    if (_selectedCategory != 'All') {
      _filteredProducts = _filteredProducts
          .where((product) => product['category'] == _selectedCategory)
          .toList();
      debugPrint('After category filter, count: ${_filteredProducts.length}');
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredProducts = _filteredProducts.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        final description = (product['description'] ?? '').toString().toLowerCase();
        return name.contains(query) || description.contains(query);
      }).toList();
      debugPrint('After search filter, count: ${_filteredProducts.length}');
    }
    
    debugPrint('Final filtered products count: ${_filteredProducts.length}');
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear filters
  void clearFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _applyFilters();
  }

  /// Refresh products
  Future<void> refresh() async {
    await loadProducts();
  }
}