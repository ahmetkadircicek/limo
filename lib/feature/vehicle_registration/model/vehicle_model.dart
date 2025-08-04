class VehicleModel {
  final String licencePlate;
  final String brand;
  final String model;
  final int year;
  final int capacity;
  final String vehicleType;
  final String interiorColor;
  final String exteriorColor;

  VehicleModel({
    required this.licencePlate,
    required this.brand,
    required this.model,
    required this.year,
    required this.capacity,
    required this.vehicleType,
    required this.interiorColor,
    required this.exteriorColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'licencePlate': licencePlate,
      'brand': brand,
      'model': model,
      'year': year,
      'capacity': capacity,
      'vehicleType': vehicleType,
      'interiorColor': interiorColor,
      'exteriorColor': exteriorColor,
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      licencePlate: json['licencePlate'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      capacity: json['capacity'] ?? 0,
      vehicleType: json['vehicleType'] ?? '',
      interiorColor: json['interiorColor'] ?? '',
      exteriorColor: json['exteriorColor'] ?? '',
    );
  }
}
