import 'package:limo/core/enums/application_status_enum.dart';
import 'package:limo/feature/job_vehicle_registration/model/vehicle_model.dart';

/// Model for job applications
class JobApplication {
  final String id;
  final String jobId;
  final String driverId;
  final VehicleModel vehicle;
  final ApplicationStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final double? proposedPrice;
  final bool isAccepted;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.driverId,
    required this.vehicle,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.proposedPrice,
    this.isAccepted = false,
  });

  /// Get priority score for vehicle requirement matching
  double getPriorityScore(dynamic requirement) {
    // TODO: Implement priority scoring logic
    // For now, return a default score
    return 1.0;
  }

  /// Create a copy with updated values
  JobApplication copyWith({
    String? id,
    String? jobId,
    String? driverId,
    VehicleModel? vehicle,
    ApplicationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    double? proposedPrice,
    bool? isAccepted,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      driverId: driverId ?? this.driverId,
      vehicle: vehicle ?? this.vehicle,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      proposedPrice: proposedPrice ?? this.proposedPrice,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'driver_id': driverId,
      'vehicle': vehicle.toJson(),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'notes': notes,
      'proposed_price': proposedPrice,
      'is_accepted': isAccepted,
    };
  }

  /// Create from JSON
  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      driverId: json['driver_id'] as String,
      vehicle: VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>),
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      notes: json['notes'] as String?,
      proposedPrice: json['proposed_price'] as double?,
      isAccepted: json['is_accepted'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'JobApplication(id: $id, jobId: $jobId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobApplication && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
