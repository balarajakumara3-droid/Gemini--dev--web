# Image Upload with Supabase Storage

This guide demonstrates how to use the image upload functionality with Supabase Storage in your Flutter food delivery app.

## Setup

### 1. Supabase Storage Setup

In your Supabase project dashboard:

1. Navigate to **Storage**
2. Create a new bucket named `food-images`
3. Set up Storage Policies:
   - **SELECT**: Allow public access for viewing images
   - **INSERT**: Allow authenticated users to upload images
   - **DELETE**: Allow only specific roles to delete images

### 2. Flutter Dependencies

The following dependencies are already added to `pubspec.yaml`:

```yaml
dependencies:
  supabase_flutter: ^2.0.0
  image_picker: ^1.0.4
  cached_network_image: ^3.3.0
```

## Usage Examples

### 1. Basic Image Upload

```dart
import 'package:flutter/material.dart';
import 'core/services/image_service.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final ImageService _imageService = ImageService();
  String? _imageUrl;

  Future<void> _pickAndUploadImage() async {
    // Pick image from gallery
    final imageFile = await _imageService.pickImageFromGallery();
    
    if (imageFile != null) {
      try {
        // Upload to restaurant folder
        final imageUrl = await _imageService.uploadRestaurantImage(
          imageFile, 
          'restaurant_123'
        );
        
        setState(() {
          _imageUrl = imageUrl;
        });
        
        print('Image uploaded: $imageUrl');
      } catch (e) {
        print('Upload failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_imageUrl != null)
            Image.network(_imageUrl!),
          ElevatedButton(
            onPressed: _pickAndUploadImage,
            child: Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
```

### 2. Using ImageUploadWidget

```dart
import 'package:flutter/material.dart';
import 'core/widgets/image_upload_widget.dart';

class RestaurantForm extends StatefulWidget {
  @override
  _RestaurantFormState createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  String? _restaurantImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Restaurant Image Upload
            ImageUploadWidget(
              initialImageUrl: _restaurantImageUrl,
              uploadType: 'restaurant',
              entityId: 'restaurant_123',
              onImageUploaded: (imageUrl) {
                setState(() {
                  _restaurantImageUrl = imageUrl;
                });
                print('Image uploaded: $imageUrl');
              },
              width: double.infinity,
              height: 200,
              isRequired: true,
              placeholder: 'Add restaurant image',
            ),
            
            // Other form fields...
            TextField(
              decoration: InputDecoration(
                labelText: 'Restaurant Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. Creating Restaurant with Image

```dart
import 'core/services/supabase_service.dart';

class RestaurantService {
  final SupabaseService _supabaseService = SupabaseService();

  Future<void> createRestaurant({
    required String name,
    required String address,
    required File imageFile,
  }) async {
    try {
      // Method 1: Use the helper method
      await _supabaseService.createRestaurantWithImage(
        name,
        address,
        imageFile,
        additionalData: {
          'cuisine': 'Italian',
          'delivery_fee': 2.99,
          'minimum_order': 15.00,
        },
      );
      
      print('Restaurant created successfully!');
    } catch (e) {
      print('Error creating restaurant: $e');
    }
  }
}
```

### 4. Multiple Image Upload

```dart
Future<void> uploadMenuImages() async {
  final ImageService imageService = ImageService();
  
  // Pick multiple images
  final imageFiles = await imageService.pickMultipleImages();
  
  if (imageFiles.isNotEmpty) {
    try {
      // Upload all images to menu-items folder
      final imageUrls = await SupabaseService().uploadMultipleImages(
        imageFiles,
        'menu-items/restaurant_123',
      );
      
      print('Uploaded ${imageUrls.length} images');
      for (final url in imageUrls) {
        print('Image URL: $url');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }
}
```

## Image Types and Organization

### Folder Structure in Supabase Storage

```
food-images/
├── restaurants/
│   ├── restaurant_123_1640995200000.jpg
│   └── restaurant_456_1640995300000.jpg
├── menu-items/
│   ├── restaurant_123/
│   │   ├── menu_item_1_1640995400000.jpg
│   │   └── menu_item_2_1640995500000.jpg
│   └── restaurant_456/
│       └── menu_item_3_1640995600000.jpg
├── categories/
│   ├── category_pizza_1640995700000.jpg
│   └── category_burger_1640995800000.jpg
├── offers/
│   └── offer_123_1640995900000.jpg
└── profiles/
    └── profile_user_456_1641000000000.jpg
```

### Upload Types

- **restaurant**: For restaurant main images
- **menu-item**: For food item images (organized by restaurant)
- **category**: For food category icons/images
- **offer**: For promotional banners
- **profile**: For user profile pictures

## Storage Policies Example

### Allow public read access:
```sql
CREATE POLICY \"Public read access\" ON storage.objects
FOR SELECT USING (bucket_id = 'food-images');
```

### Allow authenticated users to upload:
```sql
CREATE POLICY \"Authenticated users can upload\" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'food-images' 
  AND auth.role() = 'authenticated'
);
```

### Allow users to update their own images:
```sql
CREATE POLICY \"Users can update own images\" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'food-images' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);
```

## Error Handling

```dart
try {
  final imageUrl = await imageService.uploadRestaurantImage(imageFile, restaurantId);
  // Success
} on StorageException catch (e) {
  // Handle Supabase storage specific errors
  print('Storage error: ${e.message}');
} catch (e) {
  // Handle general errors
  print('Upload failed: $e');
}
```

## Best Practices

1. **Image Validation**: Always validate file type and size before upload
2. **Unique Filenames**: Use timestamps to ensure unique filenames
3. **Error Handling**: Implement proper error handling for upload failures
4. **Loading States**: Show upload progress to users
5. **Cleanup**: Delete old images when updating
6. **Compression**: Consider compressing images before upload to save storage space

## Admin Panel Integration

The `AdminRestaurantScreen` demonstrates a complete example of:
- Image upload with validation
- Form integration
- Database updates with image URLs
- Error handling and user feedback

You can use this as a template for creating admin interfaces for managing restaurants, menu items, and other entities that require image uploads."