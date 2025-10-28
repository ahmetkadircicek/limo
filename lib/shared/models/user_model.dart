import 'package:limo/shared/utils/date_time_formatter.dart';

/// User model for storing essential authentication and profile information
class UserModel {
  final String userId;
  final String provider;
  final String providerUserId;
  final String email;
  final String? phone;
  final String userName;
  final String? companyName;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? accessToken;
  final bool isActive;
  final String? userPhoto;
  final String? driverLicense;
  final bool approved;

  const UserModel({
    required this.userId,
    required this.provider,
    required this.providerUserId,
    required this.email,
    this.phone,
    required this.userName,
    this.companyName,
    required this.createdAt,
    required this.lastLogin,
    this.accessToken,
    this.isActive = true,
    this.userPhoto,
    this.driverLicense,
    this.approved = false,
  });

  /// Create user from Google authentication data
  factory UserModel.fromGoogleAuth({
    required String providerUserId,
    required String email,
    required String displayName,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return UserModel(
      userId: '',
      provider: 'google',
      providerUserId: providerUserId,
      email: email,
      userName: displayName,
      userPhoto: photoUrl, // Use Google profile photo as base64
      createdAt: now,
      lastLogin: now,
    );
  }

  /// Create user from Apple authentication data
  factory UserModel.fromAppleAuth({
    required String providerUserId,
    String? email,
    String? displayName,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return UserModel(
      userId: '',
      provider: 'apple',
      providerUserId: providerUserId,
      email: email ?? 'no-email@apple.com',
      userName: displayName ?? 'Apple User',
      userPhoto: photoUrl,
      createdAt: now,
      lastLogin: now,
    );
  }

  /// Create user from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      provider: json['provider'] as String,
      providerUserId: json['provider_user_id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      userName: json['user_name'] as String,
      companyName: json['company_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLogin: DateTime.parse(json['last_login'] as String),
      accessToken: json['access_token'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      userPhoto: json['user_photo'] as String?,
      driverLicense: json['driver_lisans'] as String?,
      approved: json['approved'] == 'true' || json['approved'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'provider': provider,
      'provider_user_id': providerUserId,
      'email': email,
      'phone': phone,
      'user_name': userName,
      'company_name': companyName,
      'created_at': DateTimeFormatter.formatApi(createdAt),
      'last_login': DateTimeFormatter.formatApi(lastLogin),
      'access_token': accessToken,
      'is_active': isActive,
      'user_photo': userPhoto,
      'driver_lisans': driverLicense,
      'approved': approved,
    };
  }

  UserModel copyWith({
    String? userId,
    String? provider,
    String? providerUserId,
    String? email,
    String? phone,
    String? userName,
    String? companyName,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? accessToken,
    bool? isActive,
    String? userPhoto,
    String? driverLicense,
    bool? approved,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      providerUserId: providerUserId ?? this.providerUserId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userName: userName ?? this.userName,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      accessToken: accessToken ?? this.accessToken,
      isActive: isActive ?? this.isActive,
      userPhoto: userPhoto ?? this.userPhoto,
      driverLicense: driverLicense ?? this.driverLicense,
      approved: approved ?? this.approved,
    );
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, provider: $provider, providerUserId: $providerUserId, email: $email, phone: $phone, userName: $userName, companyName: $companyName, accessToken: ${accessToken != null ? "***" : null}, isActive: $isActive, userPhoto: ${userPhoto != null ? "***" : null}, driverLicense: ${driverLicense != null ? "***" : null}, approved: $approved)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
