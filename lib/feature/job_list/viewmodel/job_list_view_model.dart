import 'package:flutter/material.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/location_data_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';

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
    // TODO: Implement real API call here
    // For now, keeping empty list as per requirements
    _jobs = [];
    _filteredJobs = [];
    notifyListeners();
  }

  /// Show filter options
  void showFilters() {
    // TODO: Implement filter modal/dialog
    debugPrint('Show filters');
  }

  /// Add mock jobs for testing (only in development)
  void addMockJobs() {
    // This method should only be used in development/testing
    // Production code should not have mock data
    if (const bool.fromEnvironment('dart.vm.product')) {
      return;
    }

    _jobs = [
      JobModel(
        id: 'job_1234567890',
        companyName: 'ABC Logistics Ltd.',
        contactInfo: '+1 (555) 123-4567',
        description:
            'Urgent delivery from Istanbul to Ankara. High-value cargo requiring premium vehicle.',
        jobType: JobType.pointToPoint,
        startDate: DateTime.parse('2024-01-15T09:00:00.000Z'),
        endDate: DateTime.parse('2024-01-15T18:00:00.000Z'),
        fromLocation: LocationData(
          placeName: 'Istanbul Airport',
          address: 'Istanbul Airport, 34283 Arnavutkoy/Istanbul',
          latitude: 41.2751,
          longitude: 28.7519,
          placeId: 'ChIJ1234567890',
        ),
        toLocation: LocationData(
          placeName: 'Ankara Esenboga Airport',
          address: 'Esenboga Airport, 06790 Akyurt/Ankara',
          latitude: 40.1281,
          longitude: 32.9951,
          placeId: 'ChIJ0987654321',
        ),

        vehicleRequirements: [
          VehicleRequirement(
            id: 'req_001',
            minimumCategory: 8,
            capacity: 4,
            year: 2020,
            hourlyRate: 150.0,
            pricePerMile: 2.5,
            notes: 'Premium vehicle required for VIP transport',
          ),
        ],
        status: 'active',
        createdAt: DateTime.parse('2024-01-10T10:30:00.000Z'),
      ),
      JobModel(
        id: 'job_0987654321',
        companyName: 'XYZ Events',
        contactInfo: '+1 (555) 987-6543',
        description:
            'Daily rental for corporate event transportation in Istanbul',
        jobType: JobType.fullDay,
        startDate: DateTime.parse('2024-01-20T08:00:00.000Z'),
        endDate: DateTime.parse('2024-01-21T08:00:00.000Z'),
        fromLocation: LocationData(
          placeName: 'Istanbul Convention Center',
          address: 'Harbiye District, 34367 Sisli/Istanbul',
          latitude: 41.0422,
          longitude: 28.9877,
          placeId: 'ChIJ4567890123',
        ),
        toLocation: null,

        vehicleRequirements: [
          VehicleRequirement(
            id: 'req_002',
            minimumCategory: 6,
            capacity: 8,
            hourlyRate: 100.0,
            notes: 'Comfortable vehicle for executive transport',
          ),
          VehicleRequirement(
            id: 'req_003',
            minimumCategory: 4,
            capacity: 4,
            hourlyRate: 80.0,
            notes: 'Standard sedan for staff transport',
          ),
        ],
        status: 'active',
        createdAt: DateTime.parse('2024-01-10T11:00:00.000Z'),
      ),
      JobModel(
        id: 'job_1122334455',
        companyName: 'City Tours Ltd.',
        contactInfo: '+1 (555) 555-5555',
        description: 'Hourly rental for city tour service',
        jobType: JobType.hourly,
        startDate: DateTime.parse('2024-01-25T10:00:00.000Z'),
        endDate: DateTime.parse('2024-01-25T14:00:00.000Z'),
        fromLocation: LocationData(
          placeName: 'Taksim Square',
          address: 'Taksim Square, 34435 Beyoglu/Istanbul',
          latitude: 41.0370,
          longitude: 28.9850,
          placeId: 'ChIJ7890123456',
        ),
        toLocation: null,

        vehicleRequirements: [
          VehicleRequirement(
            id: 'req_004',
            minimumCategory: 5,
            capacity: 6,
            hourlyRate: 75.0,
            notes: 'Comfortable vehicle for tourist groups',
          ),
        ],
        status: 'active',
        createdAt: DateTime.parse('2024-01-10T12:00:00.000Z'),
      ),
    ];
    _filteredJobs = List.from(_jobs);
    notifyListeners();
  }
}
