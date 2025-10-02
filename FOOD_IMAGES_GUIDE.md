# Food Images Integration Guide

This guide explains how to add exact food images to your Flutter food delivery app with the proper structure and implementation.

## 📁 Directory Structure

Your food images are now organized in the following structure:

```
assets/
└── images/
    └── food/
        ├── categories/          # Food category icons/images
        │   ├── pizza.png
        │   ├── burger.png
        │   ├── sushi.png
        │   ├── indian.png
        │   ├── chinese.png
        │   ├── italian.png
        │   ├── dessert.png
        │   ├── beverage.png
        │   ├── healthy.png
        │   └── fast_food.png
        ├── restaurants/         # Restaurant logos/images
        │   ├── pizza_hut.png
        │   ├── mcdonalds.png
        │   ├── kfc.png
        │   ├── subway.png
        │   └── dominos.png
        ├── menu-items/         # Individual food item images
        │   ├── margherita_pizza.png
        │   ├── cheeseburger.png
        │   ├── salmon_sushi.png
        │   ├── butter_chicken.png
        │   ├── fried_rice.png
        │   ├── pasta.png
        │   ├── chocolate_cake.png
        │   ├── coffee.png
        │   ├── salad.png
        │   └── french_fries.png
        └── offers/             # Promotional banners
            ├── 50_percent_off.png
            ├── free_delivery.png
            ├── buy_one_get_one.png
            └── new_user_discount.png
```

## 🖼️ Image Requirements

### Recommended Image Specifications:
- **Format**: PNG or JPG (PNG preferred for transparency)
- **Category Images**: 100x100px to 200x200px
- **Menu Item Images**: 300x200px to 600x400px (3:2 aspect ratio)
- **Restaurant Images**: 400x200px to 800x400px (2:1 aspect ratio)
- **Offer Banners**: 800x300px to 1200x450px (8:3 aspect ratio)
- **File Size**: Keep under 500KB per image for optimal performance

### Image Quality Guidelines:
- Use high-quality, appetizing food photos
- Ensure good lighting and clear focus
- Use consistent styling across similar items
- Optimize images for mobile viewing
- Consider using WebP format for better compression

## 🔧 Implementation Methods

### Method 1: Using Local Assets (Recommended for Static Images)

#### Step 1: Add Images to Assets Folder
Place your food images in the appropriate subdirectories:

```bash
# Example: Adding a new pizza image
cp your_pizza_image.png assets/images/food/menu-items/pepperoni_pizza.png
```

#### Step 2: Update AppAssets Class
Add new image constants to `lib/core/app_config.dart`:

```dart
class AppAssets {
  // Add new menu item
  static const String foodPepperoniPizza = 'assets/images/food/menu-items/pepperoni_pizza.png';
  
  // Add new category
  static const String categoryMexican = 'assets/images/food/categories/mexican.png';
  
  // Add new restaurant
  static const String restaurantTacoBell = 'assets/images/food/restaurants/taco_bell.png';
}
```

#### Step 3: Use in Widgets
```dart
// In your widget
Image.asset(
  AppAssets.foodPepperoniPizza,
  width: 120,
  height: 80,
  fit: BoxFit.cover,
)

// Or with error handling
Image.asset(
  AppAssets.foodPepperoniPizza,
  width: 120,
  height: 80,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Image.asset(
      AppAssets.placeholder,
      width: 120,
      height: 80,
      fit: BoxFit.cover,
    );
  },
)
```

### Method 2: Using Dynamic Images with Supabase Storage

#### For User-Uploaded or Dynamic Images:

```dart
// Upload a new menu item image
final imageFile = await ImageService().pickImageFromGallery();
if (imageFile != null) {
  final imageUrl = await ImageService().uploadMenuItemImage(
    imageFile,
    'restaurant_id',
    'menu_item_id'
  );
  
  // Save imageUrl to your MenuItem model
  final menuItem = MenuItem(
    id: 'item_id',
    name: 'Delicious Pizza',
    imageUrl: imageUrl, // Use the uploaded URL
    // ... other properties
  );
}
```

#### Display Dynamic Images:
```dart
// Using CachedNetworkImage for better performance
CachedNetworkImage(
  imageUrl: menuItem.imageUrl ?? '',
  width: 120,
  height: 80,
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    width: 120,
    height: 80,
    color: Colors.grey[300],
    child: Icon(Icons.image, color: Colors.grey[600]),
  ),
  errorWidget: (context, url, error) => Image.asset(
    AppAssets.placeholder,
    width: 120,
    height: 80,
    fit: BoxFit.cover,
  ),
)
```

## 📱 Usage Examples in Your App

### 1. Category Slider Widget
```dart
// In category_slider.dart
Widget _buildCategoryItem(Category category) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: AssetImage(AppAssets.getCategoryImage(category.name)),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 8),
      Text(category.name),
    ],
  );
}
```

### 2. Restaurant Card Widget
```dart
// In restaurant_card.dart
Widget _buildRestaurantImage(Restaurant restaurant) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: restaurant.imageUrl.startsWith('http')
        ? CachedNetworkImage(
            imageUrl: restaurant.imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 120,
              color: Colors.grey[300],
            ),
            errorWidget: (context, url, error) => Image.asset(
              AppAssets.placeholder,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : Image.asset(
            restaurant.imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
  );
}
```

### 3. Menu Item Display
```dart
// For displaying food items
Widget _buildFoodItem(Food food) {
  return Card(
    child: Row(
      children: [
        // Food Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: food.imageUrl.isNotEmpty
              ? (food.imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: food.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      food.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ))
              : Image.asset(
                  AppAssets.placeholder,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
        ),
        // Food Details
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(food.description),
                Text(food.priceText, style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
```

## 🎨 Best Practices

### 1. Image Optimization
```dart
// Create a reusable image widget
class FoodImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const FoodImage({
    Key? key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    if (imageUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    return Image.asset(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(
        Icons.image,
        color: Colors.grey[600],
        size: width * 0.3,
      ),
    );
  }
}
```

### 2. Usage of the FoodImage Widget
```dart
// Simple usage
FoodImage(
  imageUrl: food.imageUrl,
  width: 120,
  height: 80,
)

// With specific fit
FoodImage(
  imageUrl: restaurant.imageUrl,
  width: double.infinity,
  height: 200,
  fit: BoxFit.cover,
)
```

## 🚀 Quick Start Checklist

1. **✅ Create directory structure** (Already done)
2. **✅ Update pubspec.yaml** (Already done)
3. **✅ Update AppAssets class** (Already done)
4. **📸 Add your food images** to the appropriate folders
5. **🔄 Run `flutter pub get`** to refresh assets
6. **🔧 Update your widgets** to use the new image structure
7. **🧪 Test on different devices** for image quality

## 📝 Adding New Images

### For Static Images:
1. Add image to appropriate folder in `assets/images/food/`
2. Add constant to `AppAssets` class
3. Use `AppAssets.yourImageName` in widgets

### For Dynamic Images:
1. Use `ImageService` to upload to Supabase
2. Store the returned URL in your model
3. Use `CachedNetworkImage` to display

## 🔍 Troubleshooting

### Common Issues:
- **Image not showing**: Check file path and pubspec.yaml
- **Large app size**: Optimize images before adding
- **Slow loading**: Use `CachedNetworkImage` for network images
- **Memory issues**: Implement proper image caching and disposal

### Performance Tips:
- Use appropriate image sizes for different screen densities
- Implement lazy loading for long lists
- Cache network images properly
- Use placeholder images while loading
