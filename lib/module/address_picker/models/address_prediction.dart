class AddressPrediction {
  const AddressPrediction({required this.placeId, required this.description});

  final String placeId;
  final String description;

  static AddressPrediction fromMap(Map<String, dynamic> map) {
    final placeId = map['place_id'] as String? ?? '';
    final description = map['description'] as String? ?? '';
    return AddressPrediction(placeId: placeId, description: description);
  }
}
