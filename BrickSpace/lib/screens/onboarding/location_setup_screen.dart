import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationSetupScreen extends StatefulWidget {
  const LocationSetupScreen({super.key});

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  String _selectedLocation = 'Getting your location...';
  bool _isLocationSelected = false;
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(-6.1753, 106.8271); // West Jakarta default
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    print('LocationSetupScreen: Initialized - WORKING VERSION');
    _getCurrentLocation();
  }
  
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
  
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final newPermission = await Geolocator.requestPermission();
        if (newPermission == LocationPermission.denied || 
            newPermission == LocationPermission.deniedForever) {
          setState(() {
            _selectedLocation = 'Location permission denied';
            _isLoadingLocation = false;
            _isLocationSelected = false;
          });
          return;
        }
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      
      // Reverse geocode to get address
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final address = [
            if (placemark.subLocality?.isNotEmpty ?? false) placemark.subLocality,
            if (placemark.locality?.isNotEmpty ?? false) placemark.locality,
            if (placemark.administrativeArea?.isNotEmpty ?? false) placemark.administrativeArea,
            if (placemark.country?.isNotEmpty ?? false) placemark.country,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          
          setState(() {
            _selectedLocation = address.isNotEmpty ? address : 'Current Location';
            _isLocationSelected = true;
            _isLoadingLocation = false;
          });
        } else {
          setState(() {
            _selectedLocation = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
            _isLocationSelected = true;
            _isLoadingLocation = false;
          });
        }
      } catch (e) {
        print('Error reverse geocoding: $e');
        setState(() {
          _selectedLocation = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          _isLocationSelected = true;
          _isLoadingLocation = false;
        });
      }
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _selectedLocation = 'Unable to get location';
        _isLoadingLocation = false;
        _isLocationSelected = false;
      });
    }
  }

  void _selectLocation() {
    print('LocationSetupScreen: Location selection tapped');
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Your Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('San Francisco, CA'),
              onTap: () {
                setState(() {
                  _selectedLocation = 'San Francisco, CA';
                  _isLocationSelected = true;
                });
                Navigator.pop(context);
                print('LocationSetupScreen: Selected San Francisco');
              },
            ),
            ListTile(
              title: const Text('New York, NY'),
              onTap: () {
                setState(() {
                  _selectedLocation = 'New York, NY';
                  _isLocationSelected = true;
                });
                Navigator.pop(context);
                print('LocationSetupScreen: Selected New York');
              },
            ),
            ListTile(
              title: const Text('Los Angeles, CA'),
              onTap: () {
                setState(() {
                  _selectedLocation = 'Los Angeles, CA';
                  _isLocationSelected = true;
                });
                Navigator.pop(context);
                print('LocationSetupScreen: Selected Los Angeles');
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToNext() {
    print('LocationSetupScreen: Next button tapped');
    if (_isLocationSelected) {
      print('LocationSetupScreen: Navigating to location search');
      // Instead of going to location-search, let's go to the proper onboarding flow
      context.go('/onboarding-flow');
    }
  }

  void _skipLocation() {
    print('LocationSetupScreen: Skip button tapped');
    context.go('/home');
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
          onPressed: () {
            print('LocationSetupScreen: Back button tapped');
            // Go back to register screen instead of popping
            context.go('/auth/register');
          },
        ),
        title: const Text(
          'Account Setup / L...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _skipLocation,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add your location',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can edit this later on your account setting.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              // Map View Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // Google Maps
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition,
                            zoom: 14,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          onTap: (position) {
                            setState(() => _currentPosition = position);
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                          markers: {
                            Marker(
                              markerId: const MarkerId('selected_location'),
                              position: _currentPosition,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen,
                              ),
                            ),
                          },
                        ),
                        // Loading indicator
                        if (_isLoadingLocation)
                          Container(
                            color: Colors.white.withOpacity(0.8),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        // Current location button
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: _getCurrentLocation,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  color: Color(0xFF4CAF50),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Location Detail Card
              GestureDetector(
                onTap: _selectLocation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location detail',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLocationSelected ? _proceedToNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLocationSelected 
                        ? const Color(0xFF4CAF50) 
                        : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: _isLocationSelected ? Colors.white : Colors.grey[600],
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
}