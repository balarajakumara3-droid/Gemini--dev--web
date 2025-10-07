import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationSuggestion> _suggestions = [];
  bool _isLoading = false;
  LatLng? _selectedLocation;
  String _selectedAddress = '';

  @override
  void initState() {
    super.initState();
    _loadPopularLocations();
  }

  void _loadPopularLocations() {
    setState(() {
      _suggestions = [
        LocationSuggestion(
          name: 'Jakarta, Indonesia',
          address: 'Jakarta, Indonesia',
          coordinates: const LatLng(-6.2088, 106.8456),
        ),
        LocationSuggestion(
          name: 'Bali, Indonesia',
          address: 'Bali, Indonesia',
          coordinates: const LatLng(-8.3405, 115.0920),
        ),
        LocationSuggestion(
          name: 'Surabaya, Indonesia',
          address: 'Surabaya, Indonesia',
          coordinates: const LatLng(-7.2575, 112.7521),
        ),
        LocationSuggestion(
          name: 'Bandung, Indonesia',
          address: 'Bandung, Indonesia',
          coordinates: const LatLng(-6.9175, 107.6191),
        ),
        LocationSuggestion(
          name: 'Yogyakarta, Indonesia',
          address: 'Yogyakarta, Indonesia',
          coordinates: const LatLng(-7.7956, 110.3695),
        ),
        LocationSuggestion(
          name: 'Medan, Indonesia',
          address: 'Medan, Indonesia',
          coordinates: const LatLng(3.5952, 98.6722),
        ),
      ];
    });
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _loadPopularLocations();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _suggestions = _suggestions
              .where((suggestion) =>
                  suggestion.name.toLowerCase().contains(query.toLowerCase()) ||
                  suggestion.address.toLowerCase().contains(query.toLowerCase()))
              .toList();
          _isLoading = false;
        });
      }
    });
  }

  void _selectLocation(LocationSuggestion suggestion) {
    setState(() {
      _selectedLocation = suggestion.coordinates;
      _selectedAddress = suggestion.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Account Setup / Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Find location',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: Icon(Icons.mic, color: Colors.grey),
              ),
            ),
          ),

          // Map Section
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-6.2088, 106.8456), // Jakarta
                    zoom: 10,
                  ),
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: _selectedLocation!,
                            infoWindow: InfoWindow(title: _selectedAddress),
                          ),
                        }
                      : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Location Suggestions
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Popular Locations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = _suggestions[index];
                            final isSelected = _selectedLocation == suggestion.coordinates;
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[200]!,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: isSelected ? Colors.white : Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  suggestion.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? const Color(0xFF2E7D32) : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  suggestion.address,
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.7) : Colors.grey[600],
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF2E7D32),
                                      )
                                    : const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                onTap: () => _selectLocation(suggestion),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Choose Location Button
          if (_selectedLocation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(_selectedAddress);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Choose your location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),

          // Progress Indicator
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.25,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class LocationSuggestion {
  final String name;
  final String address;
  final LatLng coordinates;

  LocationSuggestion({
    required this.name,
    required this.address,
    required this.coordinates,
  });
}
