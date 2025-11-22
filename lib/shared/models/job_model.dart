import 'package:limo/shared/models/car_requirement_model.dart';
import 'package:limo/shared/models/picked_location_model.dart';
import 'package:limo/shared/utils/date_time_formatter.dart';

class JobModel {
  final String userId;
  int? jobId;
  int? jobTypeId;
  String? jobType; // API: job_type
  String? jobTypeName; // API: job_type_name
  DateTime? pickupDate; // API: expected_start_date / pickup_date
  DateTime? dropoffDate; // API: expected_end_date / dropoff_date
  LocationModel? pickupLocation;
  LocationModel? dropoffLocation;
  String? title; // API: title / job_title
  String? description; // API: description / job_description
  double? distanceRoad; // API: distance_road / distance
  double? durationMinutes; // API: duration_minutes / duration
  String? status; // API: status / job_status
  bool shareNumber; // API: share_number
  List<CarRequirementModel> cars; // API: cars / vehicles
  DateTime? createdAt; // API: job_created_at
  String? contactPhone; // API: contact_phone / creator_phone / phone
  String? contactEmail; // API: contact_email / creator_email / email

  JobModel({
    required this.userId,
    this.jobId,
    this.jobTypeId,
    this.jobType,
    this.jobTypeName,
    this.pickupDate,
    this.dropoffDate,
    this.pickupLocation,
    this.dropoffLocation,
    this.title,
    this.description,
    this.distanceRoad,
    this.durationMinutes,
    String? statusValue,
    bool shareNumberValue = true,
    List<CarRequirementModel>? cars,
    this.createdAt,
    this.contactPhone,
    this.contactEmail,
  }) : status = statusValue ?? 'active',
       shareNumber = shareNumberValue,
       cars = cars ?? [];

  factory JobModel.fromJson(
    Map<String, dynamic> json, {
    required String fallbackUserId,
  }) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    DateTime? toDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    LocationModel? locationFromJson({
      dynamic address,
      dynamic lat,
      dynamic lng,
      dynamic placeId,
    }) {
      final addr = address?.toString();
      if (addr == null || addr.isEmpty) return null;
      return LocationModel(
        address: addr,
        lat: toDouble(lat),
        lng: toDouble(lng),
        placeId: placeId?.toString(),
      );
    }

    final userIdValue = (json['user_id'] ?? fallbackUserId).toString();

    final pickupLocation = locationFromJson(
      address: json['pickup_location_text'] ?? json['pickup_address'],
      lat: json['pickup_latitude'] ?? json['pickup_lat'],
      lng: json['pickup_longitude'] ?? json['pickup_lng'],
      placeId: json['pickup_place_id'],
    );

    final dropoffLocation = locationFromJson(
      address: json['dropoff_location_text'] ?? json['dropoff_address'],
      lat: json['dropoff_latitude'] ?? json['dropoff_lat'],
      lng: json['dropoff_longitude'] ?? json['dropoff_lng'],
      placeId: json['dropoff_place_id'],
    );

