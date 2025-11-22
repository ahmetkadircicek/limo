import 'package:flutter/foundation.dart'; // @immutable annotation için

@immutable
class LocationModel {
  final double? lat;
  final double? lng;
  final String? address;
  final String? placeId; // İleride Google Place ID gerekirse diye opsiyonel

  const LocationModel({
    this.lat,
    this.lng,
    this.address,
    this.placeId,
  });

  bool get hasCoordinates => lat != null && lng != null;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      // API'den bazen int bazen double gelebilir, 'num' ile cast edip toDouble demek güvenlidir.
      lat: (json['lat'] as num?)?.toDouble() ?? (json['latitude'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble() ?? (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String? ?? json['formatted_address'] as String?,
      placeId: json['place_id'] as String?,
    );
  }

  /// Modeli JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
      if (placeId != null) 'place_id': placeId,
    };
  }

  /// Boş bir model döndürmek için factory (Null check'lerden kaçınmak istenirse)
  factory LocationModel.empty() {
    return const LocationModel();
  }

  /// Kopyalama işlemi için (State update'lerinde işe yarar)
  LocationModel copyWith({
    double? lat,
    double? lng,
    String? address,
    String? placeId,
  }) {
    return LocationModel(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
    );
  }
}