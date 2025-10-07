class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final DateTime createdAt;
  final bool isVerified;
  final List<String> preferences;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.createdAt,
    this.isVerified = false,
    this.preferences = const [],
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
      preferences: List<String>.from(json['preferences'] ?? []),
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'preferences': preferences,
      'bio': bio,
    };
  }
}
