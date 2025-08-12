import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/vehicle_registration_view_model.dart';

/// Main view for vehicle registration form with comprehensive input fields
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

/// Builds the complete screen content with form and sections
Widget _buildFullScreenContent() {
  return Consumer<VehicleRegistrationViewModel>(
    builder: (context, viewModel, child) {
      return Padding(
        padding: context.horizontalL,
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildVehicleInfoSection(viewModel, context),
                        SizedBox(height: context.spacingL),
                        _buildVehicleSpecsSection(viewModel, context),
                        SizedBox(height: context.spacingL),
                        _buildCategorySection(viewModel, context),
                        SizedBox(height: context.spacingL),
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

/// Builds the vehicle information section with license plate, brand, and model
Widget _buildVehicleInfoSection(
    VehicleRegistrationViewModel viewModel, BuildContext context) {
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
      SizedBox(height: context.spacingL),
      AppInput.dropdown(
        hintText: 'Select vehicle brand',
        dropdownItems: VehicleRegistrationViewModel.brandOptions,
        dropdownValue: viewModel.selectedBrand,
        onDropdownChanged: (value) {
          viewModel.setBrand(value);
        },
        prefixIcon: Icons.branding_watermark,
      ),
      SizedBox(height: context.spacingL),
      AppInput.primary(
        controller: viewModel.modelController,
        hintText: 'Enter vehicle model',
        prefixIcon: Icons.directions_car,
        validator: viewModel.validateModel,
      ),
    ],
  );
}

/// Builds the vehicle specifications section with type, year, and capacity
Widget _buildVehicleSpecsSection(
    VehicleRegistrationViewModel viewModel, BuildContext context) {
  return _buildSection(
    title: 'Vehicle Specifications',
    icon: Icons.settings,
    children: [
      AppInput.dropdown(
        hintText: 'Select vehicle type',
        dropdownItems: VehicleRegistrationViewModel.vehicleTypes,
        dropdownValue: viewModel.selectedVehicleType,
        onDropdownChanged: (value) {
          viewModel.updateVehicleType(value);
        },
        prefixIcon: Icons.local_shipping,
      ),
      SizedBox(height: context.spacingL),
      AppInput.dropdown(
        hintText: 'Select year',
        dropdownItems: VehicleRegistrationViewModel.yearOptions,
        dropdownValue: viewModel.selectedYear,
        onDropdownChanged: (value) {
          viewModel.updateYear(value);
        },
        prefixIcon: Icons.calendar_today,
      ),
      SizedBox(height: context.spacingL),
      AppInput.dropdown(
        hintText: 'Select capacity',
        dropdownItems: VehicleRegistrationViewModel.capacityOptions,
        dropdownValue: viewModel.selectedCapacity,
        onDropdownChanged: (value) {
          viewModel.updateCapacity(value);
        },
        prefixIcon: Icons.people,
      ),
    ],
  );
}

/// Builds the vehicle category section for classification
Widget _buildCategorySection(
    VehicleRegistrationViewModel viewModel, BuildContext context) {
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

/// Builds the action buttons section with register and clear options
Widget _buildActionButtons(
    BuildContext context, VehicleRegistrationViewModel viewModel) {
  return _buildSection(
    title: 'Actions',
    icon: Icons.play_arrow,
    children: [
      Row(
        children: [
          Expanded(
            child: AppButton.primary(
              'Register Vehicle',
              onPressed: () async {
                final success = await viewModel.registerVehicle(context);
                if (success) {
                  viewModel.clearForm();
                }
              },
            ),
          ),
          SizedBox(width: context.spacingL),
          Expanded(
            child: AppButton.secondary(
              'Clear Form',
              onPressed: () {
                viewModel.clearForm();
              },
            ),
          ),
        ],
      ),
    ],
  );
}

/// Builds a section with title, icon, and children widgets
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
          borderRadius: context.radiusLarge,
          boxShadow: [
            BoxShadow(
              color: context.onSurface.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: context.paddingXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, icon, title),
              SizedBox(height: context.spacingL),
              ...children,
            ],
          ),
        ),
      );
    },
  );
}

/// Builds the section header with icon and title
Widget _buildSectionHeader(BuildContext context, IconData icon, String title) {
  return Row(
    children: [
      Container(
        padding: context.paddingS,
        decoration: BoxDecoration(
          color: context.primary.withValues(alpha: 0.1),
          borderRadius: context.radiusMedium,
        ),
        child: Icon(
          icon,
          color: context.primary,
          size: 20,
        ),
      ),
      SizedBox(width: context.spacingM),
      AppText.heading(
        title,
        color: context.onSurface,
      ),
    ],
  );
}
