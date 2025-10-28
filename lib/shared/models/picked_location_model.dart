class PickedLocation {
  final double? lat;
  final double? lng;
  final String address;
  final String? placeId;

  const PickedLocation({
    this.lat,
    this.lng,
    required this.address,
    this.placeId,
  });
}
