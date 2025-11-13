import 'package:flutter/material.dart';
import 'package:limo/core/services/job_service.dart';
import 'package:limo/module/jobs/models/jobs_filter.dart';
import 'package:limo/shared/models/job_model.dart';
import 'package:limo/shared/state/async_status.dart';

class JobProvider extends ChangeNotifier {
  List<JobModel> _jobs = [];
  AsyncStatus _status = AsyncStatus.idle;
  String? _errorMessage;
  final int _pageSize = 10;
  int _visible = 10;
  JobsFilterModel _filter = const JobsFilterModel();

  List<JobModel> get jobs => _jobs;
  JobsFilterModel get filter => _filter;
  bool get hasActiveFilters => !_filter.isEmpty;
  List<JobModel> get _filteredJobs {
    if (_filter.isEmpty) return _jobs;
    Iterable<JobModel> list = _jobs;
    if ((_filter.jobTypeName ?? '').trim().isNotEmpty) {
      final target = _filter.jobTypeName!.trim().toLowerCase();
      list = list.where((j) {
        final t = (j.jobType ?? j.jobTypeName ?? '').trim().toLowerCase();
        return t == target;
      });
    }
    final range = _filter.dateRange;
    if (range != null) {
      final start = DateTime(range.start.year, range.start.month, range.start.day);
      final end = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59, 999);
      list = list.where((j) {
        final d = j.pickupDate;
        if (d == null) return false;
        return !d.isBefore(start) && !d.isAfter(end);
      });
    }
    return list.toList();
  }
  List<JobModel> get visibleJobs {
    final list = _filteredJobs;
    return list.length <= _visible ? list : list.take(_visible).toList();
  }
  AsyncStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> loadJobs(BuildContext context, {bool force = false}) async {
    if (!force && _hasLoadedJobs) return;

    _setStatus(AsyncStatus.loading);
    _errorMessage = null;

    final result = await JobService.getJobs(context);

    if (result.isError) {
      _handleError(result.message);
      return;
    }

    _handleSuccess(result.data ?? []);
  }

  void setFilter(JobsFilterModel filter) {
    _filter = filter;
    _resetPagination();
    notifyListeners();
  }

  void clearFilter() {
    _filter = const JobsFilterModel();
    _resetPagination();
    notifyListeners();
  }

  void clear() {
    _jobs = [];
    _errorMessage = null;
    _setStatus(AsyncStatus.idle);
  }

  bool get _hasLoadedJobs {
    return _jobs.isNotEmpty && _status == AsyncStatus.success;
  }

  void _resetPagination() {
    _visible = _pageSize;
  }

  void loadMore() {
    if (_visible < _jobs.length) {
      _visible = (_visible + _pageSize).clamp(0, _jobs.length);
      notifyListeners();
    }
  }

  void _handleError(String? message) {
    _jobs = [];
    _errorMessage = message;
    _setStatus(AsyncStatus.error);
  }

  void _handleSuccess(List<JobModel> jobs) {
    _jobs = jobs;
    _resetPagination();
    if (_jobs.isEmpty) {
      _setStatus(AsyncStatus.empty);
    } else {
      _setStatus(AsyncStatus.success);
    }
  }

  void _setStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
