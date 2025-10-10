import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../filters/price_range_filter_screen.dart';
import '../filters/location_filter_screen.dart';
import '../filters/property_type_filter_screen.dart';

class FeaturedEstatesScreen extends StatefulWidget {
  const FeaturedEstatesScreen({super.key});

  @override
  State<FeaturedEstatesScreen> createState() => _FeaturedEstatesScreenState();
}

class _FeaturedEstatesScreenState extends State<FeaturedEstatesScreen> with TickerProviderStateMixin {
  bool isGridView = true;
  bool isRefreshing = false;
  String searchQuery = '';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> properties = [
    {
      'id': 1,
      'title': 'Sky Dandelions Apartment',
      'price': '\$ 290/month',
      'rating': 4.9,
      'location': 'Jakarta, Indonesia',
      'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&h=300&fit=crop',
      'isFavorite': false,
      'beds': 3,
      'baths': 2,
      'sqft': 1200,
    },
    {
      'id': 2,
      'title': 'The Laurels Villa',
      'price': '\$ 320/month',
      'rating': 4.9,
      'location': 'Bali, Indonesia',
      'image': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&h=300&fit=crop',
      'isFavorite': true,
      'beds': 4,
      'baths': 3,
      'sqft': 1800,
    },
    {
      'id': 3,
      'title': 'Modern Penthouse',
      'price': '\$ 450/month',
      'rating': 4.8,
      'location': 'Surabaya, Indonesia',
      'image': 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400&h=300&fit=crop',
      'isFavorite': false,
      'beds': 2,
      'baths': 2,
      'sqft': 900,
    },
    {
      'id': 4,
      'title': 'Luxury Condo',
      'price': '\$ 380/month',
      'rating': 4.7,
      'location': 'Bandung, Indonesia',
      'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&h=300&fit=crop',
      'isFavorite': true,
      'beds': 3,
      'baths': 2,
      'sqft': 1400,
    },
    {
      'id': 5,
      'title': 'Garden Villa',
      'price': '\$ 520/month',
      'rating': 4.9,
      'location': 'Yogyakarta, Indonesia',
      'image': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&h=300&fit=crop',
      'isFavorite': false,
      'beds': 5,
      'baths': 4,
      'sqft': 2200,
    },
    {
      'id': 6,
      'title': 'City Apartment',
      'price': '\$ 310/month',
      'rating': 4.6,
      'location': 'Medan, Indonesia',
      'image': 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400&h=300&fit=crop',
      'isFavorite': false,
      'beds': 2,
      'baths': 1,
      'sqft': 800,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildResultsHeader(),
              Expanded(
                child: isGridView ? _buildGridView() : _buildListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          // Filter Button
          GestureDetector(
            onTap: () => _showFilterOptions(),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search in featured estate',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Icon(Icons.mic, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '70 ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const TextSpan(
                  text: 'estates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isGridView = true;
                  });
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isGridView ? const Color(0xFF4CAF50) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.grid_view,
                    color: isGridView ? Colors.white : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isGridView = false;
                  });
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: !isGridView ? const Color(0xFF4CAF50) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.view_list,
                    color: !isGridView ? Colors.white : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return _buildPropertyCard(properties[index], isGrid: true);
        },
      ),
    );
  }

  Widget _buildListView() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPropertyCard(properties[index], isGrid: false),
          );
        },
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property, {required bool isGrid}) {
    return GestureDetector(
      onTap: () => _showPropertyDetails(property),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isGrid ? _buildGridCard(property) : _buildListCard(property),
      ),
    );
  }

  Widget _buildGridCard(Map<String, dynamic> property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with price tag and heart
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                property['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            // Price tag
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  property['price'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Heart icon
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _toggleFavorite(property['id']),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    property['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                    color: property['isFavorite'] ? const Color(0xFF4CAF50) : Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      property['rating'].toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property['location'],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(Map<String, dynamic> property) {
    return Row(
      children: [
        // Image
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                property['image'],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            // Price tag
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  property['price'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Heart icon
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _toggleFavorite(property['id']),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    property['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                    color: property['isFavorite'] ? const Color(0xFF4CAF50) : Colors.grey,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      property['rating'].toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property['location'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.bed, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${property['beds']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.bathtub, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${property['baths']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.square_foot, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${property['sqft']} sqft',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Action Methods
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Price Range Option
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _showPriceRangeFilter();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            // Location Option
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _showLocationFilter();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            // Property Type Option
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _showPropertyTypeFilter();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Property Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
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

  void _showPriceRangeFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PriceRangeFilterScreen(),
      ),
    ).then((result) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Price: \$${result['minPrice']} - \$${result['maxPrice']}',
            ),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  void _showLocationFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationFilterScreen(),
      ),
    ).then((result) {
      if (result != null) {
        final locations = result['locations'] as List<String>;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${locations.join(', ')}'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  void _showPropertyTypeFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PropertyTypeFilterScreen(),
      ),
    ).then((result) {
      if (result != null) {
        final types = result['propertyTypes'] as List<String>;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${types.join(', ')}'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  void _showPropertyDetails(Map<String, dynamic> property) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${property['title']} tapped'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _toggleFavorite(int propertyId) {
    setState(() {
      final index = properties.indexWhere((p) => p['id'] == propertyId);
      if (index != -1) {
        properties[index]['isFavorite'] = !properties[index]['isFavorite'];
      }
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      isRefreshing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data refreshed'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}