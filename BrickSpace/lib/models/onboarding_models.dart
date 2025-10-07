class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  String get fullAddress => '$address, $city, $state $postalCode, $country';

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }
}

class PropertyType {
  final String id;
  final String name;
  final String imageUrl;
  final bool isSelected;

  PropertyType({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isSelected = false,
  });

  PropertyType copyWith({bool? isSelected}) {
    return PropertyType(
      id: id,
      name: name,
      imageUrl: imageUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'isSelected': isSelected,
    };
  }

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }
}

class OnboardingData {
  final LocationData? location;
  final List<PropertyType> selectedPropertyTypes;
  final bool isCompleted;

  OnboardingData({
    this.location,
    this.selectedPropertyTypes = const [],
    this.isCompleted = false,
  });

  OnboardingData copyWith({
    LocationData? location,
    List<PropertyType>? selectedPropertyTypes,
    bool? isCompleted,
  }) {
    return OnboardingData(
      location: location ?? this.location,
      selectedPropertyTypes: selectedPropertyTypes ?? this.selectedPropertyTypes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      'selectedPropertyTypes': selectedPropertyTypes.map((e) => e.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      location: json['location'] != null ? LocationData.fromJson(json['location']) : null,
      selectedPropertyTypes: (json['selectedPropertyTypes'] as List<dynamic>?)
          ?.map((e) => PropertyType.fromJson(e))
          .toList() ?? [],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
