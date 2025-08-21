import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/view/document_upload_view.dart';
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
      appBar: AppBar(
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () {
            // Form'u sıfırla ve geri git
            final viewModel = Provider.of<VehicleRegistrationViewModel>(
              context,
              listen: false,
            );
            viewModel.clearForm();
            Navigator.of(context).pop();
          },
        ),
        title: AppText.heading('Add Vehicle', color: context.onSurface),
        centerTitle: true,
      ),
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
                        SizedBox(
                          height: context.spacingL,
                        ), // Top padding eklendi
                        _buildVehicleInfoSection(viewModel, context),
                        SizedBox(height: context.spacingL),
                        _buildVehicleSpecsSection(viewModel, context),
                        SizedBox(height: context.spacingL),
                        _buildCategorySection(viewModel, context),
                        SizedBox(height: context.spacingL),
                        _buildDocumentSection(viewModel, context),
                        SizedBox(height: context.spacingL),
                        _buildRegisterButton(viewModel, context),
                        SizedBox(
                          height: context.spacingL,
                        ), // Bottom padding eklendi
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
  VehicleRegistrationViewModel viewModel,
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
      SizedBox(height: context.spacingL),
      AppInput.dropdown(
        labelText: 'Vehicle Brand',
        hintText: 'Select brand...',
        dropdownItems: VehicleRegistrationViewModel.brandOptions,
        dropdownValue: viewModel.selectedBrand,
        onDropdownChanged: (value) {
          viewModel.setBrand(value);
        },
      ),
      SizedBox(height: context.spacingL),
      AppInput.primary(
        labelText: 'Vehicle Model',
        controller: viewModel.modelController,
        hintText: 'Sprinter 2500',
        keyboardType: TextInputType.text,
      ),
    ],
  );
}

/// Builds the vehicle specifications section with type, year, and capacity
Widget _buildVehicleSpecsSection(
  VehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return _buildSection(
    title: 'Vehicle Specifications',
    children: [
      AppInput.dropdown(
        labelText: 'Vehicle Type',
        hintText: 'Select type...',
        dropdownItems: VehicleRegistrationViewModel.vehicleTypes,
        dropdownValue: viewModel.selectedVehicleType,
        onDropdownChanged: (value) {
          viewModel.updateVehicleType(value);
        },
      ),
      SizedBox(height: context.spacingL),
      AppInput.dropdown(
        labelText: 'Year',
        hintText: 'Select year...',
        dropdownItems: VehicleRegistrationViewModel.yearOptions,
        dropdownValue: viewModel.selectedYear,
        onDropdownChanged: (value) {
          viewModel.updateYear(value);
        },
      ),
      SizedBox(height: context.spacingL),
      AppInput.dropdown(
        labelText: 'Capacity',
        hintText: 'Select capacity...',
        dropdownItems: VehicleRegistrationViewModel.capacityOptions,
        dropdownValue: viewModel.selectedCapacity,
        onDropdownChanged: (value) {
          viewModel.updateCapacity(value);
        },
      ),
    ],
  );
}

/// Builds the vehicle category section for classification
Widget _buildCategorySection(
  VehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return _buildSection(
    title: 'Vehicle Category',
    children: [
      AppInput.dropdown(
        labelText: 'Vehicle Category',
        hintText: 'Select category...',
        dropdownItems: VehicleRegistrationViewModel.categoryOptions,
        dropdownValue: viewModel.selectedCategory,
        onDropdownChanged: (value) {
          viewModel.setCategory(value);
        },
      ),
    ],
  );
}

/// Builds the document status section for insurance, license, and inspection
Widget _buildDocumentSection(
  VehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return _buildSection(
    title: 'Document Status',
    children: [
      AppInfoCard(
        icon: Icons.security,
        label: 'Insurance',
        value:
            viewModel.selectedInsuranceStatus == 'Valid'
                ? 'Approved'
                : 'Not Uploaded',
        valueColor:
            viewModel.selectedInsuranceStatus == 'Valid'
                ? Colors.green
                : Colors.red,
        onTap: () => _navigateToDocumentUpload(context, 'insurance'),
      ),
      SizedBox(height: context.spacingL),
      AppInfoCard(
        icon: Icons.description,
        label: 'Registration',
        value:
            viewModel.selectedLicenseStatus == 'Valid'
                ? 'Approved'
                : 'Not Uploaded',
        valueColor:
            viewModel.selectedLicenseStatus == 'Valid'
                ? Colors.green
                : Colors.red,
        onTap: () => _navigateToDocumentUpload(context, 'registration'),
      ),
      SizedBox(height: context.spacingL),
      AppInfoCard(
        icon: Icons.verified,
        label: 'Inspection',
        value:
            viewModel.selectedInspectionStatus == 'Valid'
                ? 'Approved'
                : 'Not Uploaded',
        valueColor:
            viewModel.selectedInspectionStatus == 'Valid'
                ? Colors.green
                : Colors.red,
        onTap: () => _navigateToDocumentUpload(context, 'inspection'),
      ),
    ],
  );
}

/// Builds the register vehicle button
Widget _buildRegisterButton(
  VehicleRegistrationViewModel viewModel,
  BuildContext context,
) {
  return Container(
    width: double.infinity,
    padding: context.horizontalL,
    child: AppButton.primary(
      'Register Vehicle',
      onPressed: () async {
        final success = await viewModel.registerVehicle(context);
        if (success) {
          viewModel.clearForm();
        }
      },
      icon: Icons.add_circle,
      height: 52,
    ),
  );
}

/// Builds a section with title and children widgets
Widget _buildSection({required String title, required List<Widget> children}) {
  return Builder(
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: context.spacingM), // Top margin eklendi
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
              _buildSectionHeader(context, title),
              SizedBox(height: context.spacingL),
              ...children,
            ],
          ),
        ),
      );
    },
  );
}

/// Builds the section header with title only
Widget _buildSectionHeader(BuildContext context, String title) {
  return AppText.heading(title, color: context.onSurface);
}

/// Navigate to document upload page
void _navigateToDocumentUpload(BuildContext context, String documentType) {
  // Map document type to DocumentUploadPurpose
  DocumentUploadPurpose purpose;
  if (documentType == 'profile_photo') {
    purpose = DocumentUploadPurpose.profilePhoto;
  } else {
    purpose = DocumentUploadPurpose.driverLicense;
  }
  
  Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (context) => DocumentUploadView(
            purpose: purpose,
            vehiclePlate: 'New Vehicle',
          ),
    ),
  );
}
