import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../controllers/onboarding_controller.dart';
import '../../models/onboarding_models.dart';

class Step2LocationDetailScreen extends StatefulWidget {
  const Step2LocationDetailScreen({super.key});

  @override
  State<Step2LocationDetailScreen> createState() => _Step2LocationDetailScreenState();
}

class _Step2LocationDetailScreenState extends State<Step2LocationDetailScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(-6.2088, 106.8456); // Jakarta default
  bool _isLoadingLocation = false;
  String _currentAddress = 'Getting your location...';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _loadCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final newPermission = await Geolocator.requestPermission();
        if (newPermission == LocationPermission.denied || 
            newPermission == LocationPermission.deniedForever) {
          setState(() {
            _currentAddress = 'Location permission denied';
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
            _currentAddress = fullAddress.isNotEmpty ? fullAddress : 'Current Location';
            _isLoadingLocation = false;
          });
          
          // Update location in controller
          context.read<OnboardingController>().setLocation(
            LocationData(
              latitude: position.latitude,
              longitude: position.longitude,
              address: placemark.street ?? '',
              city: placemark.locality ?? '',
              state: placemark.administrativeArea ?? '',
              country: placemark.country ?? '',
              postalCode: placemark.postalCode ?? '',
            ),
          );
        } else {
          setState(() {
            _currentAddress = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
            _isLoadingLocation = false;
          });
        }
      } catch (e) {
        print('Error reverse geocoding: $e');
        setState(() {
          _currentAddress = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          _isLoadingLocation = false;
        });
      }
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _currentAddress = 'Unable to get location';
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Step2LocationDetailScreen: Building widget');
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Stack(
                    children: [
                      _buildMapSection(),
                      _buildBottomSheet(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.read<OnboardingController>().previousStep(),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          // Skip Button
          GestureDetector(
            onTap: () => _skipOnboarding(),
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFF234F68),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Find location',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.mic, color: Colors.grey, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Map Container with Real Google Maps
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
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
                              _currentAddress = fullAddress.isNotEmpty ? fullAddress : 'Selected Location';
                              _isLoadingLocation = false;
                            });
                            
                            // Update location in controller
                            context.read<OnboardingController>().setLocation(
                              LocationData(
                                latitude: position.latitude,
                                longitude: position.longitude,
                                address: placemark.street ?? '',
                                city: placemark.locality ?? '',
                                state: placemark.administrativeArea ?? '',
                                country: placemark.country ?? '',
                                postalCode: placemark.postalCode ?? '',
                              ),
                            );
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
                            BitmapDescriptor.hueBlue,
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
                    // GPS Button
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () => _loadCurrentLocation(),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF234F68),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 24,
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
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Location Detail Header
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF234F68),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Location detail',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Address
                  Consumer<OnboardingController>(
                    builder: (context, controller, child) {
                      final location = controller.onboardingData.location;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF234F68).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFF234F68),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                location?.fullAddress ?? _currentAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Choose Location Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _chooseLocation(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7BC142),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Choose your location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _chooseLocation() {
    print('Step2LocationDetailScreen: _chooseLocation called');
    context.read<OnboardingController>().nextStep();
    print('Step2LocationDetailScreen: nextStep completed');
  }

  void _skipOnboarding() {
    print('Step2LocationDetailScreen: _skipOnboarding called');
    context.read<OnboardingController>().skipToEnd();
  }
}
