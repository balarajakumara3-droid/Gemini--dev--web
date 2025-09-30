import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/app_config.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['Pizza', 'Burger', 'Chinese Food', 'Ice Cream'];
  final List<String> _popularSearches = ['Biryani', 'Dosa', 'North Indian', 'South Indian', 'Fast Food'];
  
  // Dummy search results
  final List<Map<String, dynamic>> _searchResults = [
    {
      'type': 'restaurant',
      'name': 'Pizza Palace',
      'subtitle': 'Italian, Pizza',
      'rating': 4.5,
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100&h=100&fit=crop',
    },
    {
      'type': 'food',
      'name': 'Margherita Pizza',
      'subtitle': 'Pizza Palace',
      'price': 299,
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100&h=100&fit=crop',
    },
    {
      'type': 'restaurant',
      'name': 'Burger House',
      'subtitle': 'American, Burgers',
      'rating': 4.2,
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=100&h=100&fit=crop',
    },
  ];
  
  bool _isSearching = false;
  List<Map<String, dynamic>> _currentResults = [];
  
  // Filter options
  String _selectedCuisine = 'All';
  double _maxDeliveryFee = 100.0;
  double _minRating = 0.0;
  bool _openNowOnly = false;
  String _sortBy = 'Rating'; // Rating, Delivery Time, Price
  
  final List<String> _cuisineOptions = [
    'All', 'Italian', 'American', 'Chinese', 'Indian', 'Mexican', 
    'Japanese', 'Thai', 'Korean', 'French', 'Mediterranean', 'Healthy'
  ];
  
  final List<String> _sortOptions = ['Rating', 'Delivery Time', 'Price', 'Name'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          
          // Search Results / Suggestions
          Expanded(
            child: _isSearching && _searchController.text.isNotEmpty
                ? _buildSearchResults()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRecentSearches(),
                        const SizedBox(height: 24),
                        _buildPopularSearches(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppStrings.searchRestaurants,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppTheme.surfaceColor,
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
            if (value.isNotEmpty) {
              _currentResults = _searchResults.where((item) {
                return item['name'].toLowerCase().contains(value.toLowerCase()) ||
                       item['subtitle'].toLowerCase().contains(value.toLowerCase());
              }).toList();
            }
          });
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _performSearch(value);
          }
        },
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Searches',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((search) {
            return GestureDetector(
              onTap: () => _performSearch(search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(search),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Searches',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularSearches.map((search) {
            return GestureDetector(
              onTap: () => _performSearch(search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, size: 16, color: AppTheme.primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      search,
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
      _currentResults = _searchResults.where((item) {
        return item['name'].toLowerCase().contains(query.toLowerCase()) ||
               item['subtitle'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
    
    // Add to recent searches if not already there
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Found ${_currentResults.length} results for: $query'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
  
  Widget _buildSearchResults() {
    if (_currentResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentResults.length,
      itemBuilder: (context, index) {
        final result = _currentResults[index];
        return _buildSearchResultItem(result);
      },
    );
  }
  
  Widget _buildSearchResultItem(Map<String, dynamic> result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.backgroundColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              result['image'] ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                result['type'] == 'restaurant' ? Icons.restaurant : Icons.fastfood,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
          ),
        ),
        title: Text(
          result['name'] ?? '',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result['subtitle'] ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            if (result['type'] == 'restaurant' && result['rating'] != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                  const SizedBox(width: 4),
                  Text(
                    '${result['rating']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            if (result['type'] == 'food' && result['price'] != null) ...[
              const SizedBox(height: 4),
              Text(
                '₹${result['price']}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        trailing: result['type'] == 'restaurant'
            ? const Icon(Icons.arrow_forward_ios, size: 16)
            : IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${result['name']} added to cart'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
              ),
        onTap: () {
          if (result['type'] == 'restaurant') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening ${result['name']}...'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
  
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedCuisine = 'All';
                        _maxDeliveryFee = 100.0;
                        _minRating = 0.0;
                        _openNowOnly = false;
                        _sortBy = 'Rating';
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const Divider(),
              
              Expanded(
                child: ListView(
                  children: [
                    // Cuisine Filter
                    _buildFilterSection(
                      'Cuisine',
                      DropdownButton<String>(
                        value: _selectedCuisine,
                        isExpanded: true,
                        items: _cuisineOptions.map((cuisine) {
                          return DropdownMenuItem(
                            value: cuisine,
                            child: Text(cuisine),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
                            _selectedCuisine = value!;
                          });
                        },
                      ),
                    ),
                    
                    // Delivery Fee Filter
                    _buildFilterSection(
                      'Max Delivery Fee (₹${_maxDeliveryFee.toInt()})',
                      Slider(
                        value: _maxDeliveryFee,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          setModalState(() {
                            _maxDeliveryFee = value;
                          });
                        },
                      ),
                    ),
                    
                    // Rating Filter
                    _buildFilterSection(
                      'Minimum Rating (${_minRating.toStringAsFixed(1)} stars)',
                      Slider(
                        value: _minRating,
                        min: 0,
                        max: 5,
                        divisions: 10,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          setModalState(() {
                            _minRating = value;
                          });
                        },
                      ),
                    ),
                    
                    // Open Now Filter
                    _buildFilterSection(
                      'Availability',
                      SwitchListTile(
                        title: const Text('Open now only'),
                        value: _openNowOnly,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          setModalState(() {
                            _openNowOnly = value;
                          });
                        },
                      ),
                    ),
                    
                    // Sort By Filter
                    _buildFilterSection(
                      'Sort By',
                      DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        items: _sortOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setModalState(() {
                            _sortBy = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        content,
        const SizedBox(height: 20),
      ],
    );
  }
  
  void _applyFilters() {
    setState(() {
      _currentResults = _searchResults.where((item) {
        // Apply cuisine filter
        if (_selectedCuisine != 'All' && 
            !item['subtitle'].toLowerCase().contains(_selectedCuisine.toLowerCase())) {
          return false;
        }
        
        // Apply rating filter (for restaurants only)
        if (item['type'] == 'restaurant' && item['rating'] < _minRating) {
          return false;
        }
        
        return true;
      }).toList();
      
      // Apply sorting
      _currentResults.sort((a, b) {
        switch (_sortBy) {
          case 'Rating':
            return (b['rating'] ?? 0.0).compareTo(a['rating'] ?? 0.0);
          case 'Name':
            return (a['name'] ?? '').compareTo(b['name'] ?? '');
          case 'Price':
            return (a['price'] ?? 0).compareTo(b['price'] ?? 0);
          default:
            return 0;
        }
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied filters - ${_currentResults.length} results'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}