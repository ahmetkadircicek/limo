import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

class VehicleRequirement {
  final String? specificBrand; // null = "Any brand"
  final String? specificModel; // null = "Any model"
  final String? specificVehicleType; // null = "Any type"
  final String? specificExteriorColor; // null = "Any color"
  final String? specificInteriorColor; // null = "Any interior color"
  final int? minimumCapacity; // null = "Any capacity"
  final int? maximumCapacity; // null = "No max limit"
  final int? minimumYear; // null = "Any year"
  final int? maximumYear; // null = "No max year"
  final VehicleCategory? minimumCategory; // null = "Any category"
  final bool isFlexible; // Overall flexibility flag
  
  // Pricing for this specific vehicle requirement
  final double? hourlyRate;
  final double? pricePerMile;

  const VehicleRequirement({
    this.specificBrand,
    this.specificModel,
    this.specificVehicleType,
    this.specificExteriorColor,
    this.specificInteriorColor,
    this.minimumCapacity,
    this.maximumCapacity,
    this.minimumYear,
    this.maximumYear,
    this.minimumCategory,
    this.isFlexible = true,
    this.hourlyRate,
    this.pricePerMile,
  });

  /// Factory constructor for completely flexible requirements
  factory VehicleRequirement.anyVehicle() {
    return const VehicleRequirement(
      isFlexible: true,
    );
  }

  /// Factory constructor for specific requirements
  factory VehicleRequirement.specific({
    String? brand,
    String? model,
    String? vehicleType,
    String? exteriorColor,
    String? interiorColor,
    int? minCapacity,
    int? maxCapacity,
    int? minYear,
    int? maxYear,
    VehicleCategory? minCategory,
    double? hourlyRate,
    double? pricePerMile,
  }) {
    return VehicleRequirement(
      specificBrand: brand,
      specificModel: model,
      specificVehicleType: vehicleType,
      specificExteriorColor: exteriorColor,
      specificInteriorColor: interiorColor,
      minimumCapacity: minCapacity,
      maximumCapacity: maxCapacity,
      minimumYear: minYear,
      maximumYear: maxYear,
      minimumCategory: minCategory,
      isFlexible: false,
      hourlyRate: hourlyRate,
      pricePerMile: pricePerMile,
    );
  }

  /// Check if a vehicle matches this requirement
  bool matchesVehicle(VehicleModel vehicle) {
    // If completely flexible, any vehicle matches
    if (isFlexible &&
        specificBrand == null &&
        specificModel == null &&
        specificVehicleType == null &&
        specificExteriorColor == null &&
        specificInteriorColor == null &&
        minimumCapacity == null &&
        maximumCapacity == null &&
        minimumCategory == null) {
      return true;
    }

    // Check brand requirement
    if (specificBrand != null && vehicle.brand != specificBrand) {
      return false;
    }

    // Check model requirement
    if (specificModel != null && vehicle.model != specificModel) {
      return false;
    }

    // Check vehicle type requirement
    if (specificVehicleType != null &&
        vehicle.vehicleType != specificVehicleType) {
      return false;
    }

    // Check exterior color requirement
    if (specificExteriorColor != null &&
        vehicle.exteriorColor != specificExteriorColor) {
      return false;
    }

    // Check interior color requirement
    if (specificInteriorColor != null &&
        vehicle.interiorColor != specificInteriorColor) {
      return false;
    }

    // Check minimum capacity requirement
    if (minimumCapacity != null && vehicle.capacity < minimumCapacity!) {
      return false;
    }

    // Check maximum capacity requirement
    if (maximumCapacity != null && vehicle.capacity > maximumCapacity!) {
      return false;
    }

    // Check minimum year requirement
    if (minimumYear != null && vehicle.year < minimumYear!) {
      return false;
    }

    // Check maximum year requirement
    if (maximumYear != null && vehicle.year > maximumYear!) {
      return false;
    }

    // Check minimum category requirement
    if (minimumCategory != null && !vehicle.canHandleJob(minimumCategory!)) {
      return false;
    }

    return true;
  }

