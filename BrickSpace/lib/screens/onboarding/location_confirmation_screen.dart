import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationConfirmationScreen extends StatefulWidget {
  const LocationConfirmationScreen({super.key});

  @override
  State<LocationConfirmationScreen> createState() => _LocationConfirmationScreenState();
}

class _LocationConfirmationScreenState extends State<LocationConfirmationScreen> {
  String _selectedAddress = 'Getting your location...';
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(-6.1753, 106.8271); // West Jakarta default
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    print('LocationConfirmationScreen: initState called - SIMPLIFIED VERSION');
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
            _selectedAddress = 'Location permission denied';
            _isLoadingLocation = false;
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
          final fullAddress = [
            if (placemark.street?.isNotEmpty ?? false) placemark.street,
            if (placemark.subLocality?.isNotEmpty ?? false) placemark.subLocality,
            if (placemark.locality?.isNotEmpty ?? false) placemark.locality,
            if (placemark.administrativeArea?.isNotEmpty ?? false) placemark.administrativeArea,
            if (placemark.country?.isNotEmpty ?? false) placemark.country,
            if (placemark.postalCode?.isNotEmpty ?? false) placemark.postalCode,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          
          setState(() {
            _selectedAddress = fullAddress.isNotEmpty ? fullAddress : 'Current Location';
            _isLoadingLocation = false;
          });
        } else {
          setState(() {
            _selectedAddress = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
            _isLoadingLocation = false;
          });
        }
      } catch (e) {
        print('Error reverse geocoding: $e');
        setState(() {
          _selectedAddress = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          _isLoadingLocation = false;
        });
      }
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _selectedAddress = 'Unable to get location';
        _isLoadingLocation = false;
      });
    }
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
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Add your location',
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
                'Add your location',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help us find properties near you',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              // Google Map
              Expanded(
                child: Container(
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
                          onTap: (position) async {
                            setState(() {
                              _currentPosition = position;
                              _isLoadingLocation = true;
                            });
                            
                            // Reverse geocode the tapped position
                            try {
                              List<Placemark> placemarks = await placemarkFromCoordinates(
                                position.latitude,
                                position.longitude,
                              );
                              
                              if (placemarks.isNotEmpty) {
                                final placemark = placemarks.first;
                                final fullAddress = [
                                  if (placemark.street?.isNotEmpty ?? false) placemark.street,
                                  if (placemark.subLocality?.isNotEmpty ?? false) placemark.subLocality,
                                  if (placemark.locality?.isNotEmpty ?? false) placemark.locality,
                                  if (placemark.administrativeArea?.isNotEmpty ?? false) placemark.administrativeArea,
                                  if (placemark.country?.isNotEmpty ?? false) placemark.country,
                                  if (placemark.postalCode?.isNotEmpty ?? false) placemark.postalCode,
                                ].where((e) => e != null && e.isNotEmpty).join(', ');
                                
                                setState(() {
                                  _selectedAddress = fullAddress.isNotEmpty ? fullAddress : 'Selected Location';
                                  _isLoadingLocation = false;
                                });
                              }
                            } catch (e) {
                              print('Error reverse geocoding tapped position: $e');
                              setState(() => _isLoadingLocation = false);
                            }
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
              
              // Selected Location Field
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
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
                      child: Text(
                        _selectedAddress,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    print('LocationConfirmationScreen: Navigating to profile screen');
                    context.go('/onboarding/property-types-selection');
                  },
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
}