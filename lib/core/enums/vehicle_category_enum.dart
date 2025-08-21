import 'package:flutter/material.dart';

// TODO: Move hex color values to theme/design tokens for global use.

enum VehicleCategory {
  // Ultra Premium/Luxury Vehicles (ID: 10)
  ultraLuxury(
    10,
    'Ultra Luxury',
    'Top-tier luxury vehicles',
    Color(0xFFBFAEDE), // TODO: Replace with theme color
    Icons.diamond,
    'Ultra Premium',
  ),

  // Premium Luxury Vehicles (ID: 9)
  luxurySedan(
    9,
    'Luxury Sedan',
    'Premium luxury sedan vehicles',
    Color(0xFFD4AF37), // TODO: Replace with theme color
    Icons.star,
    'Luxury',
  ),
  luxurySuv(
    9,
    'Luxury SUV',
    'Premium luxury SUV vehicles',
    Color(0xFFD4AF37), // TODO: Replace with theme color
    Icons.terrain,
    'Luxury',
  ),

  // High-End Premium Vehicles (ID: 8)
  premiumSedan(
    8,
    'Premium Sedan',
    'High-quality sedan vehicles',
    Color(0xFFB0BEC5), // TODO: Replace with theme color
    Icons.directions_car,
    'Premium',
  ),
  premiumSuv(
    8,
    'Premium SUV',
    'High-quality SUV vehicles',
    Color(0xFFB0BEC5), // TODO: Replace with theme color
    Icons.airport_shuttle,
    'Premium',
  ),

  // Mid-Range Premium Vehicles (ID: 7)
  executiveSedan(
    7,
    'Executive Sedan',
    'Business-oriented sedan vehicles',
    Color(0xFF90A4AE), // TODO: Replace with theme color
    Icons.business,
    'Executive',
  ),
  executiveSuv(
    7,
    'Executive SUV',
    'Business-oriented SUV vehicles',
    Color(0xFF90A4AE), // TODO: Replace with theme color
    Icons.work,
    'Executive',
  ),

  // Standard Mid-Range Vehicles (ID: 6)
  standardSedan(
    6,
    'Standard Sedan',
    'Mid-range sedan vehicles',
    Color(0xFF78909C), // TODO: Replace with theme color
    Icons.directions_car,
    'Standard',
  ),
  standardSuv(
    6,
    'Standard SUV',
    'Mid-range SUV vehicles',
    Color(0xFF78909C), // TODO: Replace with theme color
    Icons.airport_shuttle,
    'Standard',
  ),

  // Economy Mid-Range Vehicles (ID: 5)
  economySedan(
    5,
    'Economy Sedan',
    'Economy sedan vehicles',
    Color(0xFF80CBC4), // TODO: Replace with theme color
    Icons.directions_car,
    'Economy',
  ),
  economySuv(
    5,
    'Economy SUV',
    'Economy SUV vehicles',
    Color(0xFF80CBC4), // TODO: Replace with theme color
    Icons.airport_shuttle,
    'Economy',
  ),

  // Compact Economy Vehicles (ID: 4)
  compactSedan(
    4,
    'Compact Sedan',
    'Compact sedan vehicles',
    Color(0xFFB2DFDB), // TODO: Replace with theme color
    Icons.directions_car,
    'Compact',
  ),
  compactSuv(
    4,
    'Compact SUV',
    'Compact SUV vehicles',
    Color(0xFFB2DFDB), // TODO: Replace with theme color
    Icons.airport_shuttle,
    'Compact',
  ),

  // Small Economy Vehicles (ID: 3)
  economyHatchback(
    3,
    'Economy Hatchback',
    'Economy hatchback vehicles',
    Color(0xFFB3E5FC), // TODO: Replace with theme color
    Icons.directions_car,
    'Small',
  ),
  compactHatchback(
    3,
    'Compact Hatchback',
    'Compact hatchback vehicles',
    Color(0xFFB3E5FC), // TODO: Replace with theme color
    Icons.directions_car,
    'Small',
  ),

  // Micro Vehicles (ID: 2)
  microCar(
    2,
    'Micro Car',
    'Micro vehicles',
    Color(0xFFE1F5FE), // TODO: Replace with theme color
    Icons.directions_car,
    'Micro',
  ),
  cityCar(
    2,
    'City Car',
    'Urban use vehicles',
    Color(0xFFE1F5FE), // TODO: Replace with theme color
    Icons.location_city,
    'City',
  ),

  // Utility/Basic Vehicles (ID: 1)
  utilityVehicle(
    1,
    'Utility Vehicle',
    'Basic utility vehicles',
    Color(0xFFCFD8DC), // TODO: Replace with theme color
    Icons.local_shipping,
    'Basic',
  );

  const VehicleCategory(
    this.id,
    this.displayName,
    this.description,
    this.color,
    this.icon,
    this.levelName,
  );

  final int id;
  final String displayName;
  final String description;
  final Color color;
  final IconData icon;
  final String levelName;

  /// Get category by ID
  static VehicleCategory fromId(int id) {
    return VehicleCategory.values.firstWhere(
      (category) => category.id == id,
      orElse: () => VehicleCategory.utilityVehicle,
    );
  }

