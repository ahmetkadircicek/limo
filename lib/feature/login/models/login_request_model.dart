/// Model for login request payload
class LoginRequestModel {
  final String provider;
  final String providerUserId;
  final String email;
  final String userName;
  final bool isActive;

  const LoginRequestModel({
    required this.provider,
    required this.providerUserId,
    required this.email,
    required this.userName,
    this.isActive = true,
  });

  /// Create login request from Google authentication data
  factory LoginRequestModel.fromGoogleAuth({
    required String providerUserId,
    required String email,
    required String userName,
  }) {
    return LoginRequestModel(
      provider: 'google',
      providerUserId: providerUserId,
      email: email,
      userName: userName,
      isActive: true,
    );
  }

  /// Create login request from Apple authentication data
  factory LoginRequestModel.fromAppleAuth({
    required String providerUserId,
    required String email,
    required String userName,
  }) {
    return LoginRequestModel(
      provider: 'apple',
      providerUserId: providerUserId,
      email: email,
      userName: userName,
      isActive: true,
    );
  }

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'provider_user_id': providerUserId,
      'email': email,
      'user_name': userName,
      'is_active': isActive,
    };
  }

  /// Create a copy with updated fields
  LoginRequestModel copyWith({
    String? provider,
    String? providerUserId,
    String? email,
    String? userName,
    bool? isActive,
  }) {
    return LoginRequestModel(
      provider: provider ?? this.provider,
      providerUserId: providerUserId ?? this.providerUserId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'LoginRequestModel(provider: $provider, providerUserId: $providerUserId, email: $email, userName: $userName, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequestModel &&
        other.provider == provider &&
        other.providerUserId == providerUserId &&
        other.email == email &&
        other.userName == userName &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return provider.hashCode ^
        providerUserId.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        isActive.hashCode;
  }
}
