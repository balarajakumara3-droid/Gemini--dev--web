import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseClient get client => _supabase;

  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.example.food_delivery_app://login-callback',
      );
      return _supabase.auth.currentUser != null;
    } on AuthException catch (error) {
      throw Exception('Google sign in failed: ${error.message}');
    } catch (error) {
      throw Exception('Google sign in failed: $error');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      final data = await _supabase.from('restaurants').select();
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      debugPrint('Error fetching restaurants: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getRestaurantById(String id) async {
    try {
      final response = await _supabase.from('restaurants').select().eq('id', id).single();
      if (response != null) {
        return Map<String, dynamic>.from(response as Map);
      }
    } catch (e) {
      debugPrint('Error fetching restaurant by id: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> searchRestaurants(String query) async {
    try {
      final data = await _supabase
          .from('restaurants')
          .select()
          .or('name.ilike.%$query%,cuisine.ilike.%$query%');
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      debugPrint('Error searching restaurants: $e');
      return [];
    }
  }

  Future<String> uploadImage(File imageFile, String folderPath, String fileName) async {
    try {
      final String path = '$folderPath/$fileName';
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

  Future<List<String>> uploadMultipleImages(List<File> imageFiles, String folderPath) async {
    final List<String> imageUrls = [];
    for (int i = 0; i < imageFiles.length; i++) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      try {
        final imageUrl = await uploadImage(imageFiles[i], folderPath, fileName);
        imageUrls.add(imageUrl);
      } catch (e) {
        debugPrint('Failed to upload image $i: $e');
      }
    }
    return imageUrls;
  }

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

  Future<void> createRestaurantWithImage(String name, String address, File imageFile, {Map<String, dynamic>? additionalData}) async {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final String imageUrl = await uploadImage(imageFile, 'restaurants', fileName);
    final restaurantData = {
      'name': name,
      'address': address,
      'image_url': imageUrl,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
      ...?additionalData,
    };
    await _supabase.from('restaurants').insert(restaurantData);
  }

  Future<void> updateRestaurantImage(String restaurantId, File newImageFile) async {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${newImageFile.path.split('/').last}';
    final String newImageUrl = await uploadImage(newImageFile, 'restaurants', fileName);
    await _supabase.from('restaurants').update({'image_url': newImageUrl}).eq('id', restaurantId);
  }

  Future<void> createMenuItemWithImage(String restaurantId, String name, String description, double price, File imageFile, {Map<String, dynamic>? additionalData}) async {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final String imageUrl = await uploadImage(imageFile, 'menu-items/$restaurantId', fileName);
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
  }

  // Removed demo data seeding method
}