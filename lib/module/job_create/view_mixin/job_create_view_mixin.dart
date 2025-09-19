import 'package:flutter/material.dart';
import 'package:limo/module/job_create/view_model/job_create_view_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';

mixin JobCreateViewMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> jobFormKey = GlobalKey<FormState>();

  String? validateJobType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a job type';
    }
    return null;
  }

  bool validateJob(JobCreateViewModel viewModel) {
    final formValid = jobFormKey.currentState?.validate() ?? false;
    if (!formValid) return false;

    if (!viewModel.isValid) {
      AppSnackbar.warning(
        message: 'Please fill in pickup/dropoff dates and locations.',
      );
      return false;
    }

    return true;
  }
}
