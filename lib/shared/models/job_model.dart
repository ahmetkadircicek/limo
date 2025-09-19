import 'package:limo/shared/models/car_requirement_model.dart';

class JobModel {
  final String userId;
  String? jobType;
  DateTime? pickupDate;
  DateTime? dropoffDate;
  String? pickupLocation;
  String? dropoffLocation;
  List<CarRequirementModel> cars;

  JobModel({
    required this.userId,
    this.jobType,
    this.pickupDate,
    this.dropoffDate,
    this.pickupLocation,
    this.dropoffLocation,
    List<CarRequirementModel>? cars,
  }) : cars = cars ?? [];

  bool get isValid =>
      (jobType?.isNotEmpty ?? false) &&
      pickupDate != null &&
      dropoffDate != null &&
      (pickupLocation?.isNotEmpty ?? false) &&
      (dropoffLocation?.isNotEmpty ?? false);

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'job_type': jobType,
      'pickup_date': pickupDate?.toIso8601String(),
      'dropoff_date': dropoffDate?.toIso8601String(),
      'pickup_location': pickupLocation,
      'dropoff_location': dropoffLocation,
      'cars': cars.map((c) => c.toJson()).toList(),
    };
  }

  JobModel copyWith({
    String? jobType,
    DateTime? pickupDate,
    DateTime? dropoffDate,
    String? pickupLocation,
    String? dropoffLocation,
    List<CarRequirementModel>? cars,
  }) {
    return JobModel(
      userId: userId,
      jobType: jobType ?? this.jobType,
      pickupDate: pickupDate ?? this.pickupDate,
      dropoffDate: dropoffDate ?? this.dropoffDate,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      cars: cars ?? this.cars,
    );
  }
}
