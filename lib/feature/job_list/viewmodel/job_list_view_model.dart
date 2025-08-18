import 'package:flutter/material.dart';
import 'package:limo/feature/job_list/model/job_model.dart';

/// ViewModel for managing job list business logic and state
class JobListViewModel extends ChangeNotifier {
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

  /// Initialize the job list with empty data
  void initializeJobList() {
    _jobs = [];
    _filteredJobs = [];

    // Add mock data for development/testing
    if (!const bool.fromEnvironment('dart.vm.product')) {
      addMockJobs();
    }

    notifyListeners();
  }

  /// Filter jobs based on search query and job type
  void filterJobs(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Set the job type filter
  void setJobTypeFilter(String jobType) {
    _selectedJobType = jobType;
    _applyFilters();
  }

  /// Apply all active filters to the job list
  void _applyFilters() {
    final query = _searchQuery.toLowerCase();

    _filteredJobs =
        _jobs.where((job) {
          final matchesSearch =
              query.isEmpty ||
              (job.fromLocation?.placeName.toLowerCase().contains(query) ??
                  false) ||
              (job.toLocation?.placeName.toLowerCase().contains(query) ??
                  false) ||
              (job.companyName?.toLowerCase().contains(query) ?? false) ||
              (job.description?.toLowerCase().contains(query) ?? false);

          final matchesJobType =
              _selectedJobType == 'All' ||
              job.jobType.toString().split('.').last == _selectedJobType;

          return matchesSearch && matchesJobType;
        }).toList();

    notifyListeners();
  }

  /// Refresh the job list from API
  Future<void> refreshJobList() async {
    // API call not implemented yet
    _jobs = [];
    _filteredJobs = [];
    notifyListeners();
  }

  /// Show filter options
  void showFilters() {
    // Filter modal not implemented yet
  }

  /// Add mock jobs for testing (only in development)
  void addMockJobs() {
    // Mock data not implemented yet
  }
}
