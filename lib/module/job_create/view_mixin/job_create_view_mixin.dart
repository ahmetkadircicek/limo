import 'package:flutter/material.dart';
import 'package:limo/module/job_create/view_model/job_create_view_model.dart';
import 'package:limo/shared/models/job_type_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';

mixin JobCreateViewMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> jobFormKey = GlobalKey<FormState>();

  String? validateJobType(JobTypeModel? value) {
    if (value == null) {
      return 'Please select a job type';
    }
    return null;
  }

  bool validateJob(JobCreateViewModel viewModel) {
    final missingFields = <String>{};
    if (viewModel.job.title == null || viewModel.job.title!.isEmpty) {
      missingFields.add('Job Title');
    }
    if (viewModel.job.description == null ||
        viewModel.job.description!.isEmpty) {
      missingFields.add('Description');
    }
    if (viewModel.selectedJobType == null) {
      missingFields.add('Job Type');
    }
    if (viewModel.job.pickupDate == null) {
      missingFields.add('Pickup Date');
    }
    if (viewModel.job.pickupLocation == null) {
      missingFields.add('Pickup Location');
    }

    final requiresDropoff = viewModel.requiresDropoff;
    if (requiresDropoff) {
      if (viewModel.job.dropoffDate == null) {
        missingFields.add('Dropoff Date');
      }
      if (viewModel.job.dropoffLocation == null) {
        missingFields.add('Dropoff Location');
      }
      if (viewModel.job.dropoffDate != null && viewModel.job.pickupDate != null) {
        final diff = viewModel.job.dropoffDate!.difference(viewModel.job.pickupDate!);
        if (diff.inMinutes < 1) {
          AppSnackbar.error(
            message: 'Dropoff must be at least 1 minute after pickup.',
          );
          return false;
        }
      }
    }

    final formValid = jobFormKey.currentState?.validate() ?? false;
    if (!formValid) {
      if (missingFields.isNotEmpty) {
        AppSnackbar.error(
          message:
              'Please complete required fields: ${missingFields.join(', ')}',
        );
      }
      return false;
    }

    if (missingFields.isNotEmpty) {
      AppSnackbar.error(
        message: 'Please complete required fields: ${missingFields.join(', ')}',
      );
      return false;
    }

    return viewModel.isValid;
  }
}
