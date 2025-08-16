import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

class VehicleRequirement {
  final String id; // Unique identifier for each requirement
  final String? specificBrand; // null = "Any brand"
  final String? specificModel; // null = "Any model"
  final String? specificVehicleType; // null = "Any type"

  final int? capacity; // null = "Any capacity"
  final int? year; // null = "Any year"
  final int?
  minimumCategory; // null = "Any category" - using integer ID from JSON

  final String? notes; // Additional notes about the requirement

  // Pricing for this specific vehicle requirement
  final double? hourlyRate;
  final double? pricePerMile;

  const VehicleRequirement({
    required this.id,
    this.specificBrand,
    this.specificModel,
    this.specificVehicleType,
    this.capacity,
    this.year,
    this.minimumCategory,

    this.notes,
    this.hourlyRate,
    this.pricePerMile,
  });

  /// Factory constructor for completely flexible requirements
  factory VehicleRequirement.anyVehicle() {
    return const VehicleRequirement(id: 'any_vehicle');
  }

  /// Factory constructor for specific requirements
  factory VehicleRequirement.specific({
    required String id,
    String? brand,
    String? model,
    String? vehicleType,

    int? capacity,
    int? year,
    int? minCategory,
    String? notes,
    double? hourlyRate,
    double? pricePerMile,
  }) {
    return VehicleRequirement(
      id: id,
      specificBrand: brand,
      specificModel: model,
      specificVehicleType: vehicleType,

      capacity: capacity,
      year: year,
      minimumCategory: minCategory,

      notes: notes,
      hourlyRate: hourlyRate,
      pricePerMile: pricePerMile,
    );
  }

  /// Check if a vehicle matches this requirement
  bool matchesVehicle(VehicleModel vehicle) {
    // Check capacity requirement
    if (capacity != null && vehicle.capacity < capacity!) {
      return false;
    }

    // Check category requirement
    if (minimumCategory != null) {
      // Convert integer category to VehicleCategory enum for comparison
      final category = VehicleCategory.fromId(minimumCategory!);
      if (!vehicle.canHandleJob(category)) {
        return false;
      }
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

    // Check year requirement
    if (year != null && vehicle.year < year!) {
      return false;
    }

    return true;
  }

  /// Get a human-readable description of this requirement
  String getDescription() {
    final parts = <String>[];

    if (specificBrand != null) {
      parts.add('Brand: $specificBrand');
    }
    if (specificModel != null) {
      parts.add('Model: $specificModel');
    }
    if (minimumCategory != null) {
      // Convert integer category to VehicleCategory enum for display
      final category = VehicleCategory.fromId(minimumCategory!);
      parts.add('Category: ${category.displayName}');
    }
    if (capacity != null) {
      parts.add('Capacity: $capacity+ people');
    }
    if (year != null) {
      parts.add('Year: $year+');
    }
    if (specificVehicleType != null) {
      parts.add('Type: $specificVehicleType');
    }

    if (parts.isEmpty) {
      return 'Any vehicle';
    }

    return parts.join(', ');
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

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specificBrand': specificBrand,
      'specificModel': specificModel,
      'specificVehicleType': specificVehicleType,

      'capacity': capacity,
      'year': year,
      'minimumCategory': minimumCategory,

      'notes': notes,
      'hourlyRate': hourlyRate,
      'pricePerMile': pricePerMile,
    };
  }

  /// Create from JSON
  factory VehicleRequirement.fromJson(Map<String, dynamic> json) {
    return VehicleRequirement(
      id: json['id'] ?? '',
      specificBrand: json['specificBrand'],
      specificModel: json['specificModel'],
      specificVehicleType: _migrateVehicleTypeFromJson(
        json['specificVehicleType'],
      ),

      capacity: json['capacity'],
      year: json['year'],
      minimumCategory: json['minimumCategory'],

      notes: json['notes'],
      hourlyRate: json['hourlyRate']?.toDouble(),
      pricePerMile: json['pricePerMile']?.toDouble(),
    );
  }

  /// Migrate old Turkish vehicle types to new English ones when loading from JSON
  static String? _migrateVehicleTypeFromJson(String? oldType) {
    if (oldType == null) return null;

    // Map old Turkish values to new English ones
    switch (oldType) {
      case 'Truck':
        return 'Truck';
      case 'Semi-Truck':
        return 'Semi-Truck';
      case 'Pickup Truck':
        return 'Pickup Truck';
      case 'Tractor':
        return 'Tractor';
      case 'Minibus':
        return 'Minibus';
      case 'Bus':
        return 'Bus';
      default:
        // If it's already in English or unknown, return as is
        return oldType;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleRequirement &&
        other.id == id &&
        other.specificBrand == specificBrand &&
        other.specificModel == specificModel &&
        other.specificVehicleType == specificVehicleType &&
        other.capacity == capacity &&
        other.year == year &&
        other.minimumCategory == minimumCategory &&

        other.hourlyRate == hourlyRate &&
        other.pricePerMile == pricePerMile;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        specificBrand.hashCode ^
        specificModel.hashCode ^
        specificVehicleType.hashCode ^
        capacity.hashCode ^
        year.hashCode ^
        minimumCategory.hashCode ^

        hourlyRate.hashCode ^
        pricePerMile.hashCode;
  }
}
