// shared/models/car_model.dart
class CarModel {
  final int carsId;
  final String plateNumber;
  final int? brandId, modelId, categoryId, modelYear, capacity;
  final String? brandName, modelName, categoryName;

  CarModel({
    required this.carsId,
    required this.plateNumber,
    this.brandId,
    this.modelId,
    this.categoryId,
    this.modelYear,
    this.capacity,
    this.brandName,
    this.modelName,
    this.categoryName,
  });

  static int? _toInt(dynamic v) =>
      v == null ? null : (v is int ? v : int.tryParse(v.toString()));
  static String? _s(dynamic v) => v?.toString();

  factory CarModel.fromJson(Map<String, dynamic> j) {
    return CarModel(
      carsId: _toInt(j['cars_id'] ?? j['car_id'] ?? j['id']) ?? 0,
      plateNumber:
          _s(j['plate_number'] ?? j['platenumber'] ?? j['plate']) ?? '',
      brandId: _toInt(j['brand_id']),
      modelId: _toInt(j['model_id']),
      categoryId: _toInt(j['category_id']),
      modelYear: _toInt(j['model_year'] ?? j['modelyear']),
      capacity: _toInt(j['capacity']),
      brandName: _s(j['brand_name']),
      modelName: _s(j['model_name']),
      categoryName: _s(j['category_name']),
    );
  }
}
