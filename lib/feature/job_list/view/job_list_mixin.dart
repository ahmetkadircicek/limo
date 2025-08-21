import 'package:flutter/material.dart';
import 'package:limo/feature/job_list/viewmodel/job_list_view_model.dart';

/// Mixin for JobListView business logic
mixin JobListMixin<T extends StatefulWidget> on State<T> {
  late final JobListViewModel _viewModel;
  late final TextEditingController _searchController;

  /// Initialize the mixin with required controllers and view model
  void initializeJobListMixin() {
    _viewModel = JobListViewModel();
    _searchController = TextEditingController();
  }

  /// Initialize the ViewModel when first built
  void initializeViewModelIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _viewModel.jobs.isEmpty) {
        _viewModel.initializeJobList();
        setState(() {}); // Force rebuild after initialization
      }
    });
  }

  /// Setup search controller listener for real-time filtering
  void setupSearchListener() {
    _searchController.addListener(() {
      if (mounted) {
        _viewModel.filterJobs(_searchController.text);
        setState(() {}); // Force rebuild after filtering
      }
    });
  }

  /// Handle refresh action with proper state management
  Future<void> handleRefresh(VoidCallback? onRefresh) async {
    await _viewModel.refreshJobList();
    if (mounted) {
      setState(() {}); // Force rebuild after refresh
    }
    onRefresh?.call();
  }

  /// Navigate to job details page
  void navigateToJobDetails(BuildContext context, dynamic job) {
    // TODO: Navigate to job details page
    // For now, just show a message or handle differently
  }

  /// Get the view model instance
  JobListViewModel get viewModel => _viewModel;

  /// Get the search controller instance
  TextEditingController get searchController => _searchController;

  /// Dispose mixin resources
  void disposeJobListMixin() {
    _searchController.dispose();
  }
}
