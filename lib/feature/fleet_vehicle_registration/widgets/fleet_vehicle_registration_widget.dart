import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/fleet_vehicle_registration/viewmodel/fleet_vehicle_registration_view_model.dart';
import 'package:limo/feature/job_vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

/// Fleet vehicle registration form widget for adding/editing vehicles
class FleetVehicleRegistrationWidget extends StatefulWidget {
  final VehicleModel? vehicleToEdit;
  final VoidCallback? onSuccess;

  const FleetVehicleRegistrationWidget({
    super.key,
    this.vehicleToEdit,
    this.onSuccess,
  });

  @override
  State<FleetVehicleRegistrationWidget> createState() =>
      _FleetVehicleRegistrationWidgetState();
}

class _FleetVehicleRegistrationWidgetState
    extends State<FleetVehicleRegistrationWidget> {
  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing
    if (widget.vehicleToEdit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FleetVehicleRegistrationViewModel>().initializeForEdit(
          widget.vehicleToEdit!,
        );
      });
    }
  }

  @override
  void dispose() {
    // Reset form when leaving the page
    final viewModel = context.read<FleetVehicleRegistrationViewModel>();
    viewModel.resetForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FleetVehicleRegistrationViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: context.paddingL,
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: context.radiusMedium,
          ),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildVehicleInfoSection(context, viewModel),
                SizedBox(height: DesignTokens.spacing4),
                _buildSpecificationsSection(context, viewModel),
                SizedBox(height: DesignTokens.spacing6),
                _buildSubmitButton(context, viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build vehicle info section
  Widget _buildVehicleInfoSection(
    BuildContext context,
    FleetVehicleRegistrationViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.heading('Vehicle Information'),
        SizedBox(height: DesignTokens.spacing3),
        AppInput.primary(
          controller: viewModel.plateNumberController,
          labelText: 'License Plate',
          hintText: 'ABC-1234',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'License plate is required';
            }
            return null;
          },
        ),
        SizedBox(height: DesignTokens.spacing3),
        AppInput.dropdown(
          labelText: 'Brand',
          hintText: 'Select vehicle brand',
          dropdownValue: viewModel.selectedBrand,
          dropdownItems: viewModel.brandOptions,
          onDropdownChanged: viewModel.setSelectedBrand,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Brand is required';
            }
            return null;
          },
        ),
        SizedBox(height: DesignTokens.spacing3),
        AppInput.primary(
          controller: viewModel.modelController,
          labelText: 'Model',
          hintText: 'Camry, E-Class, Transit...',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Model is required';
            }
            return null;
          },
        ),
        SizedBox(height: DesignTokens.spacing3),
        AppInput.dropdown(
          labelText: 'Model Year',
          hintText: 'Select manufacturing year',
          dropdownValue: viewModel.selectedModelYear?.toString(),
          dropdownItems:
              viewModel.modelYearOptions
                  .map((year) => year.toString())
                  .toList(),
          onDropdownChanged: (value) {
            viewModel.setSelectedModelYear(
              value != null ? int.tryParse(value) : null,
            );
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Model year is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Build specifications section
  Widget _buildSpecificationsSection(
    BuildContext context,
    FleetVehicleRegistrationViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.heading('Vehicle Specifications'),
        SizedBox(height: DesignTokens.spacing3),
        AppInput.dropdown(
          labelText: 'Capacity',
          hintText: 'Select passenger capacity',
          dropdownValue:
              viewModel.selectedCapacity != null
                  ? '${viewModel.selectedCapacity} passengers'
                  : null,
          dropdownItems:
              viewModel.capacityOptions
                  .map((capacity) => '$capacity passengers')
                  .toList(),
          onDropdownChanged: (value) {
            if (value != null) {
              // Extract number from "X passengers" format
              final capacity = int.tryParse(value.split(' ').first);
              viewModel.setSelectedCapacity(capacity);
            } else {
              viewModel.setSelectedCapacity(null);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Capacity is required';
            }
            return null;
          },
        ),
        SizedBox(height: DesignTokens.spacing3),
        AppInput.dropdown(
          labelText: 'Body Type',
          hintText: 'Select vehicle body type',
          dropdownValue: viewModel.selectedBodyType,
          dropdownItems: viewModel.bodyTypeOptions,
          onDropdownChanged: viewModel.setSelectedBodyType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Body type is required';
            }
            return null;
          },
        ),
        SizedBox(height: DesignTokens.spacing3),
        AppInput.dropdown(
          labelText: 'Category',
          hintText: 'Select vehicle category',
          dropdownValue: viewModel.selectedCategory,
          dropdownItems: viewModel.categoryOptions,
          onDropdownChanged: viewModel.setSelectedCategory,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Category is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Build submit button
  Widget _buildSubmitButton(
    BuildContext context,
    FleetVehicleRegistrationViewModel viewModel,
  ) {
    return AppButton(
      widget.vehicleToEdit == null ? 'Add to Fleet' : 'Update Vehicle',
      isLoading: viewModel.isLoading,
      onPressed: viewModel.isLoading ? null : () => _handleSubmit(viewModel),
    );
  }

  /// Handle form submission
  Future<void> _handleSubmit(
    FleetVehicleRegistrationViewModel viewModel,
  ) async {
    final success = await viewModel.submitVehicle();

    if (success && mounted) {
      AppSnackbar.showSuccess(
        context,
        message:
            widget.vehicleToEdit == null
                ? 'Vehicle added to fleet successfully!'
                : 'Vehicle updated successfully!',
      );
      widget.onSuccess?.call();
    } else if (mounted) {
      AppSnackbar.showError(
        context,
        message: 'Failed to save vehicle. Please try again.',
      );
    }
  }
}
