import 'package:limo/feature/job_list/model/job_model.dart';

/// ViewModel for managing job list business logic and state
class JobListViewModel {
  List<JobModel> _jobs = [];
  List<JobModel> _filteredJobs = [];
  String _selectedJobType = 'All';
  String _searchQuery = '';

  /// Get the list of all jobs
  List<JobModel> get jobs => _jobs;

  /// Get the filtered list of jobs
  List<JobModel> get filteredJobs => _filteredJobs;

  /// Get the selected job type filter
  String get selectedJobType => _selectedJobType;

  /// Get the current search query
  String get searchQuery => _searchQuery;

  /// Initialize the job list with empty data and mock data for development
  void initializeJobList() {
    _jobs = [];
    _filteredJobs = [];

    // Mock data only available in development mode
    if (!const bool.fromEnvironment('dart.vm.product')) {
      _loadMockData();
    }
  }

  /// Filter jobs based on search query and job type selection
  void filterJobs(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Set the job type filter and apply filtering
  void setJobTypeFilter(String jobType) {
    _selectedJobType = jobType;
    _applyFilters();
  }

  /// Apply search and job type filters to create filtered job list
  void _applyFilters() {
    final query = _searchQuery.toLowerCase();

    _filteredJobs =
        _jobs.where((job) {
          final matchesSearch = _checkSearchMatch(job, query);
          final matchesJobType = _checkJobTypeMatch(job);
          return matchesSearch && matchesJobType;
        }).toList();
  }

  /// Check if job matches the search query criteria
  bool _checkSearchMatch(JobModel job, String query) {
    if (query.isEmpty) return true;

    return (job.fromLocation?.placeName.toLowerCase().contains(query) ??
            false) ||
        (job.toLocation?.placeName.toLowerCase().contains(query) ?? false) ||
        (job.companyName?.toLowerCase().contains(query) ?? false) ||
        (job.description?.toLowerCase().contains(query) ?? false);
  }

  /// Check if job matches the selected job type filter
  bool _checkJobTypeMatch(JobModel job) {
    return _selectedJobType == 'All' ||
        job.jobType.toString().split('.').last == _selectedJobType;
  }

  /// Refresh the job list from API and reset filtered results
  Future<void> refreshJobList() async {
    // TODO: Implement API call for job list refresh
    _jobs = [];
    _filteredJobs = [];
  }

  /// Display filter options modal for job type selection
  void showFilters() {
    // TODO: Implement filter modal UI
  }

  /// Load mock data for development and testing purposes
  void _loadMockData() {
    // Mock data implementation will be added here
    // This method is only called in development mode
  }
}
