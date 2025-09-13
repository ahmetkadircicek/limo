import 'package:flutter/material.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/feature/fleet_vehicle_registration/view_model/fleet_vehicle_registration_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/utils/plate_input_formatter.dart';
import 'package:limo/shared/widgets/shared_app_bar.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_dropdown.dart';
import 'package:limo/shared/widgets/shared_input.dart';
import 'package:provider/provider.dart';

class FleetVehicleRegistrationView extends StatefulWidget {
  const FleetVehicleRegistrationView({super.key});
  @override
  State<FleetVehicleRegistrationView> createState() =>
      _FleetVehicleRegistrationViewState();
}

class _FleetVehicleRegistrationViewState
    extends State<FleetVehicleRegistrationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: SharedAppBar(title: 'Add Vehicle to Fleet'),
      body: SafeArea(child: _buildRegistrationForm()),
    );
  }

  Widget _buildRegistrationForm() {
    final vm = context.read<FleetVehicleRegistrationViewModel>();
    return SingleChildScrollView(
      padding: PaddingConstants.all20,
      child: SharedCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: PaddingConstants.p16,
          children: [
            Text('Vehicle Information', style: context.headline),
            SharedInput(
              controller: vm.plateNumberController,
              label: 'Plate Number',
              hint: 'ABC-1234',
              inputFormatters: [PlateInputFormatter()],
            ),
            _buildBrandDropdown(vm),
            _buildModelDropdown(vm),
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
          ],
        ),
      ),
    );
  }

  Widget _buildBrandDropdown(FleetVehicleRegistrationViewModel vm) {
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

  Widget _buildModelDropdown(FleetVehicleRegistrationViewModel vm) {
    return Consumer<ModelProvider>(
      builder: (context, modelProvider, _) {
        if (vm.selectedBrandId == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SharedDropdown<ModelModel>(
            label: 'Model',
            hint: 'Select Model',
            items: modelProvider.models,
            value: vm.selectedModel,
            itemToString: (m) => m.modelName ?? '',
            onChanged: vm.selectModel,
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown(FleetVehicleRegistrationViewModel vm) {
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
