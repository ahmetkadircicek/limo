import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/init/navigation/navigation_service.dart';
import 'package:limo/feature/company_registration/view/company_registration_view.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/vehicle_registration_view_model.dart';

final class VehicleRegistrationView extends StatelessWidget {
  const VehicleRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleRegistrationViewModel(context),
      child: Scaffold(
        body: _buildFullScreenContent(),
      ),
    );
  }
}

// Builds the full screen content
Widget _buildFullScreenContent() {
  return Consumer<VehicleRegistrationViewModel>(
    builder: (context, viewModel, child) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              16, 16, 16, 96), // Added 80px bottom padding for navigation bar
          child: Column(
            children: [
              _buildTitle(),
              _buildSubtitle(),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        _buildVehicleForm(viewModel),
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

// Builds the title
Widget _buildTitle() {
  return AppText.body(
    'Vehicle Registration',
  );
}

// Builds the subtitle
Widget _buildSubtitle() {
  return Builder(
    builder: (context) {
      return AppText.body(
        'To continue using the platform, please add at least one vehicle.',
        color: context.secondary,
        textAlign: TextAlign.center,
      );
    },
  );
}

// Builds the vehicle registration form
Widget _buildVehicleForm(VehicleRegistrationViewModel viewModel) {
  return Column(
    children: [
      // Licence Plate
      AppInput.primary(
        controller: viewModel.licencePlateController,
        hintText: 'Licence Plate',
        prefixIcon: Icons.confirmation_number,
        validator: viewModel.validateLicencePlate,
      ),
      const SizedBox(height: 16),

      // Brand
      AppInput.primary(
        controller: viewModel.brandController,
        hintText: 'Brand',
        prefixIcon: Icons.branding_watermark,
        validator: viewModel.validateBrand,
      ),
      const SizedBox(height: 16),

      // Model
      AppInput.primary(
        controller: viewModel.modelController,
        hintText: 'Model',
        prefixIcon: Icons.directions_car,
        validator: viewModel.validateModel,
      ),
      const SizedBox(height: 16),

      // Year
      AppInput.dropdown(
        dropdownItems: VehicleRegistrationViewModel.yearOptions,
        hintText: 'Year',
        dropdownValue: viewModel.selectedYear,
        prefixIcon: Icons.calendar_today,
        onDropdownChanged: viewModel.updateYear,
      ),
      const SizedBox(height: 16),

      // Capacity
      AppInput.dropdown(
        dropdownItems: VehicleRegistrationViewModel.capacityOptions,
        hintText: 'Capacity',
        dropdownValue: viewModel.selectedCapacity,
        prefixIcon: Icons.people,
        onDropdownChanged: viewModel.updateCapacity,
      ),
      const SizedBox(height: 16),

      // Vehicle Type
      AppInput.dropdown(
        dropdownItems: VehicleRegistrationViewModel.vehicleTypes,
        hintText: 'Vehicle Type',
        dropdownValue: viewModel.selectedVehicleType,
        prefixIcon: Icons.car_repair,
        onDropdownChanged: viewModel.updateVehicleType,
      ),
      const SizedBox(height: 16),

      // Interior Color
      AppInput.dropdown(
        dropdownItems: VehicleRegistrationViewModel.colorOptions,
        hintText: 'Interior Color',
        dropdownValue: viewModel.selectedInteriorColor,
        prefixIcon: Icons.color_lens,
        onDropdownChanged: viewModel.updateInteriorColor,
      ),
      const SizedBox(height: 16),

      // Exterior Color
      AppInput.dropdown(
        dropdownItems: VehicleRegistrationViewModel.colorOptions,
        hintText: 'Exterior Color',
        dropdownValue: viewModel.selectedExteriorColor,
        prefixIcon: Icons.palette,
        onDropdownChanged: viewModel.updateExteriorColor,
      ),
    ],
  );
}

// Builds the action buttons
Widget _buildActionButtons(
    BuildContext context, VehicleRegistrationViewModel viewModel) {
  return Column(
    children: [
      _buildAddVehicleButton(context, viewModel),
      _buildCancelButton(context),
    ],
  );
}

// Builds the "Add Vehicle" button
Widget _buildAddVehicleButton(
    BuildContext context, VehicleRegistrationViewModel viewModel) {
  return SizedBox(
    width: double.infinity,
    height: GeneralConstants.heightMedium,
    child: AppButton.primary(
      'Add Vehicle',
      onPressed: () async {
        bool success = await viewModel.registerVehicle(context);
        if (success) {
          // Navigate to company registration after successful vehicle registration
          NavigationService.instance.replaceScreen(
            const CompanyRegistrationView(),
          );
        }
      },
    ),
  );
}

// Builds the "Cancel" button
Widget _buildCancelButton(BuildContext context) {
  return AppButton.primary(
    'Cancel',
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
