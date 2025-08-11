import 'dart:math' as math;

import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

class JobApplication {
  final String id;
  final String jobId;
  final String driverId;
  final String driverName;
  final String driverEmail;
  final String driverPhone;
  final VehicleModel appliedVehicle;
  final DateTime applicationDate;
  final ApplicationStatus status;
  final String? notes;
  final double? proposedPrice;
  final String? rejectionReason;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.driverId,
    required this.driverName,
    required this.driverEmail,
    required this.driverPhone,
    required this.appliedVehicle,
    required this.applicationDate,
    this.status = ApplicationStatus.pending,
    this.notes,
    this.proposedPrice,
    this.rejectionReason,
  });

  /// Check if this application meets the job requirements
  bool meetsJobRequirements(JobModel job) {
    // Check if any vehicle requirement matches this vehicle
    for (final requirement in job.vehicleRequirements) {
      if (requirement.matchesVehicle(appliedVehicle)) {
        return true;
      }
    }
    return false;
  }

  /// Get the best matching vehicle requirement for this application
  VehicleRequirement? getBestMatchingRequirement(JobModel job) {
    VehicleRequirement? bestMatch;
    int? bestCategoryId;

    for (final requirement in job.vehicleRequirements) {
      if (requirement.matchesVehicle(appliedVehicle)) {
        final categoryId = requirement.minimumCategory?.id ?? 0;
        if (bestMatch == null || categoryId > (bestCategoryId ?? 0)) {
          bestMatch = requirement;
          bestCategoryId = categoryId;
        }
      }
    }

    return bestMatch;
  }

  /// Calculate the proposed price based on job requirements
  double? calculateProposedPrice(JobModel job) {
    final requirement = getBestMatchingRequirement(job);
    if (requirement == null) return null;

    // Use the requirement's pricing if available
    if (requirement.hourlyRate != null || requirement.pricePerMile != null) {
      return proposedPrice ?? 0.0;
    }

    // Calculate based on job type and vehicle category
    if (job.jobType == JobType.hourly && requirement.hourlyRate != null) {
      return requirement.hourlyRate;
    } else if (job.jobType == JobType.pointToPoint &&
        requirement.pricePerMile != null) {
      // Calculate total price based on distance
      if (job.toLocation != null) {
        final distance = _calculateDistance(
          job.fromLocation.latitude,
          job.fromLocation.longitude,
          job.toLocation!.latitude,
          job.toLocation!.longitude,
        );
        return distance * requirement.pricePerMile!;
      }
    }

    return proposedPrice;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 3959; // miles
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
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
      'driverId': driverId,
      'driverName': driverName,
      'driverEmail': driverEmail,
      'driverPhone': driverPhone,
      'appliedVehicle': appliedVehicle.toJson(),
      'applicationDate': applicationDate.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'proposedPrice': proposedPrice,
      'rejectionReason': rejectionReason,
    };
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
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
      proposedPrice: json['proposedPrice']?.toDouble(),
      rejectionReason: json['rejectionReason'],
    );
  }

  JobApplication copyWith({
    String? id,
    String? jobId,
    String? driverId,
    String? driverName,
    String? driverEmail,
    String? driverPhone,
    VehicleModel? appliedVehicle,
    DateTime? applicationDate,
    ApplicationStatus? status,
    String? notes,
    double? proposedPrice,
    String? rejectionReason,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverEmail: driverEmail ?? this.driverEmail,
      driverPhone: driverPhone ?? this.driverPhone,
      appliedVehicle: appliedVehicle ?? this.appliedVehicle,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      proposedPrice: proposedPrice ?? this.proposedPrice,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

enum ApplicationStatus {
  pending('Beklemede'),
  accepted('Kabul Edildi'),
  rejected('Reddedildi'),
  withdrawn('Geri Çekildi');

  const ApplicationStatus(this.displayName);
  final String displayName;
}
