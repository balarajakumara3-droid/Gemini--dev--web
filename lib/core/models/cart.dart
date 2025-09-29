import 'restaurant.dart';

class CartItem {
  final String id;
  final Food food;
  final int quantity;
  final List<AddonOption> selectedAddons;
  final String? specialInstructions;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.food,
    required this.quantity,
    this.selectedAddons = const [],
    this.specialInstructions,
    required this.addedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      food: Food.fromJson(json['food'] ?? {}),
      quantity: json['quantity'] ?? 1,
      selectedAddons: (json['selected_addons'] as List<dynamic>?)
          ?.map((addon) => AddonOption.fromJson(addon))
          .toList() ?? [],
      specialInstructions: json['special_instructions'],
      addedAt: DateTime.parse(json['added_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'quantity': quantity,
      'selected_addons': selectedAddons.map((addon) => addon.toJson()).toList(),
      'special_instructions': specialInstructions,
      'added_at': addedAt.toIso8601String(),
    };
  }

  double get totalPrice {
    double addonPrice = selectedAddons.fold(0.0, (sum, addon) => sum + addon.price);
    return (food.price + addonPrice) * quantity;
  }

  double get itemPrice => food.price + selectedAddons.fold(0.0, (sum, addon) => sum + addon.price);

  CartItem copyWith({
    String? id,
    Food? food,
    int? quantity,
    List<AddonOption>? selectedAddons,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Cart {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double taxes;
  final double discount;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.taxes,
    this.discount = 0.0,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.empty(String userId) {
    final now = DateTime.now();
    return Cart(
      id: '',
      userId: userId,
      restaurantId: '',
      restaurantName: '',
      items: [],
      subtotal: 0.0,
      deliveryFee: 0.0,
      taxes: 0.0,
      discount: 0.0,
      total: 0.0,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      restaurantName: json['restaurant_name'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ?? [],
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0.0).toDouble(),
      taxes: (json['taxes'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'taxes': taxes,
      'discount': discount,
      'total': total,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get calculatedSubtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get calculatedTaxes {
    return calculatedSubtotal * 0.05; // 5% tax
  }

  double get calculatedTotal {
    return calculatedSubtotal + deliveryFee + calculatedTaxes - discount;
  }

  Cart copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? taxes,
    double? discount,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxes: taxes ?? this.taxes,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}