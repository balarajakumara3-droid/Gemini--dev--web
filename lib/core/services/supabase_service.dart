import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Public getter for Supabase client
  SupabaseClient get client => _supabase;

  // Authentication methods
  Future<bool> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      return response;
    } on AuthException catch (error) {
      throw Exception('Google sign in failed: ${error.message}');
    } catch (error) {
      throw Exception('Google sign in failed: $error');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Restaurant data methods
  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      final data = await _supabase.from('restaurants').select();
      return data as List<Map<String, dynamic>>;
    } catch (e) {
      print('Error fetching restaurants: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getRestaurantById(String id) async {
    try {
      final response = await _supabase
        .from('restaurants')
        .select()
        .eq('id', id)
        .single();
      
      if (response != null) {
        return response as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching restaurant by id: $e');
    }
    
    return null;
  }

  Future<List<Map<String, dynamic>>> searchRestaurants(String query) async {
    try {
      final data = await _supabase
        .from('restaurants')
        .select()
        .or('name.ilike.%$query%,cuisine.ilike.%$query%');
      
      return data as List<Map<String, dynamic>>;
    } catch (e) {
      print('Error searching restaurants: $e');
      return [];
    }
  }

  // Image upload methods
  Future<String> uploadImage(File imageFile, String folderPath, String fileName) async {
    try {
      final String path = '$folderPath/$fileName'; // e.g., 'restaurants/restaurant_id/image.jpg'

      await _supabase.storage.from('food-images').upload(
        path, 
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600'),
      );
      
      final String imageUrl = _supabase.storage.from('food-images').getPublicUrl(path);
      return imageUrl;

    } on StorageException catch (e) {
      debugPrint('Storage upload error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('General upload error: $e');
      rethrow;
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, 
    String folderPath,
  ) async {
    final List<String> imageUrls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      try {
        final imageUrl = await uploadImage(imageFiles[i], folderPath, fileName);
        imageUrls.add(imageUrl);
      } catch (e) {
        debugPrint('Failed to upload image $i: $e');
        // Continue uploading other images even if one fails
      }
    }
    
    return imageUrls;
  }

  // Delete image from storage
  Future<void> deleteImage(String imagePath) async {
    try {
      await _supabase.storage.from('food-images').remove([imagePath]);
    } on StorageException catch (e) {
      debugPrint('Storage delete error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('General delete error: $e');
      rethrow;
    }
  }

  // Example usage to save a restaurant with image
  Future<void> createRestaurantWithImage(
    String name, 
    String address, 
    File imageFile, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // 1. Upload the image
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final String imageUrl = await uploadImage(
        imageFile,
        'restaurants', // Folder inside bucket
        fileName, // Unique filename
      );

      // 2. Insert restaurant data with the image URL
      final restaurantData = {
        'name': name,
        'address': address,
        'image_url': imageUrl,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
        ...?additionalData, // Spread additional data if provided
      };
      
      await _supabase.from('restaurants').insert(restaurantData);
    } catch (e) {
      debugPrint('Error creating restaurant with image: $e');
      rethrow;
    }
  }

  // Update restaurant with new image
  Future<void> updateRestaurantImage(
    String restaurantId, 
    File newImageFile,
  ) async {
    try {
      // 1. Get current restaurant data to delete old image
      final currentData = await getRestaurantById(restaurantId);
      
      // 2. Upload new image
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${newImageFile.path.split('/').last}';
      final String newImageUrl = await uploadImage(
        newImageFile,
        'restaurants',
        fileName,
      );
      
      // 3. Update restaurant with new image URL
      await _supabase
          .from('restaurants')
          .update({'image_url': newImageUrl})
          .eq('id', restaurantId);
      
      // 4. Delete old image if it exists
      if (currentData != null && currentData['image_url'] != null) {
        final oldImageUrl = currentData['image_url'] as String;
        final oldImagePath = _extractPathFromUrl(oldImageUrl);
        if (oldImagePath != null) {
          try {
            await deleteImage(oldImagePath);
          } catch (e) {
            debugPrint('Failed to delete old image: $e');
            // Don't rethrow - new image is already uploaded and database updated
          }
        }
      }
    } catch (e) {
      debugPrint('Error updating restaurant image: $e');
      rethrow;
    }
  }

  // Create menu item with image
  Future<void> createMenuItemWithImage(
    String restaurantId,
    String name,
    String description,
    double price,
    File imageFile, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // 1. Upload the image
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final String imageUrl = await uploadImage(
        imageFile,
        'menu-items/$restaurantId', // Folder inside bucket organized by restaurant
        fileName,
      );

      // 2. Insert menu item data with the image URL
      final menuItemData = {
        'restaurant_id': restaurantId,
        'name': name,
        'description': description,
        'price': price,
        'image_url': imageUrl,
        'is_available': true,
        'created_at': DateTime.now().toIso8601String(),
        ...?additionalData,
      };
      
      await _supabase.from('menu_items').insert(menuItemData);
    } catch (e) {
      debugPrint('Error creating menu item with image: $e');
      rethrow;
    }
  }

  // Helper method to extract path from Supabase storage URL
  String? _extractPathFromUrl(String imageUrl) {
    try {
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the bucket name in the path and extract everything after it
      final bucketIndex = pathSegments.indexOf('food-images');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        return pathSegments.sublist(bucketIndex + 1).join('/');
      }
    } catch (e) {
      debugPrint('Error extracting path from URL: $e');
    }
    return null;
  }
}