    // Vehicles / Cars list (supports both keys: 'cars' and 'vehicles')
    final vehiclesJson = json['cars'] ?? json['vehicles'];
    final parsedCars =
        vehiclesJson is List
            ? vehiclesJson
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => CarRequirementModel(
                    brandId: toInt(e['brand_id']) ?? 0,
                    modelId: toInt(e['model_id']) ?? 0,
                    modelYear: toInt(e['modelyear']) ?? 0,
                    capacity: toInt(e['capacity']) ?? 0,
                    categoryId: toInt(e['category_id']) ?? 0,
                    mileFee: toInt(e['mile_fee']) ?? 0,
                    hourlyFee: toInt(e['hourly_fee']) ?? 0,
                    jobVehicleId: toInt(e['job_vehicle_id']),
                    brandName: e['brand_name']?.toString(),
                    modelName: e['model_name']?.toString(),
                    categoryName: e['category_name']?.toString(),
                    createdAt:
                        e['vehicle_created_at'] == null
                            ? null
                            : DateTime.tryParse(
                              e['vehicle_created_at'].toString(),
                            ),
                  ),
                )
                .toList()
            : <CarRequirementModel>[];

    return JobModel(
      userId: userIdValue,
      jobId: toInt(json['job_id']),
      jobTypeId: toInt(json['job_type_id']),
      jobType: json['job_type']?.toString(),
      jobTypeName: json['job_type_name']?.toString(),
      pickupDate: toDate(json['expected_start_date'] ?? json['pickup_date']),
      dropoffDate: toDate(json['expected_end_date'] ?? json['dropoff_date']),
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      title: json['title']?.toString() ?? json['job_title']?.toString(),
      description:
          json['description']?.toString() ??
          json['job_description']?.toString(),
      distanceRoad: toDouble(json['distance_road'] ?? json['distance']),
      durationMinutes: toDouble(json['duration_minutes'] ?? json['duration']),
      statusValue: json['status']?.toString() ?? json['job_status']?.toString(),
      shareNumberValue:
          json['share_number'] == null
              ? true
              : (json['share_number'] == true ||
                  json['share_number'] == 1 ||
                  json['share_number'] == '1'),
      cars: parsedCars,
      createdAt: toDate(json['job_created_at']),
      contactPhone:
          (json['contact_phone'] ?? json['creator_phone'] ?? json['phone'])
              ?.toString(),
      contactEmail:
          (json['contact_email'] ?? json['creator_email'] ?? json['email'])
              ?.toString(),
    );
  }

  bool get isValid =>
      (title != null && title!.isNotEmpty) &&
      (description != null && description!.isNotEmpty) &&
      pickupDate != null;

  Map<String, dynamic> toJson() {
    final carPayload = cars.map((c) => c.toJson()).toList();

    return {
      'user_id': userId,
      'job_type_id': jobTypeId,
      'job_type': jobType,
      'job_type_name': jobTypeName,
      'pickup_location_text': pickupLocation?.address,
      'pickup_latitude': pickupLocation?.lat,
      'pickup_longitude': pickupLocation?.lng,
      'pickup_place_id': pickupLocation?.placeId,
      'dropoff_location_text': dropoffLocation?.address,
      'dropoff_latitude': dropoffLocation?.lat,
      'dropoff_longitude': dropoffLocation?.lng,
      'dropoff_place_id': dropoffLocation?.placeId,
      'distance_road': distanceRoad,
      'duration_minutes': durationMinutes,
      'expected_start_date': DateTimeFormatter.formatApi(pickupDate),
      'expected_end_date': DateTimeFormatter.formatApi(dropoffDate),
      'status': status,
      'job_created_at': createdAt?.toIso8601String(),
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (contactEmail != null) 'contact_email': contactEmail,
      'title': title,
      'description': description,
      'cars':
          carPayload, // server bazı uçlarda 'vehicles' bekliyorsa adaptörde dönüştür
      'share_number': shareNumber,
    };
  }

  JobModel copyWith({
    int? jobId,
    int? jobTypeId,
    String? jobType,
    String? jobTypeName,
    DateTime? pickupDate,
    DateTime? dropoffDate,
    LocationModel? pickupLocation,
    LocationModel? dropoffLocation,
    String? title,
    String? description,
    double? distanceRoad,
    double? durationMinutes,
    String? status,
    bool? shareNumber,
    List<CarRequirementModel>? cars,
    DateTime? createdAt,
    String? contactPhone,
    String? contactEmail,
  }) {
    return JobModel(
      userId: userId,
      jobId: jobId ?? this.jobId,
      jobTypeId: jobTypeId ?? this.jobTypeId,
      jobType: jobType ?? this.jobType,
      jobTypeName: jobTypeName ?? this.jobTypeName,
      pickupDate: pickupDate ?? this.pickupDate,
      dropoffDate: dropoffDate ?? this.dropoffDate,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      title: title ?? this.title,
      description: description ?? this.description,
      distanceRoad: distanceRoad ?? this.distanceRoad,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      statusValue: status ?? this.status,
      shareNumberValue: shareNumber ?? this.shareNumber,
      cars: cars ?? this.cars,
      createdAt: createdAt ?? this.createdAt,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
    );
  }
}
