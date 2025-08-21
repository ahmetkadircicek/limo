import 'package:limo/core/enums/vehicle_category_enum.dart';

class VehicleModel {
  final String licencePlate;
  final String brand;
  final String model;
  final int year;
  final int capacity;
  final String vehicleType;
  final VehicleCategory category;
  final double? hourlyRate;
  final double? pricePerMile;
  final bool hasInsurance;
  final bool hasRegistration;
  final bool hasInspection;

  VehicleModel({
    required this.licencePlate,
    required this.brand,
    required this.model,
    required this.year,
    required this.capacity,
    required this.vehicleType,
    VehicleCategory? category,
    this.hourlyRate,
    this.pricePerMile,
    this.hasInsurance = false,
    this.hasRegistration = false,
    this.hasInspection = false,
  }) : category =
           category ?? _buildDetermineCategory(brand, model, year, capacity);

  /// Automatically determine vehicle category based on vehicle specifications
  static VehicleCategory _buildDetermineCategory(
    String brand,
    String model,
    int year,
    int capacity,
  ) {
    if (_buildIsPremiumBrand(brand)) {
      return _buildGetPremiumCategory(year, model, capacity);
    }

    if (_buildIsHighEndBrand(brand)) {
      return _buildGetHighEndCategory(year, model, capacity);
    }

    return _buildGetStandardCategory(year, model, capacity);
  }

  /// Check if brand is premium/luxury
  static bool _buildIsPremiumBrand(String brand) {
    return [
      'Mercedes',
      'BMW',
      'Audi',
      'Lexus',
      'Porsche',
      'Jaguar',
      'Land Rover',
    ].contains(brand);
  }

  /// Check if brand is high-end but not premium
  static bool _buildIsHighEndBrand(String brand) {
    return [
      'Volkswagen',
      'Toyota',
      'Honda',
      'Nissan',
      'Ford',
      'Chevrolet',
      'Hyundai',
      'Kia',
    ].contains(brand);
  }

  /// Get category for premium brands
  static VehicleCategory _buildGetPremiumCategory(
    int year,
    String model,
    int capacity,
  ) {
    if (year >= 2020) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.luxurySuv
          : VehicleCategory.luxurySedan;
    }
    if (year >= 2018) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.premiumSuv
          : VehicleCategory.premiumSedan;
    }
    if (year >= 2015) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.standardSuv
          : VehicleCategory.standardSedan;
    }
    return VehicleCategory.economySedan;
  }

  /// Get category for high-end brands
  static VehicleCategory _buildGetHighEndCategory(
    int year,
    String model,
    int capacity,
  ) {
    if (year >= 2020) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.premiumSuv
          : VehicleCategory.premiumSedan;
    }
    if (year >= 2018) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.standardSuv
          : VehicleCategory.standardSedan;
    }
    if (year >= 2015) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.economySuv
          : VehicleCategory.economySedan;
    }
    return VehicleCategory.economySedan;
  }

  /// Get category for standard brands
  static VehicleCategory _buildGetStandardCategory(
    int year,
    String model,
    int capacity,
  ) {
    if (year >= 2018) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.standardSuv
          : VehicleCategory.standardSedan;
    }
    if (year >= 2015) {
      return _buildIsSuvOrLarge(model, capacity)
          ? VehicleCategory.economySuv
          : VehicleCategory.economySedan;
    }
    return VehicleCategory.economySedan;
  }

  /// Check if vehicle is SUV or has large capacity
  static bool _buildIsSuvOrLarge(String model, int capacity) {
    return model.toLowerCase().contains('suv') || capacity > 5;
  }

  /// Create vehicle from JSON data
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      licencePlate: json['licence_plate'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      capacity: json['capacity'] as int,
      vehicleType: json['vehicle_type'] as String,
      category: VehicleCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => VehicleCategory.economySedan,
      ),
      hourlyRate: json['hourly_rate']?.toDouble(),
      pricePerMile: json['price_per_mile']?.toDouble(),
      hasInsurance: json['has_insurance'] as bool? ?? false,
      hasRegistration: json['has_registration'] as bool? ?? false,
      hasInspection: json['has_inspection'] as bool? ?? false,
    );
  }

  /// Convert vehicle to JSON
  Map<String, dynamic> toJson() {
    return {
      'licence_plate': licencePlate,
      'brand': brand,
      'model': model,
      'year': year,
      'capacity': capacity,
      'vehicle_type': vehicleType,
      'category': category.name,
      'hourly_rate': hourlyRate,
      'price_per_mile': pricePerMile,
      'has_insurance': hasInsurance,
      'has_registration': hasRegistration,
      'has_inspection': hasInspection,
    };
  }

  /// Create copy with updated values
  VehicleModel copyWith({
    String? licencePlate,
    String? brand,
    String? model,
    int? year,
    int? capacity,
    String? vehicleType,
    VehicleCategory? category,
    double? hourlyRate,
    double? pricePerMile,
    bool? hasInsurance,
    bool? hasRegistration,
    bool? hasInspection,
  }) {
    return VehicleModel(
      licencePlate: licencePlate ?? this.licencePlate,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      capacity: capacity ?? this.capacity,
      vehicleType: vehicleType ?? this.vehicleType,
      category: category ?? this.category,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      pricePerMile: pricePerMile ?? this.pricePerMile,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      hasRegistration: hasRegistration ?? this.hasRegistration,
      hasInspection: hasInspection ?? this.hasInspection,
    );
  }

  @override
  String toString() {
    return 'VehicleModel(licencePlate: $licencePlate, brand: $brand, model: $model, year: $year, capacity: $capacity, vehicleType: $vehicleType, category: $category, hourlyRate: $hourlyRate, pricePerMile: $pricePerMile, hasInsurance: $hasInsurance, hasRegistration: $hasRegistration, hasInspection: $hasInspection)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleModel && other.licencePlate == licencePlate;
  }

  @override
  int get hashCode => licencePlate.hashCode;
}
