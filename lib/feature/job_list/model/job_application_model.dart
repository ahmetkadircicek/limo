import 'dart:math' as math;

import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

/// Job Application Model - Separate application for each vehicle requirement
class JobApplication {
  final String id;
  final String jobId;
  final String vehicleRequirementId; // Which vehicle requirement is being applied for
  final String driverId;
  final String driverName;
  final String driverEmail;
  final String driverPhone;
  final VehicleModel appliedVehicle;
  final DateTime applicationDate;
  final ApplicationStatus status;
  final String? notes;
  final String? rejectionReason;

  // Pricing information
  final double? proposedHourlyRate; // Hourly rate
  final double? proposedPricePerMile; // Price per mile
  final double? totalProposedPrice; // Total proposed price

  // Vehicle compatibility check
  final bool vehicleMeetsRequirements;
  final String? vehicleCompatibilityNotes;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.vehicleRequirementId,
    required this.driverId,
    required this.driverName,
    required this.driverEmail,
    required this.driverPhone,
    required this.appliedVehicle,
    required this.applicationDate,
    this.status = ApplicationStatus.pending,
    this.notes,
    this.rejectionReason,
    this.proposedHourlyRate,
    this.proposedPricePerMile,
    this.totalProposedPrice,
    this.vehicleMeetsRequirements = false,
    this.vehicleCompatibilityNotes,
  });

  /// Check if this application meets the specific vehicle requirement
  bool meetsVehicleRequirement(VehicleRequirement requirement) {
    return requirement.matchesVehicle(appliedVehicle);
  }

  /// Calculate the total proposed price based on job type and requirements
  double calculateTotalProposedPrice(
    JobModel job,
    VehicleRequirement requirement,
  ) {
    // Use if already calculated
    if (totalProposedPrice != null) {
      return totalProposedPrice!;
    }

    double totalPrice = 0.0;

    if (job.jobType == JobType.hourly) {
      // For hourly jobs
      if (proposedHourlyRate != null) {
        totalPrice = proposedHourlyRate!;
      } else if (requirement.hourlyRate != null) {
        totalPrice = requirement.hourlyRate!;
      }
    } else if (job.jobType == JobType.pointToPoint) {
      // For point-to-point jobs
      if (proposedPricePerMile != null &&
          job.toLocation != null &&
          job.fromLocation != null) {
        final distance = _calculateDistance(
          job.fromLocation!.latitude,
          job.fromLocation!.longitude,
          job.toLocation!.latitude,
          job.toLocation!.longitude,
        );
        totalPrice = distance * proposedPricePerMile!;
      } else if (requirement.pricePerMile != null &&
          job.toLocation != null &&
          job.fromLocation != null) {
        final distance = _calculateDistance(
          job.fromLocation!.latitude,
          job.fromLocation!.longitude,
          job.toLocation!.latitude,
          job.toLocation!.longitude,
        );
        totalPrice = distance * requirement.pricePerMile!;
      }
    }

    return totalPrice;
  }

  /// Get pricing summary for this application
  String getPricingSummary(JobModel job, VehicleRequirement requirement) {
    final totalPrice = calculateTotalProposedPrice(job, requirement);

    List<String> pricing = [];

    if (proposedHourlyRate != null) {
      pricing.add('Hourly: \$${proposedHourlyRate!.toStringAsFixed(2)}');
    } else if (requirement.hourlyRate != null) {
      pricing.add('Hourly: \$${requirement.hourlyRate!.toStringAsFixed(2)}');
    }

    if (proposedPricePerMile != null) {
      pricing.add('Per Mile: \$${proposedPricePerMile!.toStringAsFixed(2)}');
    } else if (requirement.pricePerMile != null) {
      pricing.add('Per Mile: \$${requirement.pricePerMile!.toStringAsFixed(2)}');
    }

    if (totalPrice > 0) {
      pricing.add('Total: \$${totalPrice.toStringAsFixed(2)}');
    }

    if (pricing.isEmpty) return 'Price not specified';
    return pricing.join(', ');
  }

  /// Check if driver has higher hierarchy vehicle for this requirement
  bool hasHigherHierarchyVehicle(VehicleRequirement requirement) {
    if (requirement.minimumCategory == null) return true;

    // Araç kategorisini kontrol et - int'i VehicleCategory'ye çevir
    final category = VehicleCategory.fromId(requirement.minimumCategory!);
    return appliedVehicle.canHandleJob(category);
  }

  /// Get application priority score (higher is better)
  double getPriorityScore(VehicleRequirement requirement) {
    double score = 0.0;

    // Araç uygunluğu
    if (vehicleMeetsRequirements) score += 10.0;

    // Kategori uygunluğu
    if (requirement.minimumCategory != null) {
      final vehicleCategory = appliedVehicle.getHighestCategory();
      score +=
          vehicleCategory.id * 2.0; // Daha yüksek kategori = daha yüksek puan
    }

    // Fiyat uygunluğu (daha düşük fiyat = daha yüksek puan)
    if (totalProposedPrice != null && totalProposedPrice! > 0) {
      score += 100.0 / totalProposedPrice!; // Ters orantı
    }

    return score;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 3959; // miles
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'vehicleRequirementId': vehicleRequirementId,
      'driverId': driverId,
      'driverName': driverName,
      'driverEmail': driverEmail,
      'driverPhone': driverPhone,
      'appliedVehicle': appliedVehicle.toJson(),
      'applicationDate': applicationDate.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'rejectionReason': rejectionReason,
      'proposedHourlyRate': proposedHourlyRate,
      'proposedPricePerMile': proposedPricePerMile,
      'totalProposedPrice': totalProposedPrice,
      'vehicleMeetsRequirements': vehicleMeetsRequirements,
      'vehicleCompatibilityNotes': vehicleCompatibilityNotes,
    };
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      vehicleRequirementId: json['vehicleRequirementId'] ?? '',
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'] ?? '',
      driverEmail: json['driverEmail'] ?? '',
      driverPhone: json['driverPhone'] ?? '',
      appliedVehicle: VehicleModel.fromJson(json['appliedVehicle']),
      applicationDate: DateTime.parse(json['applicationDate']),
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      notes: json['notes'],
      rejectionReason: json['rejectionReason'],
      proposedHourlyRate: json['proposedHourlyRate']?.toDouble(),
      proposedPricePerMile: json['proposedPricePerMile']?.toDouble(),
      totalProposedPrice: json['totalProposedPrice']?.toDouble(),
      vehicleMeetsRequirements: json['vehicleMeetsRequirements'] ?? false,
      vehicleCompatibilityNotes: json['vehicleCompatibilityNotes'],
    );
  }

  JobApplication copyWith({
    String? id,
    String? jobId,
    String? vehicleRequirementId,
    String? driverId,
    String? driverName,
    String? driverEmail,
    String? driverPhone,
    VehicleModel? appliedVehicle,
    DateTime? applicationDate,
    ApplicationStatus? status,
    String? notes,
    String? rejectionReason,
    double? proposedHourlyRate,
    double? proposedPricePerMile,
    double? totalProposedPrice,
    bool? vehicleMeetsRequirements,
    String? vehicleCompatibilityNotes,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      vehicleRequirementId: vehicleRequirementId ?? this.vehicleRequirementId,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverEmail: driverEmail ?? this.driverEmail,
      driverPhone: driverPhone ?? this.driverPhone,
      appliedVehicle: appliedVehicle ?? this.appliedVehicle,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      proposedHourlyRate: proposedHourlyRate ?? this.proposedHourlyRate,
      proposedPricePerMile: proposedPricePerMile ?? this.proposedPricePerMile,
      totalProposedPrice: totalProposedPrice ?? this.totalProposedPrice,
      vehicleMeetsRequirements:
          vehicleMeetsRequirements ?? this.vehicleMeetsRequirements,
      vehicleCompatibilityNotes:
          vehicleCompatibilityNotes ?? this.vehicleCompatibilityNotes,
    );
  }
}

/// Application Status Enum
enum ApplicationStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected'),
  withdrawn('Withdrawn'),
  underReview('Under Review'),
  shortlisted('Shortlisted');

  const ApplicationStatus(this.displayName);
  final String displayName;
}
