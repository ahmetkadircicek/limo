import 'package:flutter/material.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/car_registration/view_mixin/car_registration_view_mixin.dart';
import 'package:limo/module/car_registration/view_model/car_registration_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/utils/plate_input_formatter.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:limo/shared/widgets/form/shared_dropdown_field.dart';
import 'package:limo/shared/widgets/form/shared_stepper_field.dart';
import 'package:limo/shared/widgets/form/shared_text_field.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
import 'package:limo/shared/widgets/shared_async_status_builder.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:limo/shared/widgets/shared_card.dart';
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
            padding: PaddingConstants.all24,
            child: SharedCard(
              child: _buildFormBody(context, carRegistrationViewModel),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormBody(
    BuildContext context,
    CarRegistrationViewModel viewModel,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: PaddingConstants.p8,
      children: [
        _buildPlateField(viewModel),
        _buildBrandDropdown(viewModel),
        if (viewModel.selectedBrandId != null) _buildModelDropdown(viewModel),
        _buildCategoryDropdown(viewModel),
        _buildYearField(viewModel),
        _buildCapacityField(viewModel),
        _buildSubmitButton(context, viewModel),
      ],
    );
  }

  Widget _buildPlateField(CarRegistrationViewModel viewModel) {
    return SharedTextField(
      controller: viewModel.plateNumberController,
      label: 'Plate Number',
      validator: validatePlate,
      isRequired: true,
      inputFormatters: [PlateInputFormatter()],
    );
  }

  Widget _buildBrandDropdown(CarRegistrationViewModel vm) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, _) {
        return SharedAsyncStatusBuilder(
          status: brandProvider.status,
          errorMessage: brandProvider.errorMessage,
          idleBuilder:
              (_) => const FormDropdownLoadingState(
                label: 'Brand',
                isRequired: true,
              ),
          loadingBuilder:
              (_) => const FormDropdownLoadingState(
                label: 'Brand',
                isRequired: true,
              ),
          emptyBuilder:
              (_) => const FormDropdownEmptyState(
                label: 'Brand',
                isRequired: true,
              ),
          errorBuilder: (ctx, message) {
            final user = ctx.read<UserProvider>().user;
            return FormDropdownErrorState(
              label: 'Brand',
              message: message,
              isRequired: true,
              onRetry:
                  user == null || (user.accessToken ?? '').isEmpty
                      ? null
                      : () => ctx.read<BrandProvider>().fetchBrands(
                        userId: user.userId,
                        accessToken: user.accessToken!,
                      ),
            );
          },
          successBuilder: (_) {
            final items = brandProvider.brands;
            return SharedDropdownField<BrandModel>(
              label: 'Brand',
              items: items,
              value: vm.selectedBrand,
              itemLabelBuilder: (b) => b.brandName ?? '',
              isRequired: true,
              validator: validateBrand,
              onChanged: (b) {
                if (b != null) vm.selectBrand(context, b);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildModelDropdown(CarRegistrationViewModel vm) {
    return Consumer<ModelProvider>(
      builder: (context, modelProvider, _) {
        return SharedAsyncStatusBuilder(
          status: modelProvider.status,
          errorMessage: modelProvider.errorMessage,
          idleBuilder:
              (_) => const FormDropdownDisabledState(
                label: 'Model',
                message: 'Select a brand first',
                isRequired: true,
              ),
          loadingBuilder:
              (_) => const FormDropdownLoadingState(
                label: 'Model',
                isRequired: true,
              ),
          emptyBuilder:
              (_) => const FormDropdownEmptyState(
                label: 'Model',
                isRequired: true,
              ),
          errorBuilder: (ctx, message) {
            final user = ctx.read<UserProvider>().user;
            final brandId = vm.selectedBrandId;
            return FormDropdownErrorState(
              label: 'Model',
              message: message,
              isRequired: true,
              onRetry:
                  user == null ||
                          (user.accessToken ?? '').isEmpty ||
                          brandId == null
                      ? null
                      : () => ctx.read<ModelProvider>().fetchModels(
                        userId: user.userId,
                        accessToken: user.accessToken!,
                        brandId: brandId,
                      ),
            );
          },
          successBuilder: (_) {
            final items = modelProvider.models;
            return SharedDropdownField<ModelModel>(
              label: 'Model',
              items: items,
              value: vm.selectedModel,
              itemLabelBuilder: (m) => m.modelName ?? '',
              isRequired: true,
              validator: validateModel,
              onChanged: vm.selectModel,
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryDropdown(CarRegistrationViewModel vm) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        return SharedAsyncStatusBuilder(
          status: categoryProvider.status,
          errorMessage: categoryProvider.errorMessage,
          idleBuilder:
              (_) => const FormDropdownLoadingState(
                label: 'Category',
                isRequired: true,
              ),
          loadingBuilder:
              (_) => const FormDropdownLoadingState(
                label: 'Category',
                isRequired: true,
              ),
          emptyBuilder:
              (_) => const FormDropdownEmptyState(
                label: 'Category',
                isRequired: true,
              ),
          errorBuilder: (ctx, message) {
            final user = ctx.read<UserProvider>().user;
            return FormDropdownErrorState(
              label: 'Category',
              message: message,
              isRequired: true,
              onRetry:
                  user == null || (user.accessToken ?? '').isEmpty
                      ? null
                      : () => ctx.read<CategoryProvider>().fetchCategories(
                        userId: user.userId,
                        accessToken: user.accessToken!,
                      ),
            );
          },
          successBuilder: (_) {
            final items = categoryProvider.categories;
            return SharedDropdownField<CategoryModel>(
              label: 'Category',
              items: items,
              value: vm.selectedCategory,
              itemLabelBuilder: (c) => c.categoryName ?? '',
              isRequired: true,
              validator: validateCategory,
              onChanged: (c) {
                if (c != null) vm.selectCategory(c);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildYearField(CarRegistrationViewModel viewModel) {
    return SharedStepperField(
      label: 'Year',
      valueText: viewModel.modelYear.toString(),
      onDecrement: viewModel.decrementModelYear,
      onIncrement: viewModel.incrementModelYear,
      canDecrement: viewModel.canDecrementModelYear,
      canIncrement: viewModel.canIncrementModelYear,
    );
  }

  Widget _buildCapacityField(CarRegistrationViewModel viewModel) {
    return SharedStepperField(
      label: 'Capacity',
      valueText: viewModel.capacityValue.toString(),
      onDecrement: viewModel.decrementCapacity,
      onIncrement: viewModel.incrementCapacity,
      canDecrement: viewModel.canDecrementCapacity,
      canIncrement: viewModel.canIncrementCapacity,
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    CarRegistrationViewModel viewModel,
  ) {
    return SharedButton(
      text: 'Add Car',
      backgroundColor: context.primary,
      foregroundColor: context.onPrimary,
      isLoading: viewModel.isSubmitting,
      onPressed:
          viewModel.isSubmitting
              ? null
              : () async {
                final valid = validateCarForm(viewModel);
                if (!valid) return;

                final ok = await viewModel.submit(context);
                if (!context.mounted) return;

                if (ok) {
                  AppSnackbar.success(message: 'Car added successfully');
                  Navigator.of(context).pop(true);
                } else {
                  AppSnackbar.error(message: 'Failed to add car');
                }
              },
    );
  }
}
