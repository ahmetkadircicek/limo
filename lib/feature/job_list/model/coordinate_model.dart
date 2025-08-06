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
