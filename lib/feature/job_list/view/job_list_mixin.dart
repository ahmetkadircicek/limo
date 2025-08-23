import 'package:flutter/material.dart';
import 'package:limo/feature/job_list/viewmodel/job_list_view_model.dart';

/// Mixin for JobListView business logic
mixin JobListMixin<T extends StatefulWidget> on State<T> {
  late final JobListViewModel _viewModel;
  bool _isInitialized = false;

  /// Initialize the mixin with required view model
  void initializeJobListMixin() {
    _viewModel = JobListViewModel();
  }

  /// Initialize the ViewModel when first built
  void initializeViewModelIfNeeded() {
    if (_isInitialized) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        _viewModel.buildInitializeJobList();
        _isInitialized = true;
        setState(() {}); // Force rebuild after initialization
      }
    });
  }

  /// Get the view model instance
  JobListViewModel get viewModel => _viewModel;

  /// Dispose mixin resources
  void disposeJobListMixin() {
    // No resources to dispose
  }
}
