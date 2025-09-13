class OAuthModel {
  String? id;
  String? provider;
  String? email;
  String? displayName;
  String? photoUrl;
  String? isActive;

  OAuthModel({
    this.id,
    this.provider,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isActive,
  });

  OAuthModel.fromJson(Map<String, dynamic> json) {
    id = json['provider_user_id'];
    provider = json['provider'];
    email = json['email'];
    displayName = json['user_name'];
    photoUrl = json['user_photo'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider_user_id'] = id;
    data['provider'] = provider;
    data['email'] = email;
    data['user_name'] = displayName;
    data['user_photo'] = photoUrl;
    data['is_active'] = isActive;
    return data;
  }
}
