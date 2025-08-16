class LocationData {
  final String placeName;
  final String address;
  final double latitude;
  final double longitude;
  final String placeId;

  const LocationData({
    required this.placeName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.placeId,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      placeName: json['placeName'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      placeId: json['placeId'] ?? '',
    );
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

  /// Convert to Coordinate for backward compatibility
  Coordinate toCoordinate() {
    return Coordinate(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData &&
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

/// Backward compatibility Coordinate class
class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
