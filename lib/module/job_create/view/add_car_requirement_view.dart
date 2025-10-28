import 'package:flutter/material.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/job_create/view_model/add_car_requirement_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:limo/shared/widgets/form/shared_dropdown_field.dart';
import 'package:limo/shared/widgets/form/shared_stepper_field.dart';
import 'package:limo/shared/widgets/form/shared_text_field.dart';
import 'package:limo/shared/widgets/shared_async_status_builder.dart';
import 'package:limo/shared/widgets/shared_button.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';

class AddCarRequirementView extends StatefulWidget {
  const AddCarRequirementView({super.key});

  @override
  State<AddCarRequirementView> createState() => _AddCarRequirementViewState();
}

class _AddCarRequirementViewState extends State<AddCarRequirementView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddCarRequirementViewModel>(
      create: (_) => AddCarRequirementViewModel(),
      child: Scaffold(
        backgroundColor: context.surfaceContainer,
        appBar: AppBar(
          backgroundColor: context.surface,
          foregroundColor: context.onSurface,
          title: Text('Add Car Requirement', style: context.body),
        ),
        body: SafeArea(
          child: Consumer<AddCarRequirementViewModel>(
            builder: (context, viewModel, _) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: PaddingConstants.all20,
                  child: SharedCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: PaddingConstants.p20,
                      children: [
                        _BrandDropdown(viewModel: viewModel),
                        if (viewModel.selectedBrand != null)
                          _ModelDropdown(viewModel: viewModel),
                        _CategoryDropdown(viewModel: viewModel),
                        _ModelYearField(viewModel: viewModel),
                        _CapacityField(viewModel: viewModel),
                        _FeeFields(viewModel: viewModel),
                        _SubmitButton(formKey: _formKey, viewModel: viewModel),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BrandDropdown extends StatelessWidget {
  const _BrandDropdown({required this.viewModel});

  final AddCarRequirementViewModel viewModel;

  @override
  Widget build(BuildContext context) {
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
              value: viewModel.selectedBrand,
              itemLabelBuilder: (item) => item.brandName ?? '',
              isRequired: true,
              onChanged: (brand) {
                if (brand != null) viewModel.selectBrand(context, brand);
              },
              validator:
                  (value) => value == null ? 'Please select a brand' : null,
            );
          },
        );
      },
    );
  }
}

class _ModelDropdown extends StatelessWidget {
  const _ModelDropdown({required this.viewModel});

  final AddCarRequirementViewModel viewModel;

  @override
  Widget build(BuildContext context) {
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
            final brandId = viewModel.selectedBrandId;
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
              value: viewModel.selectedModel,
              itemLabelBuilder: (item) => item.modelName ?? '',
              isRequired: true,
              onChanged: viewModel.selectModel,
              validator:
                  (value) => value == null ? 'Please select a model' : null,
            );
          },
        );
      },
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.viewModel});

  final AddCarRequirementViewModel viewModel;

  @override
  Widget build(BuildContext context) {
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
              value: viewModel.selectedCategory,
              itemLabelBuilder: (item) => item.categoryName ?? '',
              isRequired: true,
              onChanged: viewModel.selectCategory,
              validator:
                  (value) => value == null ? 'Please select a category' : null,
            );
          },
        );
      },
    );
  }
}

class _ModelYearField extends StatelessWidget {
  const _ModelYearField({required this.viewModel});

  final AddCarRequirementViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SharedStepperField(
      label: 'Model Year',
      valueText: viewModel.modelYear.toString(),
      onIncrement:
          viewModel.canIncrementModelYear ? viewModel.incrementModelYear : null,
      onDecrement:
          viewModel.canDecrementModelYear ? viewModel.decrementModelYear : null,
      canIncrement: viewModel.canIncrementModelYear,
      canDecrement: viewModel.canDecrementModelYear,
    );
  }
}

class _CapacityField extends StatelessWidget {
  const _CapacityField({required this.viewModel});

  final AddCarRequirementViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SharedStepperField(
      label: 'Capacity',
      valueText: viewModel.capacity.toString(),
      onIncrement:
          viewModel.canIncrementCapacity ? viewModel.incrementCapacity : null,
      onDecrement:
          viewModel.canDecrementCapacity ? viewModel.decrementCapacity : null,
      canIncrement: viewModel.canIncrementCapacity,
      canDecrement: viewModel.canDecrementCapacity,
    );
  }
}

class _FeeFields extends StatelessWidget {
  const _FeeFields({required this.viewModel});

  final AddCarRequirementViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PaddingConstants.p12,
      children: [
        SharedTextField(
          controller: viewModel.mileFeeController,
          label: 'Mile Fee',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: viewModel.currencyInputFormatters,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter mile fee';
            }
            return viewModel.parseCurrency(value) == null
                ? 'Invalid number'
                : null;
          },
          suffix: Icon(Icons.attach_money, color: context.onSurface, size: 20),
        ),
        SharedTextField(
          controller: viewModel.hourlyFeeController,
          label: 'Hourly Fee',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: viewModel.currencyInputFormatters,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter hourly fee';
            }
            return viewModel.parseCurrency(value) == null
                ? 'Invalid number'
                : null;
          },
          suffix: Icon(Icons.attach_money, color: context.onSurface, size: 20),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.formKey, required this.viewModel});

  final GlobalKey<FormState> formKey;
  final AddCarRequirementViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SharedButton(
      text: 'Add Requirement',
      backgroundColor: context.primary,
      foregroundColor: context.onPrimary,
      onPressed: () {
        final valid = formKey.currentState?.validate() ?? false;
        if (!valid) return;

        final requirement = viewModel.buildRequirement();
        if (requirement == null) {
          AppSnackbar.error(message: 'Please complete all fields.');
          return;
        }

        Navigator.of(context).pop(requirement);
      },
    );
  }
}
