// core/providers/job_type_provider.dart
import 'package:flutter/material.dart';
import 'package:limo/module/job_create/services/job_type_service.dart';
import 'package:limo/shared/models/job_type_model.dart';
import 'package:limo/shared/state/async_status.dart';

class JobTypeProvider extends ChangeNotifier {
  AsyncStatus _status = AsyncStatus.idle;
  List<JobTypeModel> _jobTypes = [];
  JobTypeModel? _selected;
  String? _errorMessage;

  List<JobTypeModel> get jobTypes => _jobTypes;
  JobTypeModel? get selected => _selected;
  AsyncStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> loadJobTypes(BuildContext context) async {
    _setStatus(AsyncStatus.loading);
    _errorMessage = null;
    try {
      final result = await JobTypeService.getJobTypes(context);
      if (result.isError) {
        _jobTypes = [];
        _errorMessage = result.message;
        _setStatus(AsyncStatus.error);
        return;
      }

      _jobTypes = result.data ?? const [];
      if (_selected == null && _jobTypes.isNotEmpty) {
        _selected = _jobTypes.firstWhere(
          (type) => type.jobTypeName.toLowerCase().contains('route'),
          orElse: () => _jobTypes.first,
        );
      }
      _setStatus(_jobTypes.isEmpty ? AsyncStatus.empty : AsyncStatus.success);
    } finally {
      if (_status == AsyncStatus.loading) {
        _setStatus(AsyncStatus.idle);
      }
    }
  }

  void select(JobTypeModel? jobType) {
    _selected = jobType;
    notifyListeners();
  }

  void _setStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
