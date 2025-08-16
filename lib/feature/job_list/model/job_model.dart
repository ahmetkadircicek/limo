import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/feature/job_list/model/job_application_model.dart';
import 'package:limo/feature/job_list/model/location_data_model.dart';
import 'package:limo/feature/job_list/model/pricing_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

class JobModel {
  final String id;
  final String? fromProvince;
  final String? toProvince;
  final String? fromCity;
  final String? toCity;
  final String? location;
  final LocationData? fromLocation;
  final LocationData? toLocation;
  final double? price;
  final String? companyName;
  final String? contactInfo;
  final String? description;
  final int? vehicleCount;
  final List<VehicleModel>? vehicles;
  final JobType? jobType;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? hourlyRate;
  final double? pricePerMile;
  final DateTime? createdAt;
  final List<VehicleRequirement> vehicleRequirements;
  final PricingModel? pricing;

  // Separate applications for each vehicle requirement
  final Map<String, List<JobApplication>> applicationsByRequirement;

  JobModel({
    required this.id,
    this.fromProvince,
    this.toProvince,
    this.fromLocation,
    this.toLocation,
    this.fromCity,
    this.toCity,
    this.location,
    this.price,
    this.companyName,
    this.contactInfo,
    this.description,
    this.vehicleCount,
    this.vehicles,
    this.jobType,
    this.status,
    this.startDate,
    this.endDate,
    this.hourlyRate,
    this.pricePerMile,
    this.createdAt,
    this.vehicleRequirements = const [],
    this.pricing,
    this.applicationsByRequirement = const {},
  });

  /// Get all applications for a specific vehicle requirement
  List<JobApplication> getApplicationsForRequirement(String requirementId) {
    return applicationsByRequirement[requirementId] ?? [];
  }

  /// Get all applications across all requirements
  List<JobApplication> getAllApplications() {
    return applicationsByRequirement.values.expand((apps) => apps).toList();
  }

  /// Get applications by status
  List<JobApplication> getApplicationsByStatus(ApplicationStatus status) {
    return getAllApplications().where((app) => app.status == status).toList();
  }

  /// Get pending applications count
  int get pendingApplicationsCount {
    return getApplicationsByStatus(ApplicationStatus.pending).length;
  }

  /// Get accepted applications count
  int get acceptedApplicationsCount {
    return getApplicationsByStatus(ApplicationStatus.accepted).length;
  }

  /// Check if a specific vehicle requirement has applications
  bool hasApplicationsForRequirement(String requirementId) {
    final applications = applicationsByRequirement[requirementId];
    return applications != null && applications.isNotEmpty;
  }

  /// Get the best application for a specific vehicle requirement
  JobApplication? getBestApplicationForRequirement(String requirementId) {
    final applications = getApplicationsForRequirement(requirementId);
    if (applications.isEmpty) return null;

    // Find the application with the highest priority score
    applications.sort((a, b) {
      final requirement = vehicleRequirements.firstWhere(
        (req) => req.toString().contains(requirementId),
        orElse: () => VehicleRequirement.anyVehicle(),
      );

      final scoreA = a.getPriorityScore(requirement);
      final scoreB = b.getPriorityScore(requirement);

      return scoreB.compareTo(scoreA); // Higher score first
    });

    return applications.first;
  }

  /// Get applications summary for this job
  Map<String, dynamic> getApplicationsSummary() {
    final allApplications = getAllApplications();
    final totalApplications = allApplications.length;

    final statusCounts = <ApplicationStatus, int>{};
    for (final status in ApplicationStatus.values) {
      statusCounts[status] = getApplicationsByStatus(status).length;
    }

    return {
      'totalApplications': totalApplications,
      'statusCounts': statusCounts,
      'pendingCount': pendingApplicationsCount,
      'acceptedCount': acceptedApplicationsCount,
      'hasApplications': totalApplications > 0,
    };
  }

