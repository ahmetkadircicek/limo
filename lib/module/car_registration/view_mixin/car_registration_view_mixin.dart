import 'package:flutter/material.dart';
import 'package:limo/module/car_registration/view_model/car_registration_view_model.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';

mixin CarRegistrationViewMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> carFormKey = GlobalKey<FormState>();

  String? validatePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Plate number is required';
    }
    return null;
  }

  String? validateBrand(BrandModel? value) {
    if (value == null) return 'Please select a brand';
    return null;
  }

  String? validateModel(ModelModel? value) {
    if (value == null) return 'Please select a model';
    return null;
  }

  String? validateCategory(CategoryModel? value) {
    if (value == null) return 'Please select a category';
    return null;
  }

  bool validateCarForm(CarRegistrationViewModel viewModel) {
    final formValid = carFormKey.currentState?.validate() ?? false;
    if (!formValid) return false;

    if (viewModel.modelYear < viewModel.minModelYear ||
        viewModel.modelYear > viewModel.maxModelYear) {
      AppSnackbar.warning(
        message:
            'Model year must be between ${viewModel.minModelYear} and ${viewModel.maxModelYear}.',
      );
      return false;
    }

    if (viewModel.capacityValue < viewModel.minCapacity ||
        viewModel.capacityValue > viewModel.maxCapacity) {
      AppSnackbar.warning(
        message:
            'Capacity must be between ${viewModel.minCapacity} and ${viewModel.maxCapacity}.',
      );
      return false;
    }

    return true;
  }
}
