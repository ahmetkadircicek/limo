import 'package:limo/core/enums/job_type_enum.dart';

class JobModel {
  final String id;
  final String? companyName;
  final String? description;
  final JobType? jobType;
  final DateTime? startDate;
  final double? price;
  final LocationData? fromLocation;
  final LocationData? toLocation;

  JobModel({
    required this.id,
    this.companyName,
    this.description,
    this.jobType,
    this.startDate,
    this.price,
    this.fromLocation,
    this.toLocation,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      companyName: json['company_name'],
      description: json['description'],
      jobType:
          json['job_type'] != null
              ? JobType.values.firstWhere(
                (e) => e.toString().split('.').last == json['job_type'],
                orElse: () => JobType.fullDay,
              )
              : null,
      startDate:
          json['start_date'] != null
              ? DateTime.parse(json['start_date'])
              : null,
      price: json['price']?.toDouble(),
      fromLocation:
          json['from_location'] != null
              ? LocationData.fromJson(json['from_location'])
              : null,
      toLocation:
          json['to_location'] != null
              ? LocationData.fromJson(json['to_location'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'description': description,
      'job_type': jobType?.toString().split('.').last,
      'start_date': startDate?.toIso8601String(),
      'price': price,
      'from_location': fromLocation?.toJson(),
      'to_location': toLocation?.toJson(),
    };
  }

  JobModel copyWith({
    String? id,
    String? companyName,
    String? description,
    JobType? jobType,
    DateTime? startDate,
    double? price,
    LocationData? fromLocation,
    LocationData? toLocation,
  }) {
    return JobModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      description: description ?? this.description,
      jobType: jobType ?? this.jobType,
      startDate: startDate ?? this.startDate,
      price: price ?? this.price,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
    );
  }

  @override
  String toString() {
    return 'JobModel(id: $id, companyName: $companyName, description: $description, jobType: $jobType, startDate: $startDate, price: $price, fromLocation: $fromLocation, toLocation: $toLocation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobModel &&
        other.id == id &&
        other.companyName == companyName &&
        other.description == description &&
        other.jobType == jobType &&
        other.startDate == startDate &&
        other.price == price &&
        other.fromLocation == fromLocation &&
        other.toLocation == toLocation;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      companyName,
      description,
      jobType,
      startDate,
      price,
      fromLocation,
      toLocation,
    );
  }
}

/// Simple location data model
class LocationData {
  final String? placeName;
  final String? address;

  const LocationData({this.placeName, this.address});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      placeName: json['place_name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'place_name': placeName, 'address': address};
  }

  @override
  String toString() {
    return 'LocationData(placeName: $placeName, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData &&
        other.placeName == placeName &&
        other.address == address;
  }

  @override
  int get hashCode {
    return Object.hash(placeName, address);
  }
}
