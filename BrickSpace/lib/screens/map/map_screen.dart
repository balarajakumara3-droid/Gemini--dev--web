import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../providers/property_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../models/property.dart';
import '../../config/api_config.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  static const LatLng _defaultLocation = LatLng(37.7749, -122.4194); // San Francisco
  static const CameraPosition _defaultCameraPosition = CameraPosition(
    target: _defaultLocation,
    zoom: 12,
  );
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;
  MapType _mapType = MapType.normal;
  bool _showTraffic = false;
  bool _showTransit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyProvider>().loadProperties();
      _getCurrentLocation();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    print('Map created successfully');
    
    // Animate to current location if available
    if (_currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
      print('Animated to current location: $_currentLocation');
    } else {
      print('No current location available, using default location');
    }
  }

  Future<void> _getCurrentLocation() async {
    print('Getting current location...');
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location services enabled: $serviceEnabled');
      
      if (!serviceEnabled) {
        // Location services are not enabled, show a dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location services are disabled. Please enable location services to use the map.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print('Location permission status: $permission');
      
      if (permission == LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await Geolocator.requestPermission();
        print('Location permission after request: $permission');
        
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission denied. Using default location.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          // Use default location
          setState(() {
            _currentLocation = _defaultLocation;
            _isLoadingLocation = false;
          });
          
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(_defaultLocation, 12),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission permanently denied. Please enable it in settings.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        // Use default location
        setState(() {
          _currentLocation = _defaultLocation;
          _isLoadingLocation = false;
        });
        
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_defaultLocation, 12),
          );
        }
        return;
      }

      print('Getting current position...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Current position obtained: ${position.latitude}, ${position.longitude}');

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 15),
        );
        print('Animated camera to current location');
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Use default location as fallback
      setState(() {
        _currentLocation = _defaultLocation;
        _isLoadingLocation = false;
      });
      
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_defaultLocation, 12),
        );
      }
    }
  }

  void _updateMarkers(List<Property> properties) {
    print('Updating markers with ${properties.length} properties');
    setState(() {
      _markers = <Marker>{};
      
      // If no properties are loaded, add some sample properties
      List<Property> displayProperties = properties;
      if (properties.isEmpty) {
        print('No properties found, adding sample properties');
        // Add sample properties for demonstration
        displayProperties = [
          Property(
            id: 'sample1',
            title: 'Luxury Apartment',
            description: 'Beautiful luxury apartment in the heart of the city',
            price: 2500,
            location: 'Downtown',
            address: '123 Main St, City Center',
            latitude: 37.7749,
            longitude: -122.4194,
            images: [],
            bedrooms: 2,
            bathrooms: 2,
            area: 1200,
            areaUnit: 'sq ft',
            propertyType: 'Apartment',
            listingType: 'rent',
            amenities: ['Parking', 'Gym'],
            agent: Agent(
              id: 'agent1',
              name: 'John Smith',
              email: 'john@example.com',
              phone: '+1234567890',
              profileImage: '',
              company: 'Premium Realty',
              rating: 4.5,
              totalListings: 15,
            ),
            createdAt: DateTime.now(),
          ),
          Property(
            id: 'sample2',
            title: 'Modern Villa',
            description: 'Spacious modern villa with garden',
            price: 4500,
            location: 'Suburbs',
            address: '456 Oak Ave, Green Valley',
            latitude: 37.7849,
            longitude: -122.4094,
            images: [],
            bedrooms: 4,
            bathrooms: 3,
            area: 2500,
            areaUnit: 'sq ft',
            propertyType: 'Villa',
            listingType: 'rent',
            amenities: ['Garden', 'Pool', 'Parking'],
            agent: Agent(
              id: 'agent2',
              name: 'Sarah Johnson',
              email: 'sarah@example.com',
              phone: '+1234567891',
              profileImage: '',
              company: 'Elite Properties',
              rating: 4.8,
              totalListings: 22,
            ),
            createdAt: DateTime.now(),
          ),
        ];
      }
      
      _markers = displayProperties.map((property) {
        print('Adding marker for property: ${property.title} at ${property.latitude}, ${property.longitude}');
        return Marker(
          markerId: MarkerId(property.id),
          position: LatLng(property.latitude, property.longitude),
          infoWindow: InfoWindow(
            title: property.title,
            snippet: property.formattedPrice,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            property.price > 3000 
                ? BitmapDescriptor.hueRed 
                : property.price > 1500 
                    ? BitmapDescriptor.hueOrange 
                    : BitmapDescriptor.hueGreen,
          ),
          onTap: () => _showPropertyInfo(property),
        );
      }).toSet();

      // Add current location marker
      if (_currentLocation != null) {
        print('Adding current location marker at $_currentLocation');
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(
              title: 'Your Location',
              snippet: 'Current position',
            ),
          ),
        );
      }
    });
  }

  void _showPropertyInfo(Property property) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  child: property.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            property.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.home, color: Colors.grey);
                            },
                          ),
                        )
                      : const Icon(Icons.home, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.formattedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${property.bedrooms} bed • ${property.bathrooms} bath • ${property.area.toStringAsFixed(0)} ${property.areaUnit}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/properties/${property.id}');
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to chat with agent
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Contact Agent'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _toggleTraffic() {
    setState(() {
      _showTraffic = !_showTraffic;
    });
  }

  void _toggleTransit() {
    setState(() {
      _showTransit = !_showTransit;
    });
  }

  void _centerOnCurrentLocation() {
    if (_currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          IconButton(
            icon: Icon(_mapType == MapType.normal ? Icons.satellite : Icons.map),
            onPressed: _toggleMapType,
            tooltip: 'Toggle Map Type',
          ),
          IconButton(
            icon: Icon(_showTraffic ? Icons.traffic : Icons.traffic_outlined),
            onPressed: _toggleTraffic,
            tooltip: 'Toggle Traffic',
          ),
          IconButton(
            icon: Icon(_showTransit ? Icons.train : Icons.train_outlined),
            onPressed: _toggleTransit,
            tooltip: 'Toggle Transit',
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Consumer2<PropertyProvider, FavoritesProvider>(
        builder: (context, propertyProvider, favoritesProvider, child) {
          if (propertyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Update markers when properties change
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateMarkers(propertyProvider.properties);
          });

          return Stack(
            children: [
              // Google Maps
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _defaultCameraPosition,
                markers: _markers,
                circles: _circles,
                mapType: _mapType,
                trafficEnabled: _showTraffic,
                myLocationEnabled: true,
                myLocationButtonEnabled: false, // We'll add custom button
                zoomControlsEnabled: true,
                mapToolbarEnabled: true,
                onTap: (LatLng position) {
                  // Handle map tap
                  print('Map tapped at: ${position.latitude}, ${position.longitude}');
                },
              ),

              // Custom Location Button
              Positioned(
                bottom: 320,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: _centerOnCurrentLocation,
                  backgroundColor: Colors.white,
                  child: _isLoadingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location, color: Colors.blue),
                ),
              ),

              // Property List Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Properties Near You',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${propertyProvider.properties.length} found',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Properties List
                      Expanded(
                        child: propertyProvider.properties.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_off,
                                      size: 48,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No properties found',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try adjusting your search criteria',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: propertyProvider.properties.length,
                                itemBuilder: (context, index) {
                                  final property = propertyProvider.properties[index];
                                  return _buildMapPropertyCard(
                                    context,
                                    property,
                                    favoritesProvider,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMapPropertyCard(BuildContext context, Property property, FavoritesProvider favoritesProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigate to property detail
            context.push('/properties/${property.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Property Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  child: property.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            property.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.home, color: Colors.grey);
                            },
                          ),
                        )
                      : const Icon(Icons.home, color: Colors.grey),
                ),
                
                const SizedBox(width: 12),
                
                // Property Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.formattedPrice,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.location,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${property.bedrooms} bed • ${property.bathrooms} bath • ${property.area.toStringAsFixed(0)} ${property.areaUnit}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Favorite Button
                IconButton(
                  icon: Icon(
                    favoritesProvider.isFavorite(property.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoritesProvider.isFavorite(property.id)
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                        favoritesProvider.toggleFavorite(property.id, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}