import 'user.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> cuisines;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final bool isOpen;
  final bool isVegetarian;
  final bool isPureVeg;
  final Address address;
  final List<String> offers;
  final List<FoodCategory> menu;
  final double distance;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.cuisines,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isOpen,
    this.isVegetarian = false,
    this.isPureVeg = false,
    required this.address,
    this.offers = const [],
    this.menu = const [],
    this.distance = 0.0,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      cuisines: List<String>.from(json['cuisines'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      deliveryTime: json['delivery_time'] ?? '',
      deliveryFee: (json['delivery_fee'] ?? 0.0).toDouble(),
      minimumOrder: (json['minimum_order'] ?? 0.0).toDouble(),
      isOpen: json['is_open'] ?? false,
      isVegetarian: json['is_vegetarian'] ?? false,
      isPureVeg: json['is_pure_veg'] ?? false,
      address: Address.fromJson(json['address'] ?? {}),
      offers: List<String>.from(json['offers'] ?? []),
      menu: (json['menu'] as List<dynamic>?)
          ?.map((category) => FoodCategory.fromJson(category))
          .toList() ?? [],
      distance: (json['distance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'cuisines': cuisines,
      'rating': rating,
      'review_count': reviewCount,
      'delivery_time': deliveryTime,
      'delivery_fee': deliveryFee,
      'minimum_order': minimumOrder,
      'is_open': isOpen,
      'is_vegetarian': isVegetarian,
      'is_pure_veg': isPureVeg,
      'address': address.toJson(),
      'offers': offers,
      'menu': menu.map((category) => category.toJson()).toList(),
      'distance': distance,
    };
  }

  String get cuisineText => cuisines.join(', ');
  
  String get deliveryTimeText => deliveryTime;
  
  String get deliveryFeeText => deliveryFee == 0 ? 'Free Delivery' : '₹${deliveryFee.toStringAsFixed(0)} Delivery';

  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? cuisines,
    double? rating,
    int? reviewCount,
    String? deliveryTime,
    double? deliveryFee,
    double? minimumOrder,
    bool? isOpen,
    bool? isVegetarian,
    bool? isPureVeg,
    Address? address,
    List<String>? offers,
    List<FoodCategory>? menu,
    double? distance,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cuisines: cuisines ?? this.cuisines,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      isOpen: isOpen ?? this.isOpen,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isPureVeg: isPureVeg ?? this.isPureVeg,
      address: address ?? this.address,
      offers: offers ?? this.offers,
      menu: menu ?? this.menu,
      distance: distance ?? this.distance,
    );
  }
}

class FoodCategory {
  final String id;
  final String name;
  final String description;
  final List<Food> items;

  FoodCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => Food.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Food {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String category;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isSpicy;
  final bool isBestseller;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final List<Addon> addons;
  final bool isAvailable;
  final String? preparationTime;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.category,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isSpicy = false,
    this.isBestseller = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.addons = const [],
    this.isAvailable = true,
    this.preparationTime,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: json['original_price']?.toDouble(),
      category: json['category'] ?? '',
      isVegetarian: json['is_vegetarian'] ?? false,
      isVegan: json['is_vegan'] ?? false,
      isGlutenFree: json['is_gluten_free'] ?? false,
      isSpicy: json['is_spicy'] ?? false,
      isBestseller: json['is_bestseller'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      addons: (json['addons'] as List<dynamic>?)
          ?.map((addon) => Addon.fromJson(addon))
          .toList() ?? [],
      isAvailable: json['is_available'] ?? true,
      preparationTime: json['preparation_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'original_price': originalPrice,
      'category': category,
      'is_vegetarian': isVegetarian,
      'is_vegan': isVegan,
      'is_gluten_free': isGlutenFree,
      'is_spicy': isSpicy,
      'is_bestseller': isBestseller,
      'rating': rating,
      'review_count': reviewCount,
      'tags': tags,
      'addons': addons.map((addon) => addon.toJson()).toList(),
      'is_available': isAvailable,
      'preparation_time': preparationTime,
    };
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  String get priceText => '₹${price.toStringAsFixed(0)}';
  
  String get originalPriceText => originalPrice != null ? '₹${originalPrice!.toStringAsFixed(0)}' : '';

  Food copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    double? originalPrice,
    String? category,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isSpicy,
    bool? isBestseller,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    List<Addon>? addons,
    bool? isAvailable,
    String? preparationTime,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isSpicy: isSpicy ?? this.isSpicy,
      isBestseller: isBestseller ?? this.isBestseller,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      addons: addons ?? this.addons,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTime: preparationTime ?? this.preparationTime,
    );
  }
}

class Addon {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isRequired;
  final int maxSelection;
  final List<AddonOption> options;

  Addon({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.isRequired = false,
    this.maxSelection = 1,
    this.options = const [],
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      isRequired: json['is_required'] ?? false,
      maxSelection: json['max_selection'] ?? 1,
      options: (json['options'] as List<dynamic>?)
          ?.map((option) => AddonOption.fromJson(option))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'is_required': isRequired,
      'max_selection': maxSelection,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}

class AddonOption {
  final String id;
  final String name;
  final double price;
  final bool isDefault;

  AddonOption({
    required this.id,
    required this.name,
    required this.price,
    this.isDefault = false,
  });

  factory AddonOption.fromJson(Map<String, dynamic> json) {
    return AddonOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'is_default': isDefault,
    };
  }
}