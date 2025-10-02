import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/services/excel_image_mapper.dart';
import '../../../core/widgets/food_image_widget.dart';

class ExcelFoodDisplay extends StatefulWidget {
  const ExcelFoodDisplay({Key? key}) : super(key: key);

  @override
  State<ExcelFoodDisplay> createState() => _ExcelFoodDisplayState();
}

class _ExcelFoodDisplayState extends State<ExcelFoodDisplay> with SingleTickerProviderStateMixin {
  final ExcelImageMapper _imageMapper = ExcelImageMapper();
  late TabController _tabController;
  
  List<String> _categories = [];
  List<Map<String, dynamic>> _featuredItems = [];
  Map<String, List<Map<String, dynamic>>> _categoryItems = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      await _imageMapper.initialize();
      
      // Get categories
      _categories = await _imageMapper.getAvailableCategories();
      
      // Initialize tab controller
      _tabController = TabController(length: _categories.length + 1, vsync: this);
      
      // Get featured items (random selection)
      _featuredItems = await _imageMapper.getRandomFoodItems(10);
      
      // Load items for each category
      for (String category in _categories) {
        _categoryItems[category] = await _imageMapper.getFoodItemsByCategory(category);
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Catalog from Excel'),
        bottom: _isLoading || _error != null ? null : TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: 'Featured'),
            ..._categories.map((category) => Tab(text: category)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFeaturedTab(),
                    ..._categories.map((category) => _buildCategoryTab(category)),
                  ],
                ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error loading Excel data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red[600],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _loadExcelData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Featured Items from Your Excel Catalog',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _featuredItems.length,
          itemBuilder: (context, index) {
            return _buildFoodCard(_featuredItems[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryTab(String category) {
    List<Map<String, dynamic>> items = _categoryItems[category] ?? [];
    
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No items found in $category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '$category Items (${items.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildFoodCard(items[index]);
          },
        ),
      ],
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> item) {
    String name = item['Name']?.toString() ?? 'Unknown Item';
    String description = item['Description']?.toString() ?? '';
    String price = item['Price']?.toString() ?? '';
    String imageUrl = item['Image_URL']?.toString() ?? '';
    String category = item['Category']?.toString() ?? '';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                width: double.infinity,
                child: imageUrl.isNotEmpty && (imageUrl.startsWith('http') || imageUrl.startsWith('www'))
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, color: Colors.grey[600]),
                              const SizedBox(height: 4),
                              Text(
                                'Image not found',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, color: Colors.grey[600], size: 32),
                            const SizedBox(height: 4),
                            Text(
                              'No image',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          
          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Category
                  if (category.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      category,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                  
                  // Description
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Price
                  if (price.isNotEmpty)
                    Text(
                      price.startsWith('\$') || price.startsWith('₹') ? price : '\$$price',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
