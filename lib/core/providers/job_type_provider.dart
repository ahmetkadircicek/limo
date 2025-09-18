// core/providers/job_type_provider.dart
import 'package:flutter/material.dart';
import 'package:limo/module/job_create/services/job_type_service.dart';
import 'package:limo/shared/models/job_type_model.dart';

class JobTypeProvider extends ChangeNotifier {
  bool _loading = false;
  List<JobTypeModel> _jobTypes = [];
  JobTypeModel? _selected;

  bool get loading => _loading;
  List<JobTypeModel> get jobTypes => _jobTypes;
  JobTypeModel? get selected => _selected;

  Future<void> loadJobTypes(BuildContext context) async {
    _loading = true;
    notifyListeners();
    try {
      _jobTypes = await JobTypeService.getJobTypes(context);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void select(JobTypeModel? jobType) {
    _selected = jobType;
    notifyListeners();
  }
}
