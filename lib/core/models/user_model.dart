/// User model for storing authentication and profile information
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String? companyName;
  final bool hasDriverLicense;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.lastLoginAt,
    this.companyName,
    this.hasDriverLicense = false,
  });

  /// Create user from Google authentication data
  factory UserModel.fromGoogleAuth({
    required String id,
    required String email,
    required String displayName,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: now,
      lastLoginAt: now,
    );
  }

  /// Create user from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      companyName: json['companyName'] as String?,
      hasDriverLicense: json['hasDriverLicense'] as bool? ?? false,
    );
  }

  /// Convert user to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'companyName': companyName,
      'hasDriverLicense': hasDriverLicense,
    };
  }

  /// Create a copy of user with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? companyName,
    bool? hasDriverLicense,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      companyName: companyName ?? this.companyName,
      hasDriverLicense: hasDriverLicense ?? this.hasDriverLicense,
    );
  }

  /// Update last login time
  UserModel updateLastLogin() {
    return copyWith(lastLoginAt: DateTime.now());
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, photoUrl: $photoUrl, companyName: $companyName, hasDriverLicense: $hasDriverLicense)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