  /// Get human-readable description of requirements
  String getDescription() {
    if (isFlexible &&
        specificBrand == null &&
        specificModel == null &&
        specificVehicleType == null &&
        specificExteriorColor == null &&
        minimumCapacity == null &&
        minimumCategory == null) {
      return "Any vehicle accepted";
    }

    List<String> requirements = [];

    if (specificBrand != null) requirements.add("Brand: $specificBrand");
    if (specificModel != null) requirements.add("Model: $specificModel");
    if (specificVehicleType != null)
      requirements.add("Type: $specificVehicleType");
    if (specificExteriorColor != null)
      requirements.add("Color: $specificExteriorColor");
    if (minimumCapacity != null) {
      if (maximumCapacity != null) {
        requirements.add("Capacity: $minimumCapacity-$maximumCapacity persons");
      } else {
        requirements.add("Min Capacity: $minimumCapacity+ persons");
      }
    }
    if (minimumYear != null) {
      if (maximumYear != null) {
        requirements.add("Year: $minimumYear-$maximumYear");
      } else {
        requirements.add("Min Year: $minimumYear+");
      }
    }
    if (minimumCategory != null) {
      requirements.add("Min Category: ${minimumCategory!.displayName}");
    }

    if (requirements.isEmpty) {
      requirements.add("Flexible requirements");
    }

    return requirements.join(", ");
  }

  /// Get pricing summary for this vehicle requirement
  String getPricingSummary() {
    List<String> pricing = [];
    
    if (hourlyRate != null) {
      pricing.add('\$${hourlyRate!.toStringAsFixed(2)}/hour');
    }
    if (pricePerMile != null) {
      pricing.add('\$${pricePerMile!.toStringAsFixed(2)}/mile');
    }
    
    if (pricing.isEmpty) return 'No pricing specified';
    return pricing.join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'specificBrand': specificBrand,
      'specificModel': specificModel,
      'specificVehicleType': specificVehicleType,
      'specificExteriorColor': specificExteriorColor,
      'specificInteriorColor': specificInteriorColor,
      'minimumCapacity': minimumCapacity,
      'maximumCapacity': maximumCapacity,
      'minimumYear': minimumYear,
      'maximumYear': maximumYear,
      'minimumCategory': minimumCategory?.id,
      'isFlexible': isFlexible,
      'hourlyRate': hourlyRate,
      'pricePerMile': pricePerMile,
    };
  }

  factory VehicleRequirement.fromJson(Map<String, dynamic> json) {
    return VehicleRequirement(
      specificBrand: json['specificBrand'],
      specificModel: json['specificModel'],
      specificVehicleType: json['specificVehicleType'],
      specificExteriorColor: json['specificExteriorColor'],
      specificInteriorColor: json['specificInteriorColor'],
      minimumCapacity: json['minimumCapacity'],
      maximumCapacity: json['maximumCapacity'],
      minimumYear: json['minimumYear'],
      maximumYear: json['maximumYear'],
      minimumCategory: json['minimumCategory'] != null 
          ? VehicleCategory.fromId(json['minimumCategory'])
          : null,
      isFlexible: json['isFlexible'] ?? true,
      hourlyRate: json['hourlyRate']?.toDouble(),
      pricePerMile: json['pricePerMile']?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleRequirement &&
        other.specificBrand == specificBrand &&
        other.specificModel == specificModel &&
        other.specificVehicleType == specificVehicleType &&
        other.specificExteriorColor == specificExteriorColor &&
        other.specificInteriorColor == specificInteriorColor &&
        other.minimumCapacity == minimumCapacity &&
        other.maximumCapacity == maximumCapacity &&
        other.minimumYear == minimumYear &&
        other.maximumYear == maximumYear &&
        other.minimumCategory == minimumCategory &&
        other.isFlexible == isFlexible &&
        other.hourlyRate == hourlyRate &&
        other.pricePerMile == pricePerMile;
  }

  @override
  int get hashCode {
    return specificBrand.hashCode ^
        specificModel.hashCode ^
        specificVehicleType.hashCode ^
        specificExteriorColor.hashCode ^
        specificInteriorColor.hashCode ^
        minimumCapacity.hashCode ^
        maximumCapacity.hashCode ^
        minimumYear.hashCode ^
        maximumYear.hashCode ^
        minimumCategory.hashCode ^
        isFlexible.hashCode ^
        hourlyRate.hashCode ^
        pricePerMile.hashCode;
  }
}
