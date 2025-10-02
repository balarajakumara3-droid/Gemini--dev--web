import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../app_config.dart';

/// A reusable widget for displaying food images with proper fallbacks
/// Handles both local assets and network images with caching
class FoodImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool showPlaceholderIcon;
  final Color? placeholderColor;
  final Widget? customPlaceholder;
  final Widget? customErrorWidget;

  const FoodImage({
    Key? key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.showPlaceholderIcon = true,
    this.placeholderColor,
    this.customPlaceholder,
    this.customErrorWidget,
  }) : super(key: key);

  /// Factory constructor for category images
  factory FoodImage.category({
    required String categoryName,
    double width = 60,
    double height = 60,
    BorderRadius? borderRadius,
  }) {
    return FoodImage(
      imageUrl: AppAssets.getCategoryImage(categoryName),
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(width / 2),
      fit: BoxFit.cover,
    );
  }

  /// Factory constructor for menu item images
  factory FoodImage.menuItem({
    required String? imageUrl,
    double width = 120,
    double height = 80,
    BorderRadius? borderRadius,
  }) {
    return FoodImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      fit: BoxFit.cover,
    );
  }

  /// Factory constructor for restaurant images
  factory FoodImage.restaurant({
    required String? imageUrl,
    double width = double.infinity,
    double height = 200,
    BorderRadius? borderRadius,
  }) {
    return FoodImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      fit: BoxFit.cover,
    );
  }

  /// Factory constructor for offer banners
  factory FoodImage.offer({
    required String? imageUrl,
    double width = double.infinity,
    double height = 150,
    BorderRadius? borderRadius,
  }) {
    return FoodImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl == null || imageUrl!.isEmpty) {
      imageWidget = _buildPlaceholder(context);
    } else if (imageUrl!.startsWith('http')) {
      imageWidget = _buildNetworkImage(context);
    } else {
      imageWidget = _buildAssetImage(context);
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildNetworkImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildLoadingPlaceholder(context),
      errorWidget: (context, url, error) => _buildErrorWidget(context),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }

  Widget _buildAssetImage(BuildContext context) {
    return Image.asset(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (customPlaceholder != null) {
      return customPlaceholder!;
    }

    return Container(
      width: width,
      height: height,
      color: placeholderColor ?? Colors.grey[300],
      child: showPlaceholderIcon
          ? Icon(
              Icons.image,
              color: Colors.grey[600],
              size: (width < height ? width : height) * 0.3,
            )
          : null,
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: placeholderColor ?? Colors.grey[200],
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (customErrorWidget != null) {
      return customErrorWidget!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.grey[600],
            size: (width < height ? width : height) * 0.2,
          ),
          if (height > 60)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Image not found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

/// Extension to easily get food images from models
extension FoodImageExtension on String? {
  /// Convert image URL to FoodImage widget
  FoodImage toFoodImage({
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return FoodImage(
      imageUrl: this,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
    );
  }

  /// Convert to category image
  FoodImage toCategoryImage({
    double size = 60,
  }) {
    return FoodImage.category(
      categoryName: this ?? '',
      width: size,
      height: size,
    );
  }

  /// Convert to menu item image
  FoodImage toMenuItemImage({
    double width = 120,
    double height = 80,
  }) {
    return FoodImage.menuItem(
      imageUrl: this,
      width: width,
      height: height,
    );
  }

  /// Convert to restaurant image
  FoodImage toRestaurantImage({
    double width = double.infinity,
    double height = 200,
  }) {
    return FoodImage.restaurant(
      imageUrl: this,
      width: width,
      height: height,
    );
  }
}
