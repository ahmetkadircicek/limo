import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';

class VehicleModel {
  final String licencePlate;
  final String brand;
  final String model;
  final int year;
  final int capacity;
  final String vehicleType;
  final String interiorColor;
  final String exteriorColor;
  final VehicleCategory category;
  final double? hourlyRate;
  final double? pricePerMile;

  VehicleModel({
    required this.licencePlate,
    required this.brand,
    required this.model,
    required this.year,
    required this.capacity,
    required this.vehicleType,
    required this.interiorColor,
    required this.exteriorColor,
    VehicleCategory? category,
    this.hourlyRate,
    this.pricePerMile,
  }) : category = category ?? _determineCategory(brand, model, year, capacity);

  /// Automatically determine vehicle category based on vehicle specifications
  static VehicleCategory _determineCategory(
      String brand, String model, int year, int capacity) {
    // Premium brands with luxury categorization
    if (['Mercedes', 'BMW', 'Audi', 'Lexus', 'Porsche', 'Jaguar', 'Land Rover']
        .contains(brand)) {
      if (year >= 2020) {
        if (model.toLowerCase().contains('suv') || capacity > 5) {
          return VehicleCategory.luxurySuv;
        }
        return VehicleCategory.luxurySedan;
      }
      if (year >= 2018) {
        if (model.toLowerCase().contains('suv') || capacity > 5) {
          return VehicleCategory.premiumSuv;
        }
        return VehicleCategory.premiumSedan;
      }
      if (year >= 2015) {
        if (model.toLowerCase().contains('suv') || capacity > 5) {
          return VehicleCategory.standardSuv;
        }
        return VehicleCategory.standardSedan;
      }
      return VehicleCategory.economySedan;
    }

    // High-end brands with premium categorization
    if ([
      'Volkswagen',
      'Toyota',
      'Honda',
      'Nissan',
      'Ford',
      'Chevrolet',
      'Hyundai',
      'Kia'
    ].contains(brand)) {
      if (year >= 2020) {
        if (model.toLowerCase().contains('suv') || capacity > 5) {
          return VehicleCategory.premiumSuv;
        }
        return VehicleCategory.premiumSedan;
      }
      if (year >= 2018) {
        if (model.toLowerCase().contains('suv') || capacity > 5) {
          return VehicleCategory.standardSuv;
        }
        return VehicleCategory.standardSedan;
      }
      if (year >= 2015) {
        if (model.toLowerCase().contains('suv') || capacity > 5) {
          return VehicleCategory.economySuv;
        }
        return VehicleCategory.economySedan;
      }
      return VehicleCategory.economySedan;
    }

    // SUV/Crossover specific categorization
    if (model.toLowerCase().contains('suv') ||
        model.toLowerCase().contains('crossover') ||
        model.toLowerCase().contains('4x4') ||
        capacity > 5) {
      if (year >= 2020) return VehicleCategory.premiumSuv;
      if (year >= 2018) return VehicleCategory.standardSuv;
      if (year >= 2015) return VehicleCategory.economySuv;
      return VehicleCategory.economySuv;
    }

    // Hatchback categorization
    if (model.toLowerCase().contains('hatchback') ||
        model.toLowerCase().contains('hatch') ||
        capacity <= 4) {
      if (year >= 2020) return VehicleCategory.economySedan;
      if (year >= 2018) return VehicleCategory.economySedan;
      if (year >= 2015) return VehicleCategory.economyHatchback;
      return VehicleCategory.economyHatchback;
    }

    // Year-based categorization for other vehicles
    if (year >= 2020) return VehicleCategory.premiumSedan;
    if (year >= 2018) return VehicleCategory.standardSedan;
    if (year >= 2015) return VehicleCategory.economySedan;
    if (year >= 2010) return VehicleCategory.economySedan;

    return VehicleCategory.utilityVehicle;
  }

  /// Check if this vehicle can be used for a job requiring a specific category
  bool canHandleJob(VehicleCategory requiredCategory) {
    return category.canApplyToJob(requiredCategory);
  }

  /// Check if this vehicle can apply to a specific job requirement
  bool canApplyToJobRequirement(VehicleRequirement requirement) {
    if (requirement.minimumCategory == null) return true;
    return category.canApplyToJob(requirement.minimumCategory!);
  }

  /// Get upgrade options for this vehicle
  List<VehicleCategory> getUpgradeOptions() {
    return category.getUpgradeOptions();
  }

  /// Get the next upgrade level for this vehicle
  VehicleCategory? getNextUpgradeLevel() {
    return category.getNextUpgradeLevel();
  }

  /// Get upgrade path to target category
  List<VehicleCategory> getUpgradePath(VehicleCategory targetCategory) {
    return category.getUpgradePath(targetCategory);
  }

  /// Check if upgrade to target category is possible
  bool canUpgradeToCategory(VehicleCategory targetCategory) {
    return category.canUpgradeToCategory(targetCategory);
  }

  /// Get estimated upgrade cost to target category
  double? getUpgradeCostEstimate(VehicleCategory targetCategory) {
    if (!canUpgradeToCategory(targetCategory)) return null;

    // Placeholder for upgrade cost calculation
    // This could be implemented with actual upgrade cost logic
    final upgradePath = getUpgradePath(targetCategory);
    if (upgradePath.isEmpty) return null;

    // Simple cost estimation based on category difference
    final categoryDifference = targetCategory.id - category.id;
    return categoryDifference * 5000.0; // Placeholder: 5000 per category level
  }

  /// Get vehicle eligibility summary for a job
  Map<String, dynamic> getJobEligibilitySummary(
      VehicleRequirement requirement) {
    final isEligible = canApplyToJobRequirement(requirement);
    final requiredCategory = requirement.minimumCategory;

    if (requiredCategory == null) {
      return {
        'isEligible': true,
        'reason': 'No category requirement specified',
        'canUpgrade': false,
        'upgradePath': [],
        'estimatedCost': null,
      };
    }

    if (isEligible) {
      return {
        'isEligible': true,
        'reason': 'Vehicle category meets requirement',
        'canUpgrade': false,
        'upgradePath': [],
        'estimatedCost': null,
      };
    }

    final upgradePath = getUpgradePath(requiredCategory);
    final estimatedCost = getUpgradeCostEstimate(requiredCategory);

    return {
      'isEligible': false,
      'reason': 'Vehicle category too low for job requirement',
      'canUpgrade': upgradePath.isNotEmpty,
      'upgradePath': upgradePath,
      'estimatedCost': estimatedCost,
      'requiredCategory': requiredCategory.displayName,
      'currentCategory': category.displayName,
    };
  }

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
      'category': category.id,
      'hourlyRate': hourlyRate,
      'pricePerMile': pricePerMile,
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
      category: VehicleCategory.fromId(json['category'] ?? 1),
      hourlyRate: json['hourlyRate']?.toDouble(),
      pricePerMile: json['pricePerMile']?.toDouble(),
    );
  }
}
