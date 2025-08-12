import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/vehicle_registration_view_model.dart';

final class VehicleRegistrationView extends StatelessWidget {
  final VehicleModel? vehicleToEdit;

  const VehicleRegistrationView({super.key, this.vehicleToEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      body: _buildFullScreenContent(),
    );
  }
}

// Builds the full screen content
Widget _buildFullScreenContent() {
  return Consumer<VehicleRegistrationViewModel>(
    builder: (context, viewModel, child) {
      return Padding(
        padding: PaddingConstants.horizontalL,
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      spacing: PaddingConstants.spacingL,
                      children: [
                        _buildVehicleInfoSection(viewModel),
                        _buildVehicleSpecsSection(viewModel),
                        _buildCategorySection(viewModel),
                        _buildActionButtons(context, viewModel),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Builds the vehicle information section
Widget _buildVehicleInfoSection(VehicleRegistrationViewModel viewModel) {
  return _buildSection(
    title: 'Vehicle Information',
    icon: Icons.directions_car,
    children: [
      AppInput.primary(
        controller: viewModel.licencePlateController,
        hintText: 'Enter license plate number',
        prefixIcon: Icons.confirmation_number,
        validator: viewModel.validateLicencePlate,
      ),
      const SizedBox(height: 16),
      AppInput.dropdown(
        hintText: 'Select vehicle brand',
        dropdownItems: VehicleRegistrationViewModel.brandOptions,
        dropdownValue: viewModel.selectedBrand,
        onDropdownChanged: (value) {
          viewModel.setBrand(value);
        },
        prefixIcon: Icons.branding_watermark,
      ),
      const SizedBox(height: 16),
      AppInput.primary(
        controller: viewModel.modelController,
        hintText: 'Enter vehicle model',
        prefixIcon: Icons.directions_car,
        validator: viewModel.validateModel,
      ),
    ],
  );
}

// Builds the vehicle specifications section
Widget _buildVehicleSpecsSection(VehicleRegistrationViewModel viewModel) {
  return _buildSection(
    title: 'Vehicle Specifications',
    icon: Icons.settings,
    children: [
      AppInput.dropdown(
        hintText: 'Select vehicle type',
        dropdownItems: VehicleRegistrationViewModel.vehicleTypes,
        dropdownValue: viewModel.selectedVehicleType,
        onDropdownChanged: (value) {
          viewModel.setVehicleType(value);
        },
        prefixIcon: Icons.local_shipping,
      ),
      const SizedBox(height: 16),
      AppInput.primary(
        controller: viewModel.yearController,
        hintText: 'Enter year',
        prefixIcon: Icons.calendar_today,
        keyboardType: TextInputType.number,
        validator: viewModel.validateYear,
      ),
      const SizedBox(height: 16),
      AppInput.primary(
        controller: viewModel.capacityController,
        hintText: 'Number of people',
        prefixIcon: Icons.people,
        keyboardType: TextInputType.number,
        validator: viewModel.validateCapacity,
      ),
    ],
  );
}

// Builds the vehicle category section (most important)
Widget _buildCategorySection(VehicleRegistrationViewModel viewModel) {
  return _buildSection(
    title: 'Vehicle Category',
    icon: Icons.star,
    children: [
      AppInput.dropdown(
        hintText: 'Select vehicle category',
        dropdownItems: VehicleRegistrationViewModel.categoryOptions,
        dropdownValue: viewModel.selectedCategory,
        onDropdownChanged: (value) {
          viewModel.setCategory(value);
        },
        prefixIcon: Icons.category,
      ),
    ],
  );
}

// Builds a section with title and icon
Widget _buildSection({
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Builder(
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: context.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppText.heading(
                    title,
                    color: context.onSurface,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...children,
            ],
          ),
        ),
      );
    },
  );
}

// Builds the action buttons
Widget _buildActionButtons(
    BuildContext context, VehicleRegistrationViewModel viewModel) {
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        height: 52,
        child: AppButton.primary(
          viewModel.vehicleToEdit != null ? 'Update Vehicle' : 'Add Vehicle',
          onPressed: () async {
            bool success = await viewModel.registerVehicle(context);
            if (success) {
              Navigator.of(context).pop(true); // Return success
            }
          },
          width: double.infinity,
          height: 52,
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        height: 52,
        child: AppButton.secondary(
          'Cancel',
          onPressed: () => Navigator.of(context).pop(),
          width: double.infinity,
          height: 52,
        ),
      ),
    ],
  );
}
