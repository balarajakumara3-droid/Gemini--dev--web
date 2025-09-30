import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/services/image_service.dart';
import '../../core/theme/app_theme.dart';

class ImageUploadWidget extends StatefulWidget {
  final String? initialImageUrl;
  final Function(String imageUrl)? onImageUploaded;
  final Function(File imageFile)? onImageSelected;
  final String uploadType; // 'restaurant', 'menu-item', 'category', etc.
  final String entityId; // restaurant ID, menu item ID, etc.
  final double width;
  final double height;
  final bool isRequired;
  final String placeholder;

  const ImageUploadWidget({
    super.key,
    this.initialImageUrl,
    this.onImageUploaded,
    this.onImageSelected,
    required this.uploadType,
    required this.entityId,
    this.width = 200,
    this.height = 150,
    this.isRequired = false,
    this.placeholder = 'Tap to add image',
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImageService _imageService = ImageService();
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _uploadedImageUrl = widget.initialImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isRequired && _uploadedImageUrl == null && _selectedImage == null
              ? AppTheme.errorColor
              : AppTheme.textMuted.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isUploading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Uploading...'),
          ],
        ),
      );
    }

    if (_selectedImage != null) {
      return _buildImagePreview(_selectedImage!);
    }

    if (_uploadedImageUrl != null) {
      return _buildNetworkImage(_uploadedImageUrl!);
    }

    return _buildPlaceholder();
  }

  Widget _buildImagePreview(File imageFile) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(imageFile),
              fit: BoxFit.cover,
            ),
          ),
        ),
        _buildImageActions(),
      ],
    );
  }

  Widget _buildNetworkImage(String imageUrl) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.backgroundColor,
                child: const Icon(
                  Icons.error,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
          ),
        ),
        _buildImageActions(),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return InkWell(
      onTap: _showImageSourceDialog,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              widget.placeholder,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageActions() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _showImageSourceDialog,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
            if (_selectedImage != null || _uploadedImageUrl != null)
              IconButton(
                onPressed: _removeImage,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              if (_selectedImage != null || _uploadedImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: AppTheme.errorColor),
                  title: const Text('Remove Image'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final File? imageFile = await _imageService.pickImageFromGallery();
    if (imageFile != null) {
      _handleImageSelected(imageFile);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final File? imageFile = await _imageService.pickImageFromCamera();
    if (imageFile != null) {
      _handleImageSelected(imageFile);
    }
  }

  void _handleImageSelected(File imageFile) {
    // Validate file
    if (!_imageService.isValidImageFile(imageFile)) {
      _showErrorSnackBar('Please select a valid image file (jpg, png, gif, webp)');
      return;
    }

    if (!_imageService.isFileSizeValid(imageFile)) {
      _showErrorSnackBar('Image size should be less than 5MB');
      return;
    }

    setState(() {
      _selectedImage = imageFile;
    });

    // Call the callback if provided
    widget.onImageSelected?.call(imageFile);

    // Auto-upload if callback is provided
    if (widget.onImageUploaded != null) {
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String imageUrl;
      
      switch (widget.uploadType) {
        case 'restaurant':
          imageUrl = await _imageService.uploadRestaurantImage(_selectedImage!, widget.entityId);
          break;
        case 'menu-item':
          // For menu items, entityId should be \"restaurantId:menuItemId\"
          final parts = widget.entityId.split(':');
          final restaurantId = parts[0];
          final menuItemId = parts.length > 1 ? parts[1] : DateTime.now().millisecondsSinceEpoch.toString();
          imageUrl = await _imageService.uploadMenuItemImage(_selectedImage!, restaurantId, menuItemId);
          break;
        case 'category':
          imageUrl = await _imageService.uploadCategoryImage(_selectedImage!, widget.entityId);
          break;
        case 'offer':
          imageUrl = await _imageService.uploadOfferImage(_selectedImage!, widget.entityId);
          break;
        case 'profile':
          imageUrl = await _imageService.uploadProfileImage(_selectedImage!, widget.entityId);
          break;
        default:
          throw Exception('Unknown upload type: ${widget.uploadType}');
      }

      setState(() {
        _uploadedImageUrl = imageUrl;
        _selectedImage = null;
        _isUploading = false;
      });

      widget.onImageUploaded?.call(imageUrl);
      _showSuccessSnackBar('Image uploaded successfully');

    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorSnackBar('Failed to upload image: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _uploadedImageUrl = null;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}