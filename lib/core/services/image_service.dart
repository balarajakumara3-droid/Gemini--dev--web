import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'supabase_service.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();
  final SupabaseService _supabaseService = SupabaseService();

  /// Pick an image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
    return null;
  }

  /// Pick an image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
    }
    return null;
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return [];
    }
  }

  /// Show image source selection dialog and pick image
  Future<File?> pickImageWithDialog({
    required Function() showImageSourceDialog,
  }) async {
    // This method can be called from UI to show a dialog
    // and then call either pickImageFromGallery or pickImageFromCamera
    // based on user selection
    return null; // Implementation depends on UI framework
  }

  /// Upload restaurant image
  Future<String> uploadRestaurantImage(File imageFile, String restaurantId) async {
    final fileName = 'restaurant_${restaurantId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await _supabaseService.uploadImage(
      imageFile,
      'restaurants',
      fileName,
    );
  }

  /// Upload menu item image
  Future<String> uploadMenuItemImage(File imageFile, String restaurantId, String menuItemId) async {
    final fileName = 'menu_${menuItemId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await _supabaseService.uploadImage(
      imageFile,
      'menu-items/$restaurantId',
      fileName,
    );
  }

  /// Upload category image
  Future<String> uploadCategoryImage(File imageFile, String categoryId) async {
    final fileName = 'category_${categoryId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await _supabaseService.uploadImage(
      imageFile,
      'categories',
      fileName,
    );
  }

  /// Upload offer/promotion image
  Future<String> uploadOfferImage(File imageFile, String offerId) async {
    final fileName = 'offer_${offerId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await _supabaseService.uploadImage(
      imageFile,
      'offers',
      fileName,
    );
  }

  /// Upload user profile image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    final fileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await _supabaseService.uploadImage(
      imageFile,
      'profiles',
      fileName,
    );
  }

  /// Delete image from storage
  Future<void> deleteImage(String imageUrl) async {
    final imagePath = _extractPathFromUrl(imageUrl);
    if (imagePath != null) {
      await _supabaseService.deleteImage(imagePath);
    }
  }

  /// Helper method to extract path from Supabase storage URL
  String? _extractPathFromUrl(String imageUrl) {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf('food-images');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        return pathSegments.sublist(bucketIndex + 1).join('/');
      }
    } catch (e) {
      debugPrint('Error extracting path from URL: $e');
    }
    return null;
  }

  /// Validate image file
  bool isValidImageFile(File file) {
    final String extension = file.path.toLowerCase().split('.').last;
    final List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    return allowedExtensions.contains(extension);
  }

  /// Get file size in MB
  double getFileSizeInMB(File file) {
    final int bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// Check if file size is within limit
  bool isFileSizeValid(File file, {double maxSizeMB = 5.0}) {
    return getFileSizeInMB(file) <= maxSizeMB;
  }
}