/// Unified authentication result for all providers
class AuthResult {
  final String providerUserId; // Provider'dan gelen ID (Google ID, Apple ID)
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String provider;
  final String? rawNonce;
  final String? accessToken;
  final String? idToken;
  final Map<String, dynamic>? additionalData;

  const AuthResult({
    required this.providerUserId, // Provider'dan gelen ID
    this.email,
    this.displayName,
    this.photoUrl,
    required this.provider,
    this.rawNonce,
    this.accessToken,
    this.idToken,
    this.additionalData,
  });

  /// Copy with new values
  AuthResult copyWith({
    String? providerUserId,
    String? email,
    String? displayName,
    String? photoUrl,
    String? provider,
    String? rawNonce,
    String? accessToken,
    String? idToken,
    Map<String, dynamic>? additionalData,
  }) {
    return AuthResult(
      providerUserId: providerUserId ?? this.providerUserId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      provider: provider ?? this.provider,
      rawNonce: rawNonce ?? this.rawNonce,
      accessToken: accessToken ?? this.accessToken,
      idToken: idToken ?? this.idToken,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  String toString() {
    return 'AuthResult(providerUserId: $providerUserId, email: $email, displayName: $displayName, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResult &&
        other.providerUserId == providerUserId &&
        other.provider == provider;
  }

  @override
  int get hashCode => providerUserId.hashCode ^ provider.hashCode;
}
