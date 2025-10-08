import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedAddress = 'San Francisco, CA';

  @override
  void initState() {
    super.initState();
    _searchController.text = _selectedAddress;
    print('LocationSearchScreen: Initialized - WORKING VERSION');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _proceedToNext() {
    print('LocationSearchScreen: Next button tapped');
    print('LocationSearchScreen: Navigating to confirmation with address: $_selectedAddress');
    context.go('/onboarding/location-confirmation');
  }

  void _goBack() {
    print('LocationSearchScreen: Back button tapped');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: _goBack,
        ),
        title: const Text(
          'Search Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search your location',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your address or select from suggestions',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              // Search Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your address',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Color(0xFF4CAF50)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedAddress = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Location Suggestions
              Expanded(
                child: ListView(
                  children: [
                    _buildLocationSuggestion('San Francisco, CA'),
                    _buildLocationSuggestion('New York, NY'),
                    _buildLocationSuggestion('Los Angeles, CA'),
                    _buildLocationSuggestion('Chicago, IL'),
                    _buildLocationSuggestion('Miami, FL'),
                    _buildLocationSuggestion('Seattle, WA'),
                    _buildLocationSuggestion('Boston, MA'),
                    _buildLocationSuggestion('Denver, CO'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _proceedToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSuggestion(String location) {
    return ListTile(
      leading: const Icon(
        Icons.location_on,
        color: Color(0xFF4CAF50),
      ),
      title: Text(location),
      onTap: () {
        setState(() {
          _selectedAddress = location;
          _searchController.text = location;
        });
        print('LocationSearchScreen: Selected $location');
      },
    );
  }
}