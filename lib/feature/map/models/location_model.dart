class LocationModel {
  final String placeName;
  final String address;
  final double latitude;
  final double longitude;
  final String placeId;

  const LocationModel({
    required this.placeName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.placeId,
  });

  /// Returns Waze-compatible navigation URL
  String get wazeUrl =>
      'https://waze.com/ul?ll=$latitude,$longitude&navigate=yes';

  /// Returns Google Maps navigation URL
  String get googleMapsUrl =>
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';

  /// Returns coordinates in Waze-compatible format
  String get wazeCoordinates => '$latitude,$longitude';

  @override
  String toString() {
    return 'LocationModel(placeName: $placeName, address: $address, lat: $latitude, lng: $longitude)';
  }

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      placeName: json['placeName'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      placeId: json['placeId'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.placeName == placeName &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.placeId == placeId;
  }

  @override
  int get hashCode {
    return placeName.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        placeId.hashCode;
  }
}