  /// Check if this category can be upgraded to another category
  bool canUpgradeTo(VehicleCategory other) {
    return id >= other.id;
  }

  /// Check if this category can apply to a job requiring the specified category
  bool canApplyToJob(VehicleCategory requiredCategory) {
    return id >= requiredCategory.id;
  }

  /// Get all categories that this vehicle can upgrade to
  List<VehicleCategory> getUpgradeOptions() {
    return VehicleCategory.values
        .where((category) => category.id <= id)
        .toList();
  }

  /// Get all categories that this vehicle can apply to
  List<VehicleCategory> getApplicableJobCategories() {
    return VehicleCategory.values
        .where((category) => id >= category.id)
        .toList();
  }

  /// Get the next higher category level (if available)
  VehicleCategory? getNextUpgradeLevel() {
    final higherCategories =
        VehicleCategory.values.where((category) => category.id > id).toList();

    if (higherCategories.isEmpty) return null;

    // Return the closest higher category
    return higherCategories.reduce((a, b) => a.id < b.id ? a : b);
  }

  /// Get upgrade path to target category
  List<VehicleCategory> getUpgradePath(VehicleCategory targetCategory) {
    if (id >= targetCategory.id) return [];

    final path = <VehicleCategory>[];
    var currentCategory = this;

    while (currentCategory.id < targetCategory.id) {
      final nextLevel = currentCategory.getNextUpgradeLevel();
      if (nextLevel == null) break;

      path.add(nextLevel);
      currentCategory = nextLevel;
    }

    return path;
  }

  /// Check if upgrade to target category is possible
  bool canUpgradeToCategory(VehicleCategory targetCategory) {
    return id < targetCategory.id;
  }

  /// Get display name with ID
  String get displayNameWithId => '$displayName (ID: $id)';

  /// Get category level description
  String get levelDescription {
    if (id >= 10) return 'Ultra Premium Level';
    if (id >= 9) return 'Luxury Level';
    if (id >= 8) return 'Premium Level';
    if (id >= 7) return 'Executive Level';
    if (id >= 6) return 'Standard Level';
    if (id >= 5) return 'Economy Level';
    if (id >= 4) return 'Compact Level';
    if (id >= 3) return 'Small Level';
    if (id >= 2) return 'Micro Level';
    return 'Basic Level';
  }

  /// Get category tier (1-5 stars)
  int get tier {
    if (id >= 10) return 5;
    if (id >= 8) return 4;
    if (id >= 6) return 3;
    if (id >= 4) return 2;
    return 1;
  }

  /// Get category badge text
  String get badgeText {
    switch (tier) {
      case 5:
        return 'ULTRA';
      case 4:
        return 'PREMIUM';
      case 3:
        return 'STANDARD';
      case 2:
        return 'ECONOMY';
      case 1:
        return 'BASIC';
      default:
        return 'STANDARD';
    }
  }

  /// Get category color with opacity
  Color get colorWithOpacity => color.withOpacity(0.8);

  /// Get category light color
  Color get lightColor => color.withOpacity(0.1);

  /// Get category border color
  Color get borderColor => color.withOpacity(0.3);

  /// Get primary color for this category
  Color get primaryColor => color;

  /// Get light color for this category
  Color get lightColorV2 => color.withOpacity(0.15);

  /// Get accent color for this category
  Color get accentColor => color;

  /// Get background color for this category (very low opacity)
  Color get backgroundColor => color.withOpacity(0.05);

  /// Get medium background color for this category (medium opacity)
  Color get mediumBackgroundColor => color.withOpacity(0.15);

  /// Get strong background color for this category (high opacity)
  Color get strongBackgroundColor => color.withOpacity(0.25);

  /// Get border color for this category
  Color get borderColorV2 => color.withOpacity(0.3);

  /// Get text color for this category (ensuring good contrast)
  Color get textColor =>
      id >= 6 ? Colors.black87 : Colors.white; // TODO: Move to theme

  /// Get gradient colors for this category
  List<Color> get gradientColors => [
    color.withOpacity(0.9),
    color.withOpacity(0.6),
  ];

  /// Get upgrade cost estimate (placeholder for future implementation)
  double? getUpgradeCostEstimate() {
    // Upgrade cost calculation not implemented yet
    return null;
  }

  /// Get all categories by tier
  static List<VehicleCategory> getCategoriesByTier(int tier) {
    return VehicleCategory.values
        .where((category) => category.tier == tier)
        .toList();
  }

  /// Get all categories by level name
  static List<VehicleCategory> getCategoriesByLevel(String levelName) {
    return VehicleCategory.values
        .where((category) => category.levelName == levelName)
        .toList();
  }

  /// Get category statistics
  static Map<String, dynamic> getCategoryStats() {
    final stats = <String, dynamic>{};

    // Tier distribution
    final tierDistribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      tierDistribution[i] = getCategoriesByTier(i).length;
    }
    stats['tierDistribution'] = tierDistribution;

    // Level distribution
    final levelDistribution = <String, int>{};
    for (final category in VehicleCategory.values) {
      levelDistribution[category.levelName] =
          (levelDistribution[category.levelName] ?? 0) + 1;
    }
    stats['levelDistribution'] = levelDistribution;

    // Total categories
    stats['totalCategories'] = VehicleCategory.values.length;

    return stats;
  }
}
