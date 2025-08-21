import 'package:limo/core/enums/vehicle_category_enum.dart';

/// Model for vehicle requirements in jobs
class VehicleRequirement {
  final String id;
  final VehicleCategory category;
  final int count;
  final String? description;
  final Map<String, dynamic>? specifications;
  final VehicleCategory? minimumCategory;
  final String? specificBrand;
  final String? specificModel;
  final int? capacity;
  final int? year;
  final String? notes;
  final double? hourlyRate;
  final double? pricePerMile;

  const VehicleRequirement({
    required this.id,
    required this.category,
    required this.count,
    this.description,
    this.specifications,
    this.minimumCategory,
    this.specificBrand,
    this.specificModel,
    this.capacity,
    this.year,
    this.notes,
    this.hourlyRate,
    this.pricePerMile,
  });

  /// Create a default vehicle requirement for any vehicle
  factory VehicleRequirement.anyVehicle() {
    return const VehicleRequirement(
      id: 'any',
      category: VehicleCategory.standardSedan,
      count: 1,
      description: 'Any vehicle type accepted',
    );
  }

  /// Check if a vehicle matches this requirement
  bool matchesVehicle(dynamic vehicle) {
    // TODO: Implement vehicle matching logic
    // For now, return true for any vehicle
    return true;
  }

  /// Create a copy with updated values
  VehicleRequirement copyWith({
    String? id,
    VehicleCategory? category,
    int? count,
    String? description,
    Map<String, dynamic>? specifications,
    VehicleCategory? minimumCategory,
    String? specificBrand,
    String? specificModel,
    int? capacity,
    int? year,
    String? notes,
    double? hourlyRate,
    double? pricePerMile,
  }) {
    return VehicleRequirement(
      id: id ?? this.id,
      category: category ?? this.category,
      count: count ?? this.count,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      minimumCategory: minimumCategory ?? this.minimumCategory,
      specificBrand: specificBrand ?? this.specificBrand,
      specificModel: specificModel ?? this.specificModel,
      capacity: capacity ?? this.capacity,
      year: year ?? this.year,
      notes: notes ?? this.notes,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      pricePerMile: pricePerMile ?? this.pricePerMile,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'count': count,
      'description': description,
      'specifications': specifications,
      'minimum_category': minimumCategory?.name,
      'specific_brand': specificBrand,
      'specific_model': specificModel,
      'capacity': capacity,
      'year': year,
      'notes': notes,
      'hourly_rate': hourlyRate,
      'price_per_mile': pricePerMile,
    };
  }

  /// Create from JSON
  factory VehicleRequirement.fromJson(Map<String, dynamic> json) {
    return VehicleRequirement(
      id: json['id'] as String,
      category: VehicleCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => VehicleCategory.standardSedan,
      ),
      count: json['count'] as int,
      description: json['description'] as String?,
      specifications: json['specifications'] as Map<String, dynamic>?,
      minimumCategory:
          json['minimum_category'] != null
              ? VehicleCategory.values.firstWhere(
                (e) => e.name == json['minimum_category'],
                orElse: () => VehicleCategory.standardSedan,
              )
              : null,
      specificBrand: json['specific_brand'] as String?,
      specificModel: json['specific_model'] as String?,
      capacity: json['capacity'] as int?,
      year: json['year'] as int?,
      notes: json['notes'] as String?,
      hourlyRate: json['hourly_rate'] as double?,
      pricePerMile: json['price_per_mile'] as double?,
    );
  }

  @override
  String toString() {
    return 'VehicleRequirement(id: $id, category: $category, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleRequirement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
