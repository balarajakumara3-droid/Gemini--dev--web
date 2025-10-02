# Food Images Usage Examples

This document provides practical examples of how to use the new food image structure in your Flutter app widgets.

## 🎯 Quick Usage Examples

### 1. Using the New FoodImage Widget

```dart
import 'package:flutter/material.dart';
import '../core/widgets/food_image_widget.dart';
import '../core/app_config.dart';

// Simple usage
FoodImage(
  imageUrl: AppAssets.foodMargheritaPizza,
  width: 120,
  height: 80,
)

// Category image with circular border
FoodImage.category(
  categoryName: 'pizza',
  width: 60,
  height: 60,
)

// Menu item with rounded corners
FoodImage.menuItem(
  imageUrl: food.imageUrl,
  width: 100,
  height: 100,
)

// Restaurant banner
FoodImage.restaurant(
  imageUrl: restaurant.imageUrl,
  width: double.infinity,
  height: 200,
)
```

### 2. Using Extension Methods

```dart
// Convert string URLs to FoodImage widgets easily
food.imageUrl.toMenuItemImage(width: 80, height: 80)

// Category images
category.name.toCategoryImage(size: 50)

// Restaurant images
restaurant.imageUrl.toRestaurantImage(height: 150)
```

## 🔧 Updating Existing Widgets

### Update Category Slider Widget

```dart
// File: lib/features/home/widgets/category_slider.dart

import '../../core/widgets/food_image_widget.dart';
import '../../core/app_config.dart';

class CategorySlider extends StatelessWidget {
  final List<Category> categories;

  const CategorySlider({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryItem(context, category);
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // Updated to use FoodImage widget
          FoodImage.category(
            categoryName: category.name,
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
```

### Update Restaurant Card Widget

```dart
// File: lib/features/home/widgets/restaurant_card.dart

import '../../core/widgets/food_image_widget.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Updated restaurant image
            FoodImage.restaurant(
              imageUrl: restaurant.imageUrl,
              width: double.infinity,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisineText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text('${restaurant.rating}'),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(restaurant.deliveryTimeText),
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
}
```

### Update Menu Item Display

```dart
// Example for restaurant detail screen menu items

class MenuItemCard extends StatelessWidget {
  final Food food;
  final VoidCallback? onAddToCart;

  const MenuItemCard({
    Key? key,
    required this.food,
    this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Food image using FoodImage widget
            FoodImage.menuItem(
              imageUrl: food.imageUrl,
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (food.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        food.priceText,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (food.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          food.originalPriceText,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const Spacer(),
                      ElevatedButton(
                        onPressed: onAddToCart,
                        child: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 32),
                        ),
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
}
```

### Update Promotion Banner Widget

```dart
// File: lib/features/home/widgets/promotion_banner.dart

import '../../core/widgets/food_image_widget.dart';
import '../../core/app_config.dart';

class PromotionBanner extends StatelessWidget {
  final List<String> offers;

  const PromotionBanner({Key? key, required this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: FoodImage.offer(
              imageUrl: _getOfferImage(offers[index]),
              width: double.infinity,
              height: 150,
            ),
          );
        },
      ),
    );
  }

  String _getOfferImage(String offer) {
    // Map offer text to image assets
    if (offer.contains('50%')) return AppAssets.offer50Off;
    if (offer.contains('Free Delivery')) return AppAssets.offerFreeDelivery;
    if (offer.contains('Buy One Get One')) return AppAssets.offerBuyOneGetOne;
    if (offer.contains('New User')) return AppAssets.offerNewUser;
    return AppAssets.placeholder;
  }
}
```

## 🎨 Advanced Usage Examples

### 1. Grid Layout for Categories

```dart
class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoryGrid({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryTile(context, category);
      },
    );
  }

  Widget _buildCategoryTile(BuildContext context, Category category) {
    return InkWell(
      onTap: () {
        // Navigate to category screen
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FoodImage.category(
              categoryName: category.name,
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. Food Item with Hero Animation

```dart
class HeroFoodImage extends StatelessWidget {
  final Food food;
  final String heroTag;

  const HeroFoodImage({
    Key? key,
    required this.food,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: FoodImage.menuItem(
        imageUrl: food.imageUrl,
        width: 120,
        height: 80,
      ),
    );
  }
}
```

### 3. Shimmer Loading Effect

```dart
class ShimmerFoodImage extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerFoodImage({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

## 📱 Complete Widget Integration

### Updated Home Screen with Food Images

```dart
// File: lib/features/home/screens/home_screen.dart

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Bar with location
            _buildAppBar(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Promotion Banner with food images
            PromotionBanner(offers: [
              AppAssets.offer50Off,
              AppAssets.offerFreeDelivery,
              AppAssets.offerBuyOneGetOne,
            ]),
            
            const SizedBox(height: 20),
            
            // Categories with food images
            _buildSectionTitle('Categories'),
            CategorySlider(categories: _getCategories()),
            
            const SizedBox(height: 20),
            
            // Restaurants with food images
            _buildSectionTitle('Popular Restaurants'),
            _buildRestaurantsList(),
          ],
        ),
      ),
    );
  }

  List<Category> _getCategories() {
    return [
      Category(id: '1', name: 'Pizza'),
      Category(id: '2', name: 'Burger'),
      Category(id: '3', name: 'Sushi'),
      Category(id: '4', name: 'Indian'),
      Category(id: '5', name: 'Chinese'),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantsList() {
    // Your restaurant list implementation
    return Container(); // Placeholder
  }

  Widget _buildAppBar() {
    // Your app bar implementation
    return Container(); // Placeholder
  }

  Widget _buildSearchBar() {
    // Your search bar implementation
    return Container(); // Placeholder
  }
}
```

## 🚀 Next Steps

1. **Replace placeholder images** with actual food images
2. **Test the FoodImage widget** in different scenarios
3. **Optimize image sizes** for better performance
4. **Add more image constants** to AppAssets as needed
5. **Implement image caching** for better user experience

## 💡 Pro Tips

- Use consistent image dimensions across similar items
- Implement lazy loading for long lists
- Consider using WebP format for better compression
- Add loading states for better UX
- Use hero animations for smooth transitions between screens
