import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PropertyAlertsScreen extends StatefulWidget {
  const PropertyAlertsScreen({super.key});

  @override
  State<PropertyAlertsScreen> createState() => _PropertyAlertsScreenState();
}

class _PropertyAlertsScreenState extends State<PropertyAlertsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String _propertyType = 'any';
  String _listingType = 'any';
  bool _notificationsEnabled = true;

  @override
  void dispose() {
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Alerts'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get notified when new properties match your criteria',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            _buildAlertForm(),
            const SizedBox(height: 30),
            _buildActiveAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Alert',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _locationController,
              label: 'Location',
              hint: 'Enter city, neighborhood, or ZIP code',
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _minPriceController,
                    label: 'Min Price',
                    hint: '\$0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _maxPriceController,
                    label: 'Max Price',
                    hint: 'No limit',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildPropertyTypeSelector(),
            const SizedBox(height: 20),
            _buildListingTypeSelector(),
            const SizedBox(height: 20),
            _buildNotificationToggle(),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Create Alert',
              onPressed: _createAlert,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Property Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _propertyType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'any', child: Text('Any Type')),
            DropdownMenuItem(value: 'house', child: Text('House')),
            DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
            DropdownMenuItem(value: 'villa', child: Text('Villa')),
            DropdownMenuItem(value: 'office', child: Text('Office')),
            DropdownMenuItem(value: 'land', child: Text('Land')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _propertyType = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildListingTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Listing Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _listingType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'any', child: Text('Any Type')),
            DropdownMenuItem(value: 'sale', child: Text('For Sale')),
            DropdownMenuItem(value: 'rent', child: Text('For Rent')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _listingType = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildNotificationToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Enable Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Switch(
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
          activeColor: const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  Widget _buildActiveAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Alerts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        // In a real app, you would fetch actual alerts from your database
        _buildAlertItem(
          'New York, NY',
          '\$500,000 - \$1,000,000',
          'House',
          'For Sale',
          true,
        ),
        const SizedBox(height: 16),
        _buildAlertItem(
          'Brooklyn, NY',
          '\$2,000 - \$4,000/month',
          'Apartment',
          'For Rent',
          true,
        ),
      ],
    );
  }

  Widget _buildAlertItem(
    String location,
    String priceRange,
    String propertyType,
    String listingType,
    bool enabled,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$priceRange • $propertyType • $listingType',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (value) {
              // In a real app, you would update the alert status in your database
            },
            activeColor: const Color(0xFF4CAF50),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // In a real app, you would delete the alert from your database
            },
          ),
        ],
      ),
    );
  }

  void _createAlert() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would save this alert to your database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Property alert created successfully!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      
      // Clear form
      _locationController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      setState(() {
        _propertyType = 'any';
        _listingType = 'any';
      });
    }
  }
}