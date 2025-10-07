enum PaymentMethodType {
  creditCard,
  debitCard,
  upi,
  netBanking,
  wallet,
  cashOnDelivery
}

class PaymentMethod {
  final String id;
  final String userId;
  final PaymentMethodType type;
  final String? provider; // e.g., "Visa", "Mastercard", "Paytm"
  final String? lastFourDigits; // For cards
  final String? upiId; // For UPI payments
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    this.provider,
    this.lastFourDigits,
    this.upiId,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      userId: json['user_id'],
      type: _parsePaymentMethodType(json['type']),
      provider: json['provider'],
      lastFourDigits: json['last_four_digits'],
      upiId: json['upi_id'],
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static PaymentMethodType _parsePaymentMethodType(String? type) {
    if (type == null) return PaymentMethodType.creditCard;
    
    switch (type.toLowerCase()) {
      case 'creditcard':
        return PaymentMethodType.creditCard;
      case 'debitcard':
        return PaymentMethodType.debitCard;
      case 'upi':
        return PaymentMethodType.upi;
      case 'netbanking':
        return PaymentMethodType.netBanking;
      case 'wallet':
        return PaymentMethodType.wallet;
      case 'cashondelivery':
        return PaymentMethodType.cashOnDelivery;
      default:
        return PaymentMethodType.creditCard;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.toString().split('.').last,
      'provider': provider,
      'last_four_digits': lastFourDigits,
      'upi_id': upiId,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}