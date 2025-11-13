class CarRequirementModel {
  final int brandId;
  final int modelId;
  final int modelYear;
  final int capacity;
  final int categoryId;
  final int mileFee;
  final int hourlyFee;
  // Optional metadata parsed when available (e.g., job details API)
  final int? jobVehicleId;
  final String? brandName;
  final String? modelName;
  final String? categoryName;
  final DateTime? createdAt;

  CarRequirementModel({
    required this.brandId,
    required this.modelId,
    required this.modelYear,
    required this.capacity,
    required this.categoryId,
    required this.mileFee,
    required this.hourlyFee,
    this.jobVehicleId,
    this.brandName,
    this.modelName,
    this.categoryName,
    this.createdAt,
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
      jobVehicleId: json['job_vehicle_id'] as int?,
      brandName: json['brand_name'] as String?,
      modelName: json['model_name'] as String?,
      categoryName: json['category_name'] as String?,
      createdAt: json['vehicle_created_at'] == null
          ? null
          : DateTime.tryParse(json['vehicle_created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand_id': brandId,
      'model_id': modelId,
      'modelyear': modelYear,
      'capacity': capacity,
      'category_id': categoryId,
      'mile_fee': mileFee,
      'hourly_fee': hourlyFee,
      if (jobVehicleId != null) 'job_vehicle_id': jobVehicleId,
      if (brandName != null) 'brand_name': brandName,
      if (modelName != null) 'model_name': modelName,
      if (categoryName != null) 'category_name': categoryName,
      if (createdAt != null) 'vehicle_created_at': createdAt!.toIso8601String(),
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
    int? jobVehicleId,
    String? brandName,
    String? modelName,
    String? categoryName,
    DateTime? createdAt,
  }) {
    return CarRequirementModel(
      brandId: brandId ?? this.brandId,
      modelId: modelId ?? this.modelId,
      modelYear: modelYear ?? this.modelYear,
      capacity: capacity ?? this.capacity,
      categoryId: categoryId ?? this.categoryId,
      mileFee: mileFee ?? this.mileFee,
      hourlyFee: hourlyFee ?? this.hourlyFee,
      jobVehicleId: jobVehicleId ?? this.jobVehicleId,
      brandName: brandName ?? this.brandName,
      modelName: modelName ?? this.modelName,
      categoryName: categoryName ?? this.categoryName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
