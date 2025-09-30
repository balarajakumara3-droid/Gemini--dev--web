import 'address.dart';
import 'payment_method.dart';

class Profile {
  final String id;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? bio;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.userId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.bio,
    this.avatarUrl,
    this.dateOfBirth,
    required this.addresses,
    required this.paymentMethods,
    this.emailVerified = false,
    this.phoneVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      dateOfBirth: json['date_of_birth'] != null 
        ? DateTime.parse(json['date_of_birth']) 
        : null,
      addresses: (json['addresses'] as List?)
        ?.map((addr) => Address.fromJson(addr))
        .toList() ?? [],
      paymentMethods: (json['payment_methods'] as List?)
        ?.map((pm) => PaymentMethod.fromJson(pm))
        .toList() ?? [],
      emailVerified: json['email_verified'] ?? false,
      phoneVerified: json['phone_verified'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'bio': bio,
      'avatar_url': avatarUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'addresses': addresses.map((addr) => addr.toJson()).toList(),
      'payment_methods': paymentMethods.map((pm) => pm.toJson()).toList(),
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}