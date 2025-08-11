import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

class VehicleCategoryService {
  /// Check if a vehicle can apply to a job with specific requirements
  static bool canVehicleApplyToJob(VehicleModel vehicle, VehicleRequirement requirement) {
    if (requirement.minimumCategory == null) return true;
    return vehicle.category.canApplyToJob(requirement.minimumCategory!);
  }

  /// Check if a vehicle can apply to any requirement in a job
  static bool canVehicleApplyToJobRequirements(VehicleModel vehicle, List<VehicleRequirement> requirements) {
    for (final requirement in requirements) {
      if (canVehicleApplyToJob(vehicle, requirement)) {
        return true;
      }
    }
    return false;
  }

  /// Get all vehicles that can apply to a job
  static List<VehicleModel> getEligibleVehicles(
    List<VehicleModel> vehicles,
    List<VehicleRequirement> requirements,
  ) {
    return vehicles.where((vehicle) => 
      canVehicleApplyToJobRequirements(vehicle, requirements)
    ).toList();
  }

  /// Get vehicles that cannot apply to a job with upgrade suggestions
  static List<Map<String, dynamic>> getIneligibleVehiclesWithUpgradeInfo(
    List<VehicleModel> vehicles,
    List<VehicleRequirement> requirements,
  ) {
    final ineligibleVehicles = <Map<String, dynamic>>[];
    
    for (final vehicle in vehicles) {
      if (!canVehicleApplyToJobRequirements(vehicle, requirements)) {
        // Find the highest category requirement
        VehicleRequirement? highestRequirement;
        int? highestCategoryId;
        
        for (final requirement in requirements) {
          if (requirement.minimumCategory != null) {
            final categoryId = requirement.minimumCategory!.id;
            if (highestRequirement == null || categoryId > (highestCategoryId ?? 0)) {
              highestRequirement = requirement;
              highestCategoryId = categoryId;
            }
          }
        }
        
        if (highestRequirement != null) {
          final eligibility = vehicle.getJobEligibilitySummary(highestRequirement);
          ineligibleVehicles.add({
            'vehicle': vehicle,
            'eligibility': eligibility,
            'requirement': highestRequirement,
          });
        }
      }
    }
    
    return ineligibleVehicles;
  }

  /// Get upgrade recommendations for a vehicle to meet job requirements
  static Map<String, dynamic> getUpgradeRecommendations(
    VehicleModel vehicle,
    VehicleRequirement requirement,
  ) {
    if (requirement.minimumCategory == null) {
      return {
        'canUpgrade': false,
        'reason': 'No category requirement specified',
        'upgradePath': [],
        'estimatedCost': null,
        'recommendations': [],
      };
    }

    if (vehicle.category.canApplyToJob(requirement.minimumCategory!)) {
      return {
        'canUpgrade': false,
        'reason': 'Vehicle already meets requirement',
        'upgradePath': [],
        'estimatedCost': null,
        'recommendations': [],
      };
    }

    final upgradePath = vehicle.getUpgradePath(requirement.minimumCategory!);
    final estimatedCost = vehicle.getUpgradeCostEstimate(requirement.minimumCategory!);
    
    final recommendations = <String>[];
    
    if (upgradePath.isNotEmpty) {
      recommendations.add('Araç kategorisini ${upgradePath.first.displayName} seviyesine yükseltin');
      
      if (upgradePath.length > 1) {
        recommendations.add('Ardından ${upgradePath.last.displayName} seviyesine yükseltin');
      }
    }
    
    // Add specific recommendations based on vehicle type
    if (vehicle.vehicleType.toLowerCase().contains('sedan') && 
        requirement.minimumCategory!.id >= 8) {
      recommendations.add('Lüks sedan segmentine geçiş yapmayı düşünün');
    }
    
    if (vehicle.vehicleType.toLowerCase().contains('suv') && 
        requirement.minimumCategory!.id >= 7) {
      recommendations.add('Premium SUV segmentine geçiş yapmayı düşünün');
    }
    
    if (vehicle.year < 2018 && requirement.minimumCategory!.id >= 6) {
      recommendations.add('Daha yeni model araç almayı düşünün (2018+)');
    }

    return {
      'canUpgrade': upgradePath.isNotEmpty,
      'reason': 'Vehicle category too low for job requirement',
      'upgradePath': upgradePath,
      'estimatedCost': estimatedCost,
      'recommendations': recommendations,
      'requiredCategory': requirement.minimumCategory!.displayName,
      'currentCategory': vehicle.category.displayName,
    };
  }

  /// Validate if a vehicle registration meets category requirements
  static Map<String, dynamic> validateVehicleCategory(VehicleModel vehicle) {
    // Since _determineCategory is private, we'll create a simple validation
    // based on the vehicle's current category and general rules
    
    final currentCategory = vehicle.category;
    final suggestions = <String>[];
    bool isValid = true;
    
    // Add suggestions based on vehicle characteristics
    if (vehicle.year < 2015 && currentCategory.id >= 6) {
      suggestions.add('Araç yaşı kategori ile uyumsuz olabilir');
      isValid = false;
    }
    
    if (vehicle.capacity <= 4 && currentCategory.id >= 7) {
      suggestions.add('Kapasite kategori ile uyumsuz olabilir');
      isValid = false;
    }
    
    // Brand-based validation
    final luxuryBrands = ['Mercedes', 'BMW', 'Audi', 'Lexus', 'Porsche', 'Jaguar', 'Land Rover'];
    if (luxuryBrands.contains(vehicle.brand) && currentCategory.id < 7) {
      suggestions.add('Marka için daha yüksek kategori önerilir');
      isValid = false;
    }
    
    final validation = {
      'isValid': isValid,
      'currentCategory': currentCategory,
      'categoryLevel': currentCategory.levelDescription,
      'suggestions': suggestions,
    };
    
    if (!isValid) {
      validation['message'] = 'Kategori uyumluluğu kontrol edilmeli';
    }
    
    return validation;
  }

  /// Get category statistics for a list of vehicles
  static Map<String, dynamic> getCategoryStatistics(List<VehicleModel> vehicles) {
    final categoryCounts = <VehicleCategory, int>{};
    final totalVehicles = vehicles.length;
    
    for (final vehicle in vehicles) {
      categoryCounts[vehicle.category] = (categoryCounts[vehicle.category] ?? 0) + 1;
    }
    
    final statistics = <String, dynamic>{
      'totalVehicles': totalVehicles,
      'categoryDistribution': categoryCounts.map((key, value) => 
        MapEntry(key.displayName, value)
      ),
      'levelDistribution': <String, int>{},
      'averageCategoryId': 0.0,
    };
    
    // Calculate level distribution
    final levelCounts = <String, int>{};
    int totalCategoryId = 0;
    
    for (final vehicle in vehicles) {
      final level = vehicle.category.levelDescription;
      levelCounts[level] = (levelCounts[level] ?? 0) + 1;
      totalCategoryId += vehicle.category.id;
    }
    
    statistics['levelDistribution'] = levelCounts;
    statistics['averageCategoryId'] = totalVehicles > 0 ? totalCategoryId / totalVehicles : 0.0;
    
    return statistics;
  }
} 