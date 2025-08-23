import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/job_vehicle_registration_view_model.dart';

/// Main view for job vehicle registration form with comprehensive input fields
final class JobVehicleRegistrationView extends StatelessWidget {
  final VehicleModel? vehicleToEdit;

  const JobVehicleRegistrationView({super.key, this.vehicleToEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: _buildAppBar(context),
      body: _buildFullScreenContent(),
    );
  }

  /// Build app bar with back button and title
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppAppBar.secondary(title: 'Add Vehicle');
  }
}

/// Builds the complete screen content with form and sections
Widget _buildFullScreenContent() {
  return Consumer<JobVehicleRegistrationViewModel>(
    builder: (context, viewModel, child) {
      return Padding(
        padding: context.horizontalL,
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(child: _buildFormContent(viewModel, context)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Build form content with proper spacing
Widget _buildFormContent(
  JobVehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return Column(
    children: [
      SizedBox(height: context.spacingL),
      _buildVehicleInfoSection(viewModel, context),
      SizedBox(height: context.spacingL),
      _buildVehicleSpecsSection(viewModel, context),
      SizedBox(height: context.spacingL),
      _buildCategorySection(viewModel, context),
      SizedBox(height: context.spacingL),
      _buildDocumentSection(viewModel, context),
      SizedBox(height: context.spacingL),
      _buildRegisterButton(viewModel, context),
      SizedBox(height: context.spacingL),
    ],
  );
}

/// Builds the vehicle information section with license plate, brand, and model
Widget _buildVehicleInfoSection(
  JobVehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return _buildSection(
    title: 'Vehicle Information',
    children: [
      AppInput.primary(
        labelText: 'License Plate Number',
        controller: viewModel.licencePlateController,
        hintText: 'ABC-123',
        keyboardType: TextInputType.text,
      ),
      SizedBox(height: context.spacingM),
      AppInput.primary(
        labelText: 'Brand',
        controller: viewModel.brandController,
        hintText: 'Enter vehicle brand',
        keyboardType: TextInputType.text,
      ),
      SizedBox(height: context.spacingM),
      AppInput.primary(
        labelText: 'Model',
        controller: viewModel.modelController,
        hintText: 'Enter vehicle model',
        keyboardType: TextInputType.text,
      ),
    ],
  );
}

/// Builds the vehicle specifications section
Widget _buildVehicleSpecsSection(
  JobVehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return _buildSection(
    title: 'Vehicle Specifications',
    children: [
      AppInput.primary(
        labelText: 'Year',
        controller: viewModel.yearController,
        hintText: '2024',
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: context.spacingM),
      AppInput.primary(
        labelText: 'Capacity',
        controller: viewModel.capacityController,
        hintText: '5',
        keyboardType: TextInputType.number,
      ),
    ],
  );
}

/// Builds the category selection section
Widget _buildCategorySection(
  JobVehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return _buildSection(
    title: 'Vehicle Category',
    children: [
      // TODO: Implement category dropdown selection
      AppText.body('Category selection will be implemented here'),
    ],
  );
}

/// Builds the document upload section
Widget _buildDocumentSection(
  JobVehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return _buildSection(
    title: 'Documents',
    children: [
      // TODO: Implement document upload functionality
      AppText.body('Document upload will be implemented here'),
    ],
  );
}

/// Builds the register button
Widget _buildRegisterButton(
  JobVehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return AppButton.primary(
    'Register Vehicle',
    onPressed: () => _buildHandleVehicleRegistration(viewModel, context),
    width: double.infinity,
  );
}

/// Handle vehicle registration process
void _buildHandleVehicleRegistration(
  JobVehicleRegistrationViewModel viewModel,
  BuildContext context,
) async {
  final success = await viewModel.saveVehicle();
  if (success) {
    Navigator.of(context).pop();
  }
}

/// Build section container with title
Widget _buildSection({required String title, required List<Widget> children}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );
}
