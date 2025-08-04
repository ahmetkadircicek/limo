import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/core/init/navigation/navigation_service.dart';
import 'package:soforvarcom/feature/company_registration/view/company_registration_view.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_dropdown.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';

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
          padding: PaddingConstants.allMedium,
          child: Column(
            children: [
              _buildTitle(),
              context.spacerHeight(1),
              _buildSubtitle(),
              context.spacerHeight(3),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        _buildVehicleForm(viewModel),
                        context.spacerHeight(3),
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
  return GeneralText(
    text: 'Vehicle Registration',
    fontSize: GeneralConstants.fontSizeLarge,
    fontWeight: GeneralConstants.fontWeightBold,
  );
}

// Builds the subtitle
Widget _buildSubtitle() {
  return Builder(
    builder: (context) {
      return GeneralText(
        text:
            'To continue using the platform, please add at least one vehicle.',
        fontSize: GeneralConstants.fontSizeSmall,
        fontWeight: GeneralConstants.fontWeightLight,
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
      GeneralTextField(
        controller: viewModel.licencePlateController,
        hintText: 'Licence Plate',
        prefixIcon: const Icon(Icons.confirmation_number),
        validator: viewModel.validateLicencePlate,
      ),
      const SizedBox(height: 16),

      // Brand
      GeneralTextField(
        controller: viewModel.brandController,
        hintText: 'Brand',
        prefixIcon: const Icon(Icons.branding_watermark),
        validator: viewModel.validateBrand,
      ),
      const SizedBox(height: 16),

      // Model
      GeneralTextField(
        controller: viewModel.modelController,
        hintText: 'Model',
        prefixIcon: const Icon(Icons.directions_car),
        validator: viewModel.validateModel,
      ),
      const SizedBox(height: 16),

      // Year
      GeneralDropdown(
        items: VehicleRegistrationViewModel.yearOptions,
        hintText: 'Year',
        value: viewModel.selectedYear,
        prefixIcon: const Icon(Icons.calendar_today),
        onChanged: viewModel.updateYear,
      ),
      const SizedBox(height: 16),

      // Capacity
      GeneralDropdown(
        items: VehicleRegistrationViewModel.capacityOptions,
        hintText: 'Capacity',
        value: viewModel.selectedCapacity,
        prefixIcon: const Icon(Icons.people),
        onChanged: viewModel.updateCapacity,
      ),
      const SizedBox(height: 16),

      // Vehicle Type
      GeneralDropdown(
        items: VehicleRegistrationViewModel.vehicleTypes,
        hintText: 'Vehicle Type',
        value: viewModel.selectedVehicleType,
        prefixIcon: const Icon(Icons.car_repair),
        onChanged: viewModel.updateVehicleType,
      ),
      const SizedBox(height: 16),

      // Interior Color
      GeneralDropdown(
        items: VehicleRegistrationViewModel.colorOptions,
        hintText: 'Interior Color',
        value: viewModel.selectedInteriorColor,
        prefixIcon: const Icon(Icons.color_lens),
        onChanged: viewModel.updateInteriorColor,
      ),
      const SizedBox(height: 16),

      // Exterior Color
      GeneralDropdown(
        items: VehicleRegistrationViewModel.colorOptions,
        hintText: 'Exterior Color',
        value: viewModel.selectedExteriorColor,
        prefixIcon: const Icon(Icons.palette),
        onChanged: viewModel.updateExteriorColor,
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
    child: GeneralButton(
      fontSize: GeneralConstants.fontSizeMedium,
      color: context.primary,
      text: 'Add Vehicle',
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
  return GeneralButton(
    fontSize: GeneralConstants.fontSizeSmall,
    color: context.surface,
    fontColor: context.secondary,
    text: 'Cancel',
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
