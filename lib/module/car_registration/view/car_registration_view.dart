import 'package:flutter/material.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
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
import 'package:limo/shared/widgets/shared_dropdown.dart';
import 'package:limo/shared/widgets/shared_input.dart';
import 'package:provider/provider.dart';

class CarRegistrationView extends StatefulWidget {
  const CarRegistrationView({super.key});
  @override
  State<CarRegistrationView> createState() => _CarRegistrationViewState();
}

class _CarRegistrationViewState extends State<CarRegistrationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: SharedAppBar(title: 'Add Car to Fleet'),
      body: SafeArea(child: _buildRegistrationForm()),
    );
  }

  Widget _buildRegistrationForm() {
    final vm = context.read<CarRegistrationViewModel>();
    return SingleChildScrollView(
      padding: PaddingConstants.all20,
      child: SharedCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: PaddingConstants.p16,
          children: [
            Text('Car Information', style: context.headline),
            SharedInput(
              controller: vm.plateNumberController,
              label: 'Plate Number',
              hint: 'ABC-1234',
              inputFormatters: [PlateInputFormatter()],
            ),
            _buildBrandDropdown(vm),
            if (vm.selectedBrandId != null) _buildModelDropdown(vm),
            _buildCategoryDropdown(vm),
            SharedInput(
              controller: vm.modelYearController,
              label: 'Year',
              hint: 'Enter Year',
              keyboardType: TextInputType.number,
            ),
            SharedInput(
              controller: vm.capacityController,
              label: 'Capacity',
              hint: 'Enter Capacity',
              keyboardType: TextInputType.number,
            ),
            Consumer<CarRegistrationViewModel>(
              builder: (context, vm, _) {
                return SharedButton(
                  text: "Add Car",
                  backgroundColor: context.primary,
                  foregroundColor: context.onPrimary,
                  isLoading: vm.isSubmitting, // loading state ekleyelim
                  onPressed:
                      vm.isFormReady
                          ? () async {
                            await vm.submit(context);
                          }
                          : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandDropdown(CarRegistrationViewModel vm) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, _) {
        return SharedDropdown<BrandModel>(
          label: 'Brand',
          hint: 'Select Brand',
          items: brandProvider.brands,
          value: vm.selectedBrand,
          itemToString: (b) => b.brandName ?? '',
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
        return SharedDropdown<ModelModel>(
          label: 'Model',
          hint: 'Select Model',
          items: modelProvider.models,
          value: vm.selectedModel,
          itemToString: (m) => m.modelName ?? '',
          onChanged: (m) {
            vm.selectModel(m);
          },
        );
      },
    );
  }

  Widget _buildCategoryDropdown(CarRegistrationViewModel vm) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        final items = categoryProvider.categories;
        return SharedDropdown<CategoryModel>(
          label: 'Category',
          hint: 'Select Category',
          items: items,
          value: vm.selectedCategory,
          itemToString: (c) => c.categoryName ?? '',
          onChanged: (c) {
            if (c != null) vm.selectCategory(c);
          },
        );
      },
    );
  }
}
