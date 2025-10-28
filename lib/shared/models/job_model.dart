import 'package:limo/shared/models/car_requirement_model.dart';
import 'package:limo/shared/models/picked_location_model.dart';
import 'package:limo/shared/utils/date_time_formatter.dart';

class JobModel {
  final String userId;
  int? jobId;
  int? jobTypeId;
  String? jobType;
  String? jobTypeName;
  DateTime? pickupDate;
  DateTime? dropoffDate;
  PickedLocation? pickupLocation;
  PickedLocation? dropoffLocation;
  String? title;
  String? description;
  double? distanceRoad;
  double? durationMinutes;
  String? status;
  bool shareNumber;
  List<CarRequirementModel> cars;

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

    PickedLocation? locationFromJson({
      dynamic address,
      dynamic lat,
      dynamic lng,
      dynamic placeId,
    }) {
      final addr = address?.toString();
      if (addr == null || addr.isEmpty) return null;
      return PickedLocation(
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

    final carsJson = json['cars'];
    final cars =
        carsJson is List
            ? carsJson
                .whereType<Map>()
                .map(
                  (e) => CarRequirementModel(
                    brandId: toInt(e['brand_id']) ?? 0,
                    modelId: toInt(e['model_id']) ?? 0,
                    modelYear: toInt(e['modelyear']) ?? 0,
                    capacity: toInt(e['capacity']) ?? 0,
                    categoryId: toInt(e['category_id']) ?? 0,
                    mileFee: toInt(e['mile_fee']) ?? 0,
                    hourlyFee: toInt(e['hourly_fee']) ?? 0,
                  ),
                )
                .toList()
            : <CarRequirementModel>[];

    return JobModel(
      userId: userIdValue,
      jobId: toInt(json['job_id']),
      jobTypeId: toInt(json['job_type_id']),

      jobType:
          json['job_type_name']?.toString() ?? json['job_type']?.toString(),
      pickupDate: toDate(json['expected_start_date'] ?? json['pickup_date']),
      dropoffDate: toDate(json['expected_end_date'] ?? json['dropoff_date']),
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      title: json['title']?.toString() ?? json['job_title']?.toString(),
      description: json['description']?.toString(),
      distanceRoad: toDouble(json['distance_road'] ?? json['distance']),
      durationMinutes: toDouble(json['duration_minutes'] ?? json['duration']),
      statusValue: json['status']?.toString(),
      shareNumberValue:
          json['share_number'] == null
              ? true
              : json['share_number'] == true ||
                  json['share_number'] == 1 ||
                  json['share_number'] == '1',
      cars: cars,
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
      'title': title,
      'description': description,
      'cars': carPayload,
      'share_number': shareNumber,
    };
  }

  JobModel copyWith({
    int? jobId,
    int? jobTypeId,
    String? jobType,
    DateTime? pickupDate,
    DateTime? dropoffDate,
    PickedLocation? pickupLocation,
    PickedLocation? dropoffLocation,
    String? title,
    String? description,
    double? distanceRoad,
    double? durationMinutes,
    String? status,
    bool? shareNumber,
    List<CarRequirementModel>? cars,
  }) {
    return JobModel(
      userId: userId,
      jobId: jobId ?? this.jobId,
      jobTypeId: jobTypeId ?? this.jobTypeId,
      jobType: jobType ?? this.jobType,
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
    );
  }
}
