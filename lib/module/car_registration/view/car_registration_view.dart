import 'package:flutter/material.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/module/car_registration/view_mixin/car_registration_view_mixin.dart';
import 'package:limo/module/car_registration/view_model/car_registration_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/utils/plate_input_formatter.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_dropdown_field.dart';
import 'package:limo/shared/widgets/shared_stepper_field.dart';
import 'package:limo/shared/widgets/shared_text_field.dart';
import 'package:provider/provider.dart';

class CarRegistrationView extends StatefulWidget {
  const CarRegistrationView({super.key});
  @override
  State<CarRegistrationView> createState() => _CarRegistrationViewState();
}

class _CarRegistrationViewState extends State<CarRegistrationView>
    with CarRegistrationViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: const SharedAppBar(
        title: 'Add Car',
        backPath: RoutePaths.carManagement,
      ),
      body: SafeArea(child: _buildRegistrationForm()),
    );
  }

  Widget _buildRegistrationForm() {
    return Consumer<CarRegistrationViewModel>(
      builder: (context, carRegistrationViewModel, child) {
        return Form(
          key: carFormKey,
          child: SingleChildScrollView(
            padding: PaddingConstants.all20,
            child: SharedCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: PaddingConstants.p32,
                children: [
                  Text('Car Information', style: context.headline),
                  SharedTextField(
                    controller: carRegistrationViewModel.plateNumberController,
                    label: 'Plate Number',
                    validator: validatePlate,
                    inputFormatters: [PlateInputFormatter()],
                  ),
                  _buildBrandDropdown(carRegistrationViewModel),
                  if (carRegistrationViewModel.selectedBrandId != null)
                    _buildModelDropdown(carRegistrationViewModel),
                  _buildCategoryDropdown(carRegistrationViewModel),
                  SharedStepperField(
                    label: 'Year',
                    valueText: carRegistrationViewModel.modelYear.toString(),
                    onDecrement: carRegistrationViewModel.decrementModelYear,
                    onIncrement: carRegistrationViewModel.incrementModelYear,
                    canDecrement:
                        carRegistrationViewModel.canDecrementModelYear,
                    canIncrement:
                        carRegistrationViewModel.canIncrementModelYear,
                  ),
                  SharedStepperField(
                    label: 'Capacity',
                    valueText:
                        carRegistrationViewModel.capacityValue.toString(),
                    onDecrement: carRegistrationViewModel.decrementCapacity,
                    onIncrement: carRegistrationViewModel.incrementCapacity,
                    canDecrement: carRegistrationViewModel.canDecrementCapacity,
                    canIncrement: carRegistrationViewModel.canIncrementCapacity,
                  ),
                  SharedButton(
                    text: 'Add Car',
                    backgroundColor: context.primary,
                    foregroundColor: context.onPrimary,
                    isLoading: carRegistrationViewModel.isSubmitting,
                    onPressed:
                        carRegistrationViewModel.isSubmitting
                            ? null
                            : () async {
                              final valid = validateCarForm(
                                carRegistrationViewModel,
                              );
                              if (!valid) return;
                              final ok = await carRegistrationViewModel
                                  .submit(context);
                              if (ok) {
                                carFormKey.currentState?.reset();
                              }
                            },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandDropdown(CarRegistrationViewModel vm) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, _) {
        return SharedDropdownField<BrandModel>(
          label: 'Brand',
          items: brandProvider.brands,
          value: vm.selectedBrand,
          itemLabelBuilder: (b) => b.brandName ?? '',
          validator: validateBrand,
          onChanged: (b) {
            if (b != null) vm.selectBrand(context, b);
          },
        );
      },
    );
  }

  Widget _buildModelDropdown(CarRegistrationViewModel vm) {
    return Consumer<ModelProvider>(
      builder: (context, modelProvider, _) {
        return SharedDropdownField<ModelModel>(
          label: 'Model',
          items: modelProvider.models,
          value: vm.selectedModel,
          itemLabelBuilder: (m) => m.modelName ?? '',
          validator: validateModel,
          onChanged: vm.selectModel,
        );
      },
    );
  }

  Widget _buildCategoryDropdown(CarRegistrationViewModel vm) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        final items = categoryProvider.categories;
        return SharedDropdownField<CategoryModel>(
          label: 'Category',
          items: items,
          value: vm.selectedCategory,
          itemLabelBuilder: (c) => c.categoryName ?? '',
          validator: validateCategory,
          onChanged: (c) {
            if (c != null) vm.selectCategory(c);
          },
        );
      },
    );
  }
}
