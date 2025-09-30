class MenuItem {
  final String id;
  final String restaurantId;
  final String? categoryId; // Optional, can be null if not categorized
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;
  final List<String> tags; // e.g., "vegetarian", "spicy", "gluten-free"
  final int preparationTimeMinutes; // Estimated preparation time

  MenuItem({
    required this.id,
    required this.restaurantId,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
    this.tags = const [],
    this.preparationTimeMinutes = 15,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
      preparationTimeMinutes: json['preparation_time_minutes'] ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'tags': tags,
      'preparation_time_minutes': preparationTimeMinutes,
    };
  }
}