  /// Check if job is still accepting applications
  bool get isAcceptingApplications {
    // Return false if there are enough accepted applications for all vehicle requirements
    for (final requirement in vehicleRequirements) {
      final applications = getApplicationsForRequirement(requirement.id);
      final acceptedApplications =
          applications
              .where((app) => app.status == ApplicationStatus.accepted)
              .length;

      // Return true if there are insufficient accepted applications for any requirement
      if (acceptedApplications < 1) return true;
    }
    return false;
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    List<VehicleRequirement> vehicleRequirements = [];
    if (json['vehicleRequirements'] != null) {
      try {
        final requirementsList = json['vehicleRequirements'] as List<dynamic>;
        vehicleRequirements =
            requirementsList
                .map((reqJson) {
                  try {
                    return VehicleRequirement.fromJson(reqJson);
                  } catch (e) {
                    return null;
                  }
                })
                .where((req) => req != null)
                .cast<VehicleRequirement>()
                .toList();
      } catch (e) {
        vehicleRequirements = [];
      }
    }

    Map<String, List<JobApplication>> applicationsMap = {};
    if (json['applicationsByRequirement'] != null) {
      try {
        final applicationsJson =
            json['applicationsByRequirement'] as Map<String, dynamic>;
        applicationsJson.forEach((requirementId, applicationsList) {
          if (applicationsList is List) {
            applicationsMap[requirementId] =
                applicationsList
                    .map((appJson) => JobApplication.fromJson(appJson))
                    .toList()
                    .cast<JobApplication>();
          }
        });
      } catch (e) {
        applicationsMap = {};
      }
    }

    return JobModel(
      id: json['id'] ?? '',
      fromProvince: json['fromProvince'],
      toProvince: json['toProvince'],
      fromCity: json['fromCity'],
      toCity: json['toCity'],
      location: json['location'],
      fromLocation:
          json['fromLocation'] != null
              ? LocationData.fromJson(json['fromLocation'])
              : null,
      toLocation:
          json['toLocation'] != null
              ? LocationData.fromJson(json['toLocation'])
              : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      companyName: json['companyName'],
      contactInfo: json['contactInfo'],
      description: json['description'],
      vehicleCount: json['vehicleCount'],
      vehicles:
          json['vehicles'] != null
              ? (json['vehicles'] as List<dynamic>)
                  .map((v) => VehicleModel.fromJson(v))
                  .toList()
              : null,
      jobType:
          json['jobType'] != null
              ? JobType.values.firstWhere(
                (e) => e.name == json['jobType'],
                orElse: () => JobType.pointToPoint,
              )
              : null,
      status: json['status'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      hourlyRate:
          json['hourlyRate'] != null
              ? (json['hourlyRate'] as num).toDouble()
              : null,
      pricePerMile:
          json['pricePerMile'] != null
              ? (json['pricePerMile'] as num).toDouble()
              : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      vehicleRequirements: vehicleRequirements,
      pricing:
          json['pricing'] != null
              ? PricingModel.fromJson(json['pricing'])
              : null,
      applicationsByRequirement: applicationsMap,
    );
  }

  Map<String, dynamic> toJson() {
    // Applications by requirement serialization
    final applicationsMap = <String, dynamic>{};
    applicationsByRequirement.forEach((requirementId, applications) {
      applicationsMap[requirementId] =
          applications.map((app) => app.toJson()).toList();
    });

    return {
      'id': id,
      'fromProvince': fromProvince,
      'toProvince': toProvince,
      'fromCity': fromCity,
      'toCity': toCity,
      'location': location,
      'fromLocation': fromLocation?.toJson(),
      'toLocation': toLocation?.toJson(),
      'price': price,
      'companyName': companyName,
      'contactInfo': contactInfo,
      'description': description,
      'vehicleCount': vehicleCount,
      'vehicles': vehicles?.map((v) => v.toJson()).toList(),
      'jobType': jobType?.name,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'hourlyRate': hourlyRate,
      'pricePerMile': pricePerMile,
      'createdAt': createdAt?.toIso8601String(),
      'vehicleRequirements':
          vehicleRequirements.map((req) => req.toJson()).toList(),
      'pricing': pricing?.toJson(),
      'applicationsByRequirement': applicationsMap,
    };
  }

  /// Create a copy with updated applications
  JobModel copyWith({
    String? id,
    String? fromProvince,
    String? toProvince,
    String? fromCity,
    String? toCity,
    String? location,
    LocationData? fromLocation,
    LocationData? toLocation,
    double? price,
    String? companyName,
    String? contactInfo,
    String? description,
    int? vehicleCount,
    List<VehicleModel>? vehicles,
    JobType? jobType,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    double? hourlyRate,
    double? pricePerMile,
    DateTime? createdAt,
    List<VehicleRequirement>? vehicleRequirements,
    PricingModel? pricing,
    Map<String, List<JobApplication>>? applicationsByRequirement,
  }) {
    return JobModel(
      id: id ?? this.id,
      fromProvince: fromProvince ?? this.fromProvince,
      toProvince: toProvince ?? this.toProvince,
      fromCity: fromCity ?? this.fromCity,
      toCity: toCity ?? this.toCity,
      location: location ?? this.location,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      price: price ?? this.price,
      companyName: companyName ?? this.companyName,
      contactInfo: contactInfo ?? this.contactInfo,
      description: description ?? this.description,
      vehicleCount: vehicleCount ?? this.vehicleCount,
      vehicles: vehicles ?? this.vehicles,
      jobType: jobType ?? this.jobType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      pricePerMile: pricePerMile ?? this.pricePerMile,
      createdAt: createdAt ?? this.createdAt,
      vehicleRequirements: vehicleRequirements ?? this.vehicleRequirements,
      pricing: pricing ?? this.pricing,
      applicationsByRequirement:
          applicationsByRequirement ?? this.applicationsByRequirement,
    );
  }
}
