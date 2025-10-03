import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../food/screens/food_detail_screen.dart';

class FoodGrid extends StatefulWidget {
  final bool vegOnly;
  final double minRating;
  final int? maxPreparationMinutes;
  const FoodGrid({Key? key, this.vegOnly = false, this.minRating = 0.0, this.maxPreparationMinutes}) : super(key: key);

  @override
  State<FoodGrid> createState() => _FoodGridState();
}

class _FoodGridState extends State<FoodGrid> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _foodItems = [];
  List<String> _categories = [];
  Map<String, int> _categoryCounts = {};
  String _selectedCategory = 'All';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final int _pageSize = 40;
  int _offset = 0;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  bool _enableImages = false; // Defer image loading until threshold reached
  // Category-focused performance additions
  final Map<String, List<Map<String, dynamic>>> _cachedByCategory = {};
  final Map<String, int> _categoryOffset = {};
  final Map<String, bool> _categoryHasMore = {};
  bool _isCategoryLoading = false; // for shimmer/skeletons during switch
  static const int _filteredPageSize = 120; // larger initial loads for filtered views

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadFoodData(reset: true);
  }

  Future<void> _loadFoodData({bool reset = false}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
        _foodItems = [];
        _offset = 0;
        _hasMore = true;
      });
      // Refresh categories list independently of pagination
      _loadCategories();
    }

    try {
      if (!_hasMore) return;

      final response = await supabase
          .from('products')
          .select()
          .range(_offset, _offset + _pageSize - 1);

      final fetched = List<Map<String, dynamic>>.from(response as List);
      _foodItems.addAll(fetched);
      _offset += fetched.length;
      _hasMore = fetched.length == _pageSize;

      // Optionally compute counts from loaded window without overriding chips
      final Map<String, int> counts = {};
      for (var item in _foodItems) {
        final String category = _extractCategory(item);
        if (category.isEmpty) continue;
        counts[category] = (counts[category] ?? 0) + 1;
      }
      _categoryCounts = counts;

      // Enable images once we have at least 20 items
      if (!_enableImages && _foodItems.length >= 20) {
        _enableImages = true;
      }
      
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadCategoryData(String category, {bool reset = false}) async {
    if (category == 'All') return;
    if (reset || !_cachedByCategory.containsKey(category)) {
      _cachedByCategory[category] = [];
      _categoryOffset[category] = 0;
      _categoryHasMore[category] = true;
    }

    if (_isCategoryLoading || _categoryHasMore[category] == false) return;

    setState(() {
      _isCategoryLoading = true;
      _error = null;
    });

    try {
      final start = _categoryOffset[category] ?? 0;
      final end = start + _filteredPageSize - 1;

      // 1) Try server-side category match
      final responseEq = await supabase
          .from('products')
          .select()
          .eq('category', category)
          .range(start, end);

      List<Map<String, dynamic>> fetched = List<Map<String, dynamic>>.from(responseEq as List);

      // 2) Fallback: if nothing returned and we're at the first page, load a wider
      //    window without filters and infer category client-side by name keywords.
      if (fetched.isEmpty && start == 0) {
        final fallbackResp = await supabase
            .from('products')
            .select()
            .range(0, (_filteredPageSize * 2) - 1); // fetch extra to filter locally
        final all = List<Map<String, dynamic>>.from(fallbackResp as List);
        final filtered = all.where((e) => _extractCategory(e) == category).take(_filteredPageSize).toList();
        fetched = filtered;
      }

      _cachedByCategory[category]!.addAll(fetched);
      _categoryOffset[category] = start + fetched.length;
      _categoryHasMore[category] = fetched.length == _filteredPageSize;

      // Precache first few images for snappier feel
      _precacheFirstImages(_cachedByCategory[category]!);

      // Prefetch next page opportunistically
      if (mounted && fetched.length == _filteredPageSize) {
        final nextStart = _categoryOffset[category]!;
        final nextEnd = nextStart + _filteredPageSize - 1;
        // Fire-and-forget; avoid blocking UI
        supabase
            .from('products')
            .select()
            .eq('category', category)
            .range(nextStart, nextEnd)
            .then((next) {
          final nextFetched = List<Map<String, dynamic>>.from(next as List);
          _cachedByCategory[category]!.addAll(nextFetched);
          _categoryOffset[category] = nextStart + nextFetched.length;
          _categoryHasMore[category] = nextFetched.length == _filteredPageSize;
          // Precache some of the next images
          _precacheFirstImages(nextFetched);
          if (mounted) setState(() {});
        }).catchError((_) {});
      }

      setState(() {
        _isCategoryLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isCategoryLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  String _buildOrFilterForCategory(String category) {
    // Maps categories to indicative keywords used in _inferCategoryFromName
    final Map<String, List<String>> categoryToKeywords = {
      'Raw Vegetables And Fruits': ['tomato','banana','spinach','cabbage','carrot','apple'],
      'Snacks': ['chips','samosa','pakoda','fries','nacho','popcorn'],
      'Desserts': ['cake','ice%20cream','brownie','pastry','donut','gulab%20jamun'],
      'Beverages': ['juice','coffee','tea','soda','shake','lassi'],
      'Restaurant Food': [],
    };

    final List<String> conditions = [];
    // Always include exact category match
    conditions.add('category.eq.${_escapeComma(category)}');

    final keywords = categoryToKeywords[category] ?? [];
    if (keywords.isNotEmpty) {
      const nameCols = ['product_name','name','dish_name','item_name'];
      for (final kw in keywords) {
        for (final col in nameCols) {
          conditions.add('$col.ilike.%$kw%');
        }
      }
    }

    // Join with commas for OR
    return conditions.join(',');
  }

  String _escapeComma(String input) {
    // Postgrest OR separator is comma; protect values containing commas
    return input.replaceAll(',', '\\,');
  }

  Future<void> _precacheFirstImages(List<Map<String, dynamic>> items) async {
    // Precache a handful of images in the current context
    final int limit = items.length < 8 ? items.length : 8;
    for (int i = 0; i < limit; i++) {
      final url = _getImageUrl(items[i]);
      if (url.isEmpty || !_isValidImageUrl(url)) continue;
      // ignore: use_build_context_synchronously
      precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  Future<void> _loadCategories() async {
    try {
      final response = await supabase
          .from('products')
          .select('category')
          .not('category', 'is', null)
          .neq('category', '')
          .limit(1000);

      final Set<String> cats = {};
      for (final row in (response as List)) {
        final c = (row['category'] ?? '').toString().trim();
        if (c.isNotEmpty) cats.add(c);
      }

      // Ensure our inferred buckets are always present
      const inferredBuckets = [
        'Restaurant Food',
        'Raw Vegetables And Fruits',
        'Snacks',
        'Desserts',
        'Beverages',
      ];
      cats.addAll(inferredBuckets);

      final list = cats.toList()..sort();
      setState(() {
        _categories = ['All', ...list];
      });
    } catch (_) {
      // If category fetch fails, keep existing list or default to ['All']
      if (_categories.isEmpty) {
        setState(() {
          _categories = ['All'];
        });
      }
    }
  }

  void _maybeLoadMore(ScrollMetrics metrics) {
    if (metrics.pixels < metrics.maxScrollExtent - 300) return;
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    if (_selectedCategory != 'All') {
      _loadCategoryData(_selectedCategory);
    } else {
      if (_hasMore && !_isLoading) {
        _loadFoodData();
      } else {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_error != null) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Products',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadFoodData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_foodItems.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.inventory_2, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No Products Found',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please import products to your Supabase database',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadFoodData,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _maybeLoadMore(notification.metrics);
          return false;
        },
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories section
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: _categories.isNotEmpty 
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                                // Ensure images load immediately even on 'All'
                                _enableImages = true;
                                // Kick off category-specific fetch if needed
                                if (category != 'All' && !_cachedByCategory.containsKey(category)) {
                                  _isCategoryLoading = true;
                                }
                              });
                              if (category != 'All') {
                                _loadCategoryData(category, reset: !_cachedByCategory.containsKey(category));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.orange[100] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: isSelected ? Colors.orange : Colors.grey[300]!),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.orange[800] : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('Loading categories...'),
                      ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Food items section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'All Food Items',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Food grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Builder(builder: (context) {
              final visibleList = _isCategoryLoading && _selectedCategory != 'All'
                  ? const <Map<String, dynamic>>[]
                  : _applyFiltersList();
              return GridView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _isCategoryLoading && _selectedCategory != 'All' 
                  ? 8 
                  : visibleList.length,
              itemBuilder: (context, index) {
                if (_isCategoryLoading && _selectedCategory != 'All') {
                  return _buildSkeletonCard();
                }
                return _buildFoodCard(visibleList[index]);
              },
              );
            }),
          ),
          if (_isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      ),
    );
  }

  Widget _buildCategoryCard(String category) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: Colors.orange[700],
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant food':
        return Icons.restaurant;
      case 'homemade food':
        return Icons.home;
      case 'raw vegetables and fruits':
        return Icons.local_grocery_store;
      case 'packaged food':
        return Icons.inventory_2;
      default:
        return Icons.fastfood;
    }
  }

  Widget _buildFoodCard(Map<String, dynamic> item) {
    String name = (item['name'] ?? item['product_name'] ?? item['dish_name'] ?? item['item_name'] ?? 'Unknown Item').toString();
    String price = item['price']?.toString() ?? '12.99';
    String imageUrl = _getImageUrl(item);
    String category = _extractCategory(item);
    double rating = (item['rating'] ?? 0.0).toDouble();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailScreen(foodItem: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section - Fixed height
            SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      width: double.infinity,
                      child: ((_enableImages || _selectedCategory != 'All') && imageUrl.isNotEmpty && _isValidImageUrl(imageUrl))
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              memCacheWidth: 300,
                              fadeInDuration: const Duration(milliseconds: 80),
                              fadeOutDuration: const Duration(milliseconds: 80),
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.fastfood, size: 24, color: Colors.grey),
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.fastfood, size: 24, color: Colors.grey),
                              ),
                            ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_offer, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              category.isEmpty ? 'General' : category,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content section - Fixed height
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Price and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${_parsePrice(price).toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 10),
                            const SizedBox(width: 1),
                            Text(
                              rating > 0 ? rating.toStringAsFixed(1) : '4.2', 
                              style: TextStyle(fontSize: 9, color: Colors.grey[600])
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),
          // Title placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 12,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Price/rating row placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Container(
                  height: 10,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }


  bool _isValidImageUrl(String url) {
    return url.startsWith('http') || 
           url.contains('.jpg') || 
           url.contains('.png') || 
           url.contains('.jpeg') || 
           url.contains('.webp');
  }

  String _extractCategory(Map<String, dynamic> item) {
    final List<String> candidateKeys = [
      'category',
      'product_category',
      'food_category',
      'type',
    ];
    for (final key in candidateKeys) {
      final value = item[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    // Fallback: infer from product name per provided rules
    final String name = (item['product_name'] ?? item['name'] ?? item['dish_name'] ?? item['item_name'] ?? '').toString();
    if (name.trim().isEmpty) return '';
    return _inferCategoryFromName(name);
  }

  String _inferCategoryFromName(String name) {
    final n = name.toLowerCase().trim();
    // Raw vegetables and fruits
    const rawKeywords = ['tomato','banana','spinach','cabbage','carrot','apple'];
    for (final k in rawKeywords) {
      if (n.contains(k)) return 'Raw Vegetables And Fruits';
    }
    // Snacks
    const snackKeywords = ['chips','samosa','pakoda','fries','nacho','popcorn'];
    for (final k in snackKeywords) {
      if (n.contains(k)) return 'Snacks';
    }
    // Desserts
    const dessertKeywords = ['cake','ice cream','brownie','pastry','donut','gulab jamun'];
    for (final k in dessertKeywords) {
      if (n.contains(k)) return 'Desserts';
    }
    // Beverages
    const beverageKeywords = ['juice','coffee','tea','soda','shake','lassi'];
    for (final k in beverageKeywords) {
      if (n.contains(k)) return 'Beverages';
    }
    // Default
    return 'Restaurant Food';
  }

  double _parsePrice(String priceStr) {
    if (priceStr.isEmpty) return 12.99;
    String cleanPrice = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanPrice) ?? 12.99;
  }

  String _getImageUrl(Map<String, dynamic> item) {
    final List<String> keys = [
      'image_url',
      'image',
      'img',
      'photo_url',
      'thumbnail',
    ];
    for (final k in keys) {
      final v = item[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return '';
  }

  List<Map<String, dynamic>> _applyFiltersList() {
    Iterable<Map<String, dynamic>> list = _selectedCategory != 'All'
        ? (_cachedByCategory[_selectedCategory] ?? const [])
        : _foodItems;
    if (_selectedCategory != 'All') {
      list = list.where((e) => _extractCategory(e) == _selectedCategory);
    }
    if (widget.vegOnly) {
      final isVegKeys = ['is_veg', 'isVeg', 'vegetarian', 'is_vegetarian'];
      list = list.where((e) {
        for (final k in isVegKeys) {
          final v = e[k];
          if (v is bool && v) return true;
        }
        return false;
      });
    }
    if (widget.minRating > 0) {
      list = list.where((e) => ((e['rating'] ?? 0.0) as num).toDouble() >= widget.minRating);
    }
    if (widget.maxPreparationMinutes != null) {
      list = list.where((e) => ((e['preparation_time'] ?? e['preparationTime'] ?? 999) as num) <= widget.maxPreparationMinutes!);
    }
    return list.toList();
  }
}
