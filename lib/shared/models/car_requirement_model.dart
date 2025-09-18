class CarRequirementModel {
  final int brandId;
  final int modelId;
  final int modelYear;
  final int capacity;
  final int categoryId;
  final int mileFee;
  final int hourlyFee;

  CarRequirementModel({
    required this.brandId,
    required this.modelId,
    required this.modelYear,
    required this.capacity,
    required this.categoryId,
    required this.mileFee,
    required this.hourlyFee,
  });

  factory CarRequirementModel.fromJson(Map<String, dynamic> json) {
    return CarRequirementModel(
      brandId: json['brand_id'] as int,
      modelId: json['model_id'] as int,
      modelYear: json['modelyear'] as int,
      capacity: json['capacity'] as int,
      categoryId: json['category_id'] as int,
      mileFee: json['mile_fee'] as int,
      hourlyFee: json['hourly_fee'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "brand_id": brandId,
      "model_id": modelId,
      "modelyear": modelYear,
      "capacity": capacity,
      "category_id": categoryId,
      "mile_fee": mileFee,
      "hourly_fee": hourlyFee,
    };
  }

  CarRequirementModel copyWith({
    int? brandId,
    int? modelId,
    int? modelYear,
    int? capacity,
    int? categoryId,
    int? mileFee,
    int? hourlyFee,
  }) {
    return CarRequirementModel(
      brandId: brandId ?? this.brandId,
      modelId: modelId ?? this.modelId,
      modelYear: modelYear ?? this.modelYear,
      capacity: capacity ?? this.capacity,
      categoryId: categoryId ?? this.categoryId,
      mileFee: mileFee ?? this.mileFee,
      hourlyFee: hourlyFee ?? this.hourlyFee,
    );
  }
}
