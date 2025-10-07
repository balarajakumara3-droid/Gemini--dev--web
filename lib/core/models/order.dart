import 'cart.dart';
import 'restaurant.dart';
import 'user.dart';

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  readyForPickup,
  outForDelivery,
  delivered,
  cancelled,
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
}

enum PaymentMethod {
  cash,
  card,
  upi,
  wallet,
  netBanking,
}

class Order {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final Address deliveryAddress;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double taxes;
  final double discount;
  final double total;
  final String? couponCode;
  final String? specialInstructions;
  final DateTime orderTime;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final DeliveryPartner? deliveryPartner;
  final String? cancellationReason;
  final List<OrderStatusUpdate> statusUpdates;

  Order({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.deliveryAddress,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.taxes,
    this.discount = 0.0,
    required this.total,
    this.couponCode,
    this.specialInstructions,
    required this.orderTime,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.deliveryPartner,
    this.cancellationReason,
    this.statusUpdates = const [],
  });

  factory Order.fromCart(
    Cart cart,
    Address deliveryAddress,
    PaymentMethod paymentMethod, {
    String? couponCode,
    String? specialInstructions,
  }) {
    final now = DateTime.now();
    final orderId = 'ORDER_${now.millisecondsSinceEpoch}';
    
    return Order(
      id: orderId,
      userId: cart.userId,
      restaurantId: cart.restaurantId,
      restaurantName: cart.restaurantName,
      items: cart.items,
      deliveryAddress: deliveryAddress,
      status: OrderStatus.placed,
      paymentStatus: PaymentStatus.pending,
      paymentMethod: paymentMethod,
      subtotal: cart.calculatedSubtotal,
      deliveryFee: cart.deliveryFee,
      taxes: cart.calculatedTaxes,
      discount: cart.discount,
      total: cart.calculatedTotal,
      couponCode: couponCode,
      specialInstructions: specialInstructions,
      orderTime: now,
      estimatedDeliveryTime: now.add(const Duration(minutes: 45)),
      statusUpdates: [
        OrderStatusUpdate(
          status: OrderStatus.placed,
          timestamp: now,
          message: 'Order placed successfully',
        ),
      ],
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      restaurantName: json['restaurant_name'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ?? [],
      deliveryAddress: Address.fromJson(json['delivery_address'] ?? {}),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.placed,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (status) => status.name == json['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (method) => method.name == json['payment_method'],
        orElse: () => PaymentMethod.cash,
      ),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0.0).toDouble(),
      taxes: (json['taxes'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      couponCode: json['coupon_code'],
      specialInstructions: json['special_instructions'],
      orderTime: json['order_time'] != null ? DateTime.parse(json['order_time']) : DateTime.now(),
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'])
          : null,
      actualDeliveryTime: json['actual_delivery_time'] != null
          ? DateTime.parse(json['actual_delivery_time'])
          : null,
      deliveryPartner: json['delivery_partner'] != null
          ? DeliveryPartner.fromJson(json['delivery_partner'])
          : null,
      cancellationReason: json['cancellation_reason'],
      statusUpdates: (json['status_updates'] as List<dynamic>?)
          ?.map((update) => OrderStatusUpdate.fromJson(update))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'items': items.map((item) => item.toJson()).toList(),
      'delivery_address': deliveryAddress.toJson(),
      'status': status.name,
      'payment_status': paymentStatus.name,
      'payment_method': paymentMethod.name,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'taxes': taxes,
      'discount': discount,
      'total': total,
      'coupon_code': couponCode,
      'special_instructions': specialInstructions,
      'order_time': orderTime.toIso8601String(),
      'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
      'actual_delivery_time': actualDeliveryTime?.toIso8601String(),
      'delivery_partner': deliveryPartner?.toJson(),
      'cancellation_reason': cancellationReason,
      'status_updates': statusUpdates.map((update) => update.toJson()).toList(),
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Your Order';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get paymentStatusText {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Payment Pending';
      case PaymentStatus.processing:
        return 'Processing Payment';
      case PaymentStatus.completed:
        return 'Payment Completed';
      case PaymentStatus.failed:
        return 'Payment Failed';
      case PaymentStatus.refunded:
        return 'Payment Refunded';
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'Cash on Delivery';
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.wallet:
        return 'Digital Wallet';
      case PaymentMethod.netBanking:
        return 'Net Banking';
    }
  }

  bool get canBeCancelled {
    return status == OrderStatus.placed || status == OrderStatus.confirmed;
  }

  bool get isActive {
    return status != OrderStatus.delivered && status != OrderStatus.cancelled;
  }

  bool get isCompleted {
    return status == OrderStatus.delivered;
  }

  bool get isCancelled {
    return status == OrderStatus.cancelled;
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  Order copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    List<CartItem>? items,
    Address? deliveryAddress,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    double? subtotal,
    double? deliveryFee,
    double? taxes,
    double? discount,
    double? total,
    String? couponCode,
    String? specialInstructions,
    DateTime? orderTime,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    DeliveryPartner? deliveryPartner,
    String? cancellationReason,
    List<OrderStatusUpdate>? statusUpdates,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      taxes: taxes ?? this.taxes,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      couponCode: couponCode ?? this.couponCode,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      orderTime: orderTime ?? this.orderTime,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      deliveryPartner: deliveryPartner ?? this.deliveryPartner,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      statusUpdates: statusUpdates ?? this.statusUpdates,
    );
  }
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String message;
  final String? additionalInfo;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    required this.message,
    this.additionalInfo,
  });

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) {
    return OrderStatusUpdate(
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.placed,
      ),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      message: json['message'] ?? '',
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
      'additional_info': additionalInfo,
    };
  }
}

class DeliveryPartner {
  final String id;
  final String name;
  final String phoneNumber;
  final String? profileImage;
  final double rating;
  final String vehicleNumber;
  final double currentLatitude;
  final double currentLongitude;

  DeliveryPartner({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profileImage,
    required this.rating,
    required this.vehicleNumber,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  factory DeliveryPartner.fromJson(Map<String, dynamic> json) {
    return DeliveryPartner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profileImage: json['profile_image'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      vehicleNumber: json['vehicle_number'] ?? '',
      currentLatitude: (json['current_latitude'] ?? 0.0).toDouble(),
      currentLongitude: (json['current_longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'rating': rating,
      'vehicle_number': vehicleNumber,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
    };
  }
}