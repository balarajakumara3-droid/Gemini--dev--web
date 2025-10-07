class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String areaUnit;
  final String propertyType; // apartment, house, villa, etc.
  final String listingType; // rent, sale
  final List<String> amenities;
  final Agent agent;
  final DateTime createdAt;
  final bool isFeatured;
  final bool isAvailable;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'USD',
    required this.location,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    this.areaUnit = 'sqft',
    required this.propertyType,
    required this.listingType,
    required this.amenities,
    required this.agent,
    required this.createdAt,
    this.isFeatured = false,
    this.isAvailable = true,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      area: (json['area'] ?? 0).toDouble(),
      areaUnit: json['areaUnit'] ?? 'sqft',
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      agent: Agent.fromJson(json['agent'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isFeatured: json['isFeatured'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'location': location,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'areaUnit': areaUnit,
      'propertyType': propertyType,
      'listingType': listingType,
      'amenities': amenities,
      'agent': agent.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
    };
  }

  String get formattedPrice {
    return '\$${price.toStringAsFixed(0)}';
  }

  String get propertyInfo {
    return '$bedrooms bed • $bathrooms bath • ${area.toStringAsFixed(0)} $areaUnit';
  }

  // Additional getters for compatibility
  String get type => propertyType;
  List<String> get imageUrls => images;
  String get imageUrl => images.isNotEmpty ? images.first : '';
  String get name => title;
  String get size => '${area.toStringAsFixed(0)} $areaUnit';
  double get rating => agent.rating;
  int get reviewCount => agent.totalListings;
}

class Agent {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String company;
  final double rating;
  final int totalListings;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.company,
    required this.rating,
    required this.totalListings,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      company: json['company'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalListings: json['totalListings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'company': company,
      'rating': rating,
      'totalListings': totalListings,
    };
  }
}
