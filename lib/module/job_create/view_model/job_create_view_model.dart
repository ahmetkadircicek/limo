// view_model/job_create_view_model.dart

import 'package:flutter/material.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/job_create/services/job_create_service.dart';
import 'package:limo/module/job_create/view/add_car_requirement_view.dart';
import 'package:limo/shared/models/car_requirement_model.dart';
import 'package:limo/shared/models/job_model.dart'; // senin JobModel sınıfın
import 'package:limo/shared/models/job_type_model.dart';
import 'package:limo/shared/models/picked_location_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:limo/core/services/google_directions_service.dart';
import 'package:provider/provider.dart';

class JobCreateViewModel extends ChangeNotifier {
  JobModel job;

  // UI'de sadece göstermek için (readonly alanlar)
  final String? userName;
  final String? companyName;
  final String? contactInfo;

  bool submitting = false;
  JobTypeModel? _selectedJobType;
  int _formVersion = 0;

  JobCreateViewModel({
    required String userId,
    this.userName,
    this.companyName,
    this.contactInfo,
  }) : job = JobModel(userId: userId);

  int get formVersion => _formVersion;

  JobTypeModel? get selectedJobType => _selectedJobType;
  bool get requiresDropoff =>
      (_selectedJobType?.jobTypeName.toLowerCase().contains('route') ?? false);
  PickedLocation? get pickupLocation => job.pickupLocation;
  PickedLocation? get dropoffLocation => job.dropoffLocation;
  bool get hasPickup => job.pickupDate != null && job.pickupLocation != null;
  bool get hasDropoff => job.dropoffDate != null && job.dropoffLocation != null;
  bool get shareNumber => job.shareNumber;
  String get maskedContactInfo {
    if (contactInfo == null || contactInfo!.isEmpty) {
      return '-';
    }
    return job.shareNumber ? contactInfo! : '******';
  }

  // ---- setters ----
  void setJobType(JobTypeModel? type, {bool resetForm = true}) {
    _selectedJobType = type;
    job = job.copyWith(jobTypeId: type?.jobTypeId, jobType: type?.jobTypeName);
    if (resetForm) {
      job = job.copyWith(
        pickupDate: null,
        dropoffDate: null,
        pickupLocation: null,
        dropoffLocation: null,
        cars: [],
      );
    } else if (!requiresDropoff) {
      job = job.copyWith(dropoffDate: null, dropoffLocation: null);
    }
    notifyListeners();
  }

  void setPickupDate(DateTime d) {
    job = job.copyWith(pickupDate: d);
    notifyListeners();
  }

  void setDropoffDate(DateTime d) {
    job = job.copyWith(dropoffDate: d);
    notifyListeners();
  }

  void setPickupLocation(PickedLocation location) {
    job = job.copyWith(pickupLocation: location);
    notifyListeners();
  }

  void setDropoffLocation(PickedLocation location) {
    job = job.copyWith(dropoffLocation: location);
    notifyListeners();
  }

  void setCars(List<CarRequirementModel> cars) {
    job = job.copyWith(cars: List<CarRequirementModel>.from(cars));
    notifyListeners();
  }

  List<CarRequirementModel> get carRequirements => List.unmodifiable(job.cars);

  void addCarRequirement(CarRequirementModel car) {
    job = job.copyWith(cars: [...job.cars, car]);
    notifyListeners();
  }

  void removeCarRequirement(int index) {
    if (index < 0 || index >= job.cars.length) return;
    final updated = List<CarRequirementModel>.from(job.cars)..removeAt(index);
    job = job.copyWith(cars: updated);
    notifyListeners();
  }

  void setTitle(String value) {
    final trimmed = value.trim();
    job = job.copyWith(title: trimmed.isEmpty ? null : trimmed);
    notifyListeners();
  }

  void setDescription(String value) {
    final trimmed = value.trim();
    job = job.copyWith(description: trimmed.isEmpty ? null : trimmed);
    notifyListeners();
  }

  Future<void> onAddCarRequirement(BuildContext context) async {
    final user = context.read<UserProvider>().user;

    if (user == null || (user.accessToken ?? '').isEmpty) {
      AppSnackbar.warning(
        message: 'You must be signed in to add a car requirement.',
      );
      return;
    }

    final accessToken = user.accessToken!;

    final categoryProvider = context.read<CategoryProvider>();
    final brandProvider = context.read<BrandProvider>();
    final modelProvider = context.read<ModelProvider>();

    await Future.wait([
      categoryProvider.fetchCategories(
        userId: user.userId,
        accessToken: accessToken,
      ),
      brandProvider.fetchBrands(userId: user.userId, accessToken: accessToken),
    ]);

    modelProvider.clearModels();

    if (!context.mounted) return;

    final car = await Navigator.of(context).push<CarRequirementModel>(
      MaterialPageRoute(builder: (_) => const AddCarRequirementView()),
    );

    if (car != null) {
      addCarRequirement(car);
      AppSnackbar.success(message: 'Car requirement added');
    }
  }

  bool get isValid => job.isValid;

  Future<bool> submit(BuildContext context) async {
    if (!isValid) return false;

    submitting = true;
    notifyListeners();

    try {
      // If route requires dropoff and we have both addresses, try to compute distance+duration.
      if (requiresDropoff &&
          job.pickupLocation?.address != null &&
          job.dropoffLocation?.address != null) {
        final dir = GoogleDirectionsService();
        final res = await dir.routeDistanceDuration(
          originAddress: job.pickupLocation!.address,
          originLat: job.pickupLocation!.lat,
          originLng: job.pickupLocation!.lng,
          destinationAddress: job.dropoffLocation!.address,
          destinationLat: job.dropoffLocation!.lat,
          destinationLng: job.dropoffLocation!.lng,
        );
        if (res != null) {
          // Convert meters->miles for US, seconds->minutes
          final miles = res.meters / 1609.344;
          final minutes = res.seconds / 60.0;
          job = job.copyWith(
            distanceRoad: double.parse(miles.toStringAsFixed(2)),
            durationMinutes: double.parse(minutes.toStringAsFixed(0)),
          );
        }
      }

      final result = await JobCreateService.submitJob(context, job);

      if (result.isSuccess) {
        _resetForNewJob();
        return true;
      } else {
        AppSnackbar.error(
          message: result.message ?? 'Failed to create job. Please try again.',
        );
      }
    } finally {
      submitting = false;
      notifyListeners();
    }
    return false;
  }

  void toggleShareNumber() {
    job = job.copyWith(shareNumber: !job.shareNumber);
    notifyListeners();
  }

  void _resetForNewJob() {
    final currentUserId = job.userId;
    final currentJobType = _selectedJobType;
    _formVersion++;
    job = JobModel(userId: currentUserId);
    if (currentJobType != null) {
      job = job.copyWith(
        jobTypeId: currentJobType.jobTypeId,
        jobType: currentJobType.jobTypeName,
      );
    }
    notifyListeners();
  }
}
