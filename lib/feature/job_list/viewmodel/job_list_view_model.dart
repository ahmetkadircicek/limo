import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/job_list/model/job_model.dart';

/// ViewModel for managing job list business logic and state
class JobListViewModel {
  List<JobModel> _jobs = [];
  bool _isInitialized = false;

  /// Get the list of all jobs
  List<JobModel> get jobs => _jobs;

  /// Initialize the job list with empty data
  void buildInitializeJobList() {
    if (_isInitialized) return;

    LoggerService.info('Initializing job list');
    _jobs = [];
    _isInitialized = true;
  }
}
