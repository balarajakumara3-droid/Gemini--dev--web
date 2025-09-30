import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/restaurant.dart';
import '../../../core/models/user.dart';
import '../../../core/services/api_service.dart';
import '../../cart/providers/cart_provider.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  
  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _menuItems = [];
  bool _isLoadingMenu = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    setState(() {
      _isLoadingMenu = true;
      _errorMessage = null;
    });

    try {
      // Fetch menu items from API instead of using dummy data
      final menu = await _apiService.getRestaurantMenu(widget.restaurant['id']);
      
      setState(() {
        _menuItems = menu.map((item) => item.toJson()).toList();
        _isLoadingMenu = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMenu = false;
        _errorMessage = 'Failed to load menu: $e';
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
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildRestaurantInfo(),
          _buildTabBar(),
          _buildTabContent(),
        ],
      ),
      bottomNavigationBar: _buildCartButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.restaurant['image'] ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: const Icon(
                  Icons.restaurant,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to favorites'),
                backgroundColor: AppTheme.successColor,
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Share restaurant'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.restaurant['name'] ?? 'Restaurant Name',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.restaurant['cuisine'] ?? 'Various Cuisine',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${widget.restaurant['rating'] ?? 4.0}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, color: AppTheme.textSecondary, size: 20),
                const SizedBox(width: 4),
                Text(
                  widget.restaurant['deliveryTime'] ?? '25-30 min',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.delivery_dining, color: AppTheme.textSecondary, size: 20),
                const SizedBox(width: 4),
                Text(
                  widget.restaurant['deliveryFee'] == 0 
                      ? 'Free' 
                      : '₹${widget.restaurant['deliveryFee']}',
                  style: TextStyle(
                    color: widget.restaurant['deliveryFee'] == 0 
                        ? AppTheme.successColor 
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.restaurant['isOpen'] == true 
                    ? AppTheme.successColor.withOpacity(0.1)
                    : AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.restaurant['isOpen'] == true ? 'OPEN NOW' : 'CLOSED',
                style: TextStyle(
                  color: widget.restaurant['isOpen'] == true 
                      ? AppTheme.successColor 
                      : AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primaryColor,
        tabs: const [
          Tab(text: 'Menu'),
          Tab(text: 'Reviews'),
          Tab(text: 'Info'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildMenuTab(),
          _buildReviewsTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  Widget _buildMenuTab() {
    if (_isLoadingMenu) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMenuItems,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_menuItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Menu coming soon',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This restaurant is setting up their menu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final categories = _menuItems.map((item) => item['category'] as String).toSet().toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, categoryIndex) {
        final category = categories[categoryIndex];
        final categoryItems = _menuItems.where((item) => item['category'] == category).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...categoryItems.map((item) => _buildMenuItem(item)),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Food Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.backgroundColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.fastfood,
                    color: AppTheme.primaryColor,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item['isVeg'] == true 
                              ? AppTheme.successColor 
                              : AppTheme.errorColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item['name'] ?? '',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppTheme.accentColor),
                      const SizedBox(width: 2),
                      Text(
                        '${item['rating']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 2),
                      Text(
                        item['preparationTime'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${(item['price'] ?? 0).toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _addToCart(item),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('ADD'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildReviewCard('John Doe', 5, 'Amazing food! Fast delivery and great taste.', '2 days ago'),
        _buildReviewCard('Jane Smith', 4, 'Good quality food. Slightly expensive but worth it.', '1 week ago'),
        _buildReviewCard('Mike Johnson', 5, 'Best pizza in town! Highly recommended.', '2 weeks ago'),
        _buildReviewCard('Sarah Wilson', 4, 'Fresh ingredients and quick service.', '3 weeks ago'),
      ],
    );
  }

  Widget _buildReviewCard(String name, int rating, String review, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  time,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: AppTheme.accentColor,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              review,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            'Address',
            '123 Food Street, Restaurant District, City 400001',
            Icons.location_on,
          ),
          _buildInfoSection(
            'Phone',
            '+91 98765 43210',
            Icons.phone,
          ),
          _buildInfoSection(
            'Hours',
            'Mon-Sun: 10:00 AM - 11:00 PM',
            Icons.access_time,
          ),
          _buildInfoSection(
            'Delivery Area',
            '5 km radius from restaurant',
            Icons.delivery_dining,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartButton() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.itemCount == 0) {
          return const SizedBox.shrink();
        }
        
        return Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.surfaceColor,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${cartProvider.itemCount} items in cart'),
                Row(
                  children: [
                    Text('₹${cartProvider.total.toStringAsFixed(0)}'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    try {
      // Create dummy Food and Restaurant objects from the item data
      final food = Food(
        id: item['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: item['name'] ?? 'Unknown Item',
        description: item['description'] ?? '',
        imageUrl: item['image'] ?? '',
        price: (item['price'] ?? 0.0).toDouble(),
        category: item['category'] ?? 'Main Course',
        isVegetarian: item['isVeg'] ?? false,
        rating: (item['rating'] ?? 0.0).toDouble(),
        reviewCount: 0,
        tags: [],
        addons: [],
        isAvailable: true,
        preparationTime: item['preparationTime'],
      );
      
      final restaurant = Restaurant(
        id: widget.restaurant['id'] ?? 'sample_restaurant',
        name: widget.restaurant['name'] ?? 'Sample Restaurant',
        description: 'Restaurant description',
        imageUrl: widget.restaurant['image'] ?? '',
        cuisines: [widget.restaurant['cuisine'] ?? 'Various'],
        rating: (widget.restaurant['rating'] ?? 4.0).toDouble(),
        reviewCount: 100,
        deliveryTime: widget.restaurant['deliveryTime'] ?? '30-40 min',
        deliveryFee: (widget.restaurant['deliveryFee'] ?? 0.0).toDouble(),
        minimumOrder: 0.0,
        isOpen: widget.restaurant['isOpen'] ?? true,
        address: Address(
          id: 'sample_address',
          title: 'Restaurant Location',
          addressLine1: '123 Sample Street',
          city: 'Sample City',
          state: 'Sample State',
          pincode: '12345',
          country: 'Sample Country',
          latitude: 0.0,
          longitude: 0.0,
        ),
      );
      
      // Add item to cart
      cartProvider.addItem(food, restaurant);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name']} added to cart!'),
          backgroundColor: AppTheme.successColor,
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding ${item['name']} to cart: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}