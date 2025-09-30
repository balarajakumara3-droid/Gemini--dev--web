import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/services/supabase_service.dart';
import '../../../core/widgets/image_upload_widget.dart';
import '../../../core/theme/app_theme.dart';

class AdminRestaurantScreen extends StatefulWidget {
  final String? restaurantId; // null for creating new restaurant
  
  const AdminRestaurantScreen({
    super.key,
    this.restaurantId,
  });

  @override
  State<AdminRestaurantScreen> createState() => _AdminRestaurantScreenState();
}

class _AdminRestaurantScreenState extends State<AdminRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService _supabaseService = SupabaseService();
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _deliveryFeeController = TextEditingController();
  final TextEditingController _minimumOrderController = TextEditingController();
  
  String? _restaurantImageUrl;
  bool _isActive = true;
  bool _isLoading = false;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.restaurantId != null;
    if (_isEditing) {
      _loadRestaurantData();
    }
  }

  Future<void> _loadRestaurantData() async {
    if (widget.restaurantId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final restaurantData = await _supabaseService.getRestaurantById(widget.restaurantId!);
      
      if (restaurantData != null) {
        _nameController.text = restaurantData['name'] ?? '';
        _addressController.text = restaurantData['address'] ?? '';
        _descriptionController.text = restaurantData['description'] ?? '';
        _cuisineController.text = restaurantData['cuisine'] ?? '';
        _phoneController.text = restaurantData['phone'] ?? '';
        _deliveryFeeController.text = (restaurantData['delivery_fee'] ?? 0).toString();
        _minimumOrderController.text = (restaurantData['minimum_order'] ?? 0).toString();
        _restaurantImageUrl = restaurantData['image_url'];
        _isActive = restaurantData['is_active'] ?? true;
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load restaurant data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Restaurant' : 'Add Restaurant'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteRestaurant,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            const Text(
              'Restaurant Image',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ImageUploadWidget(
                initialImageUrl: _restaurantImageUrl,
                uploadType: 'restaurant',
                entityId: widget.restaurantId ?? 'new_restaurant',
                onImageUploaded: (imageUrl) {
                  setState(() {
                    _restaurantImageUrl = imageUrl;
                  });
                },
                width: double.infinity,
                height: 200,
                isRequired: true,
                placeholder: 'Add restaurant image\n(Required)',
              ),
            ),
            const SizedBox(height: 24),
            
            // Restaurant Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Restaurant Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Restaurant name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Address
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Address is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Cuisine Type
            TextFormField(
              controller: _cuisineController,
              decoration: const InputDecoration(
                labelText: 'Cuisine Type',
                border: OutlineInputBorder(),
                hintText: 'e.g., Italian, Chinese, Indian',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Cuisine type is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            
            // Delivery Fee
            TextFormField(
              controller: _deliveryFeeController,
              decoration: const InputDecoration(
                labelText: 'Delivery Fee (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final fee = double.tryParse(value);
                  if (fee == null || fee < 0) {
                    return 'Enter a valid delivery fee';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Minimum Order
            TextFormField(
              controller: _minimumOrderController,
              decoration: const InputDecoration(
                labelText: 'Minimum Order Amount (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final amount = double.tryParse(value);
                  if (amount == null || amount < 0) {
                    return 'Enter a valid minimum order amount';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Active Status
            SwitchListTile(
              title: const Text('Restaurant Active'),
              subtitle: Text(_isActive ? 'Accepting orders' : 'Not accepting orders'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            
            const SizedBox(height: 80), // Space for bottom button
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _saveRestaurant,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          _isEditing ? 'Update Restaurant' : 'Create Restaurant',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _saveRestaurant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_restaurantImageUrl == null) {
      _showErrorSnackBar('Please add a restaurant image');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final restaurantData = {
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'description': _descriptionController.text.trim(),
        'cuisine': _cuisineController.text.trim(),
        'phone': _phoneController.text.trim(),
        'delivery_fee': double.tryParse(_deliveryFeeController.text) ?? 0.0,
        'minimum_order': double.tryParse(_minimumOrderController.text) ?? 0.0,
        'image_url': _restaurantImageUrl,
        'is_active': _isActive,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (_isEditing) {
        // Update existing restaurant
        await _supabaseService.client
            .from('restaurants')
            .update(restaurantData)
            .eq('id', widget.restaurantId!);
        _showSuccessSnackBar('Restaurant updated successfully');
      } else {
        // Create new restaurant
        restaurantData['created_at'] = DateTime.now().toIso8601String();
        await _supabaseService.client
            .from('restaurants')
            .insert(restaurantData);
        _showSuccessSnackBar('Restaurant created successfully');
      }

      Navigator.of(context).pop(true); // Return true to indicate success
    } catch (e) {
      _showErrorSnackBar('Failed to save restaurant: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRestaurant() async {
    if (widget.restaurantId == null) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Restaurant'),
        content: const Text('Are you sure you want to delete this restaurant? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await _supabaseService.client
            .from('restaurants')
            .delete()
            .eq('id', widget.restaurantId!);
        
        _showSuccessSnackBar('Restaurant deleted successfully');
        Navigator.of(context).pop(true);
      } catch (e) {
        _showErrorSnackBar('Failed to delete restaurant: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _cuisineController.dispose();
    _phoneController.dispose();
    _deliveryFeeController.dispose();
    _minimumOrderController.dispose();
    super.dispose();
  }
}