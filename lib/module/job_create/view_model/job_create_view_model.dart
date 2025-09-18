// view_model/job_create_view_model.dart

import 'package:flutter/material.dart';
import 'package:limo/shared/models/car_requirement_model.dart';
import 'package:limo/shared/models/job_model.dart'; // senin JobModel sınıfın

class JobCreateViewModel extends ChangeNotifier {
  JobModel job;

  // UI'de sadece göstermek için (readonly alanlar)
  final String? userName;
  final String? companyName;
  final String? contactInfo;

  bool submitting = false;

  JobCreateViewModel({
    required String userId,
    this.userName,
    this.companyName,
    this.contactInfo,
  }) : job = JobModel(userId: userId);

  // ---- setters ----
  void setJobType(String? type) {
    job = job.copyWith(jobType: type);
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

  void setPickupLocation(String address) {
    job = job.copyWith(pickupLocation: address);
    notifyListeners();
  }

  void setDropoffLocation(String address) {
    job = job.copyWith(dropoffLocation: address);
    notifyListeners();
  }

  void setCars(List<CarRequirementModel> cars) {
    job = job.copyWith(cars: cars);
    notifyListeners();
  }

  bool get isValid => job.isValid;

  Future<void> submit(BuildContext context) async {
    if (!isValid) return;

    submitting = true;
    notifyListeners();

    try {
      final payload = job.toJson(); // doğrudan JobModel → JSON
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payload ready: $payload')));

      // TODO: service call buraya eklenecek
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}
