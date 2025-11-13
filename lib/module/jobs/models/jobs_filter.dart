import 'package:flutter/material.dart';

class JobsFilterModel {
  final DateTimeRange? dateRange;
  final String? jobTypeName;

  const JobsFilterModel({this.dateRange, this.jobTypeName});

  bool get isEmpty => dateRange == null && (jobTypeName == null || jobTypeName!.isEmpty);

  JobsFilterModel copyWith({DateTimeRange? dateRange, String? jobTypeName}) {
    return JobsFilterModel(
      dateRange: dateRange ?? this.dateRange,
      jobTypeName: jobTypeName ?? this.jobTypeName,
    );
  }
}
