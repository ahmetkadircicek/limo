import 'package:flutter/material.dart';
import 'package:limo/core/services/job_service.dart';
import 'package:limo/shared/models/job_model.dart';
import 'package:limo/shared/state/async_status.dart';

class JobProvider extends ChangeNotifier {
  List<JobModel> _jobs = [];
  AsyncStatus _status = AsyncStatus.idle;
  String? _errorMessage;

  List<JobModel> get jobs => _jobs;
  AsyncStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> loadJobs(BuildContext context) async {
    _setStatus(AsyncStatus.loading);
    _errorMessage = null;

    final result = await JobService.getJobs(context);

    if (result.isError) {
      _jobs = [];
      _errorMessage = result.message;
      _setStatus(AsyncStatus.error);
      return;
    }

    _jobs = result.data ?? [];
    if (_jobs.isEmpty) {
      _setStatus(AsyncStatus.empty);
    } else {
      _setStatus(AsyncStatus.success);
    }
  }

  void clear() {
    _jobs = [];
    _errorMessage = null;
    _setStatus(AsyncStatus.idle);
  }

  void _setStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
