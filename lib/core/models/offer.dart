class Offer {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? code;
  final double? discountPercentage;
  final double? maxDiscountAmount;
  final double? minOrderValue;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> applicableRestaurants; // IDs of restaurants where this offer applies
  final bool isActive;
  final String? imageUrl;

  Offer({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.code,
    this.discountPercentage,
    this.maxDiscountAmount,
    this.minOrderValue,
    required this.startDate,
    required this.endDate,
    required this.applicableRestaurants,
    this.isActive = true,
    this.imageUrl,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      code: json['code'],
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      maxDiscountAmount: (json['max_discount_amount'] as num?)?.toDouble(),
      minOrderValue: (json['min_order_value'] as num?)?.toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      applicableRestaurants: List<String>.from(json['applicable_restaurants'] ?? []),
      isActive: json['is_active'] ?? true,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'code': code,
      'discount_percentage': discountPercentage,
      'max_discount_amount': maxDiscountAmount,
      'min_order_value': minOrderValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'applicable_restaurants': applicableRestaurants,
      'is_active': isActive,
      'image_url': imageUrl,
    };
  }
}