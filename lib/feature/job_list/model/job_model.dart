import 'package:soforvarcom/core/enums/pickup_type_enum.dart';
import 'package:soforvarcom/feature/job_list/model/coordinate_model.dart';
import 'package:soforvarcom/feature/vehicle_registration/model/vehicle_model.dart';

class JobModel {
  final String id;
  final String fromProvince;
  final String toProvince;
  final String? fromCity;
  final String? toCity;
  final Coordinate fromLocation;
  final Coordinate? toLocation;
  final double? price;
  final JobType? pickupType;
  final String? companyName;
  final String? contactInfo;
  final String? description;
  final int? vehicleCount;
  final List<VehicleModel>? vehicles;
  final JobType? jobType;

  JobModel({
    required this.id,
    required this.fromProvince,
    required this.toProvince,
    required this.fromLocation,
    this.toLocation,
    this.fromCity,
    this.toCity,
    this.price,
    this.pickupType,
    this.companyName,
    this.contactInfo,
    this.description,
    this.vehicleCount,
    this.vehicles,
    this.jobType,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      fromProvince: json['fromProvince'] ?? '',
      toProvince: json['toProvince'] ?? '',
      fromCity: json['fromCity'],
      toCity: json['toCity'],
      fromLocation: Coordinate.fromJson(json['fromLocation']),
      toLocation: json['toLocation'] != null
          ? Coordinate.fromJson(json['toLocation'])
          : null,
      price: json['price']?.toDouble(),
      pickupType: json['pickupType'] != null
          ? JobType.values.firstWhere((e) => e.name == json['pickupType'],
              orElse: () => JobType.pointToPoint)
          : null,
      companyName: json['companyName'],
      contactInfo: json['contactInfo'],
      description: json['description'],
      vehicleCount: json['vehicleCount'],
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((v) => VehicleModel.fromJson(v))
          .toList(),
      jobType: json['jobType'] != null
          ? JobType.values.firstWhere((e) => e.name == json['jobType'],
              orElse: () => JobType.pointToPoint)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromProvince': fromProvince,
      'toProvince': toProvince,
      'fromCity': fromCity,
      'toCity': toCity,
      'fromLocation': fromLocation.toJson(),
      'toLocation': toLocation?.toJson(),
      'price': price,
      'pickupType': pickupType?.name,
      'companyName': companyName,
      'contactInfo': contactInfo,
      'description': description,
      'vehicleCount': vehicleCount,
      'vehicles': vehicles?.map((v) => v.toJson()).toList(),
      'jobType': jobType?.name,
    };
  }
}
