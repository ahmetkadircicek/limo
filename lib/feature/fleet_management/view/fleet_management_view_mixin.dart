import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/fleet_vehicle_registration/view/fleet_vehicle_registration_view.dart';
import 'package:limo/feature/job_vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';

/// Mixin for FleetManagementView to separate business logic
mixin FleetManagementViewMixin<T extends StatefulWidget> on State<T> {
  List<VehicleModel> _vehicles = [];
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  // Getters
  List<VehicleModel> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  ScrollController get scrollController => _scrollController;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Load vehicles from data source
  Future<void> _loadVehicles() async {
    try {
      setState(() => _isLoading = true);

      // TODO: Implement real API call to load vehicles
      // For now, vehicles list remains empty

      setState(() => _vehicles = []);
    } catch (e) {
      _showErrorSnackBar('Error loading vehicles: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Refresh the vehicle list
  Future<void> refreshVehicles() async {
    await _loadVehicles();
    _showSuccessSnackBar('Vehicle list updated');
  }

  /// Add new vehicle
  void addNewVehicle() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => const FleetVehicleRegistrationView(),
          ),
        )
        .then((_) {
          // Reload vehicles when returning from form page
          _loadVehicles();
        });
  }

  /// Edit existing vehicle
  void editVehicle(VehicleModel vehicle) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder:
                (context) =>
                    FleetVehicleRegistrationView(vehicleToEdit: vehicle),
          ),
        )
        .then((_) {
          // Reload vehicles when returning from form page
          _loadVehicles();
        });
  }

  /// Delete vehicle
  void deleteVehicle(int index) {
    final vehicle = _vehicles[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AppText.heading('Delete Vehicle'),
          content: AppText.body(
            'Are you sure you want to delete ${vehicle.licencePlate}?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const AppText.body('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeleteVehicle(index);
              },
              style: TextButton.styleFrom(foregroundColor: context.error),
              child: const AppText.body('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Confirm vehicle deletion
  void _confirmDeleteVehicle(int index) {
    final vehicle = _vehicles[index];

    try {
      setState(() {
        _vehicles.removeAt(index);
      });

      _showSuccessSnackBar('${vehicle.licencePlate} successfully deleted');
    } catch (e) {
      _showErrorSnackBar('Error deleting vehicle: $e');
      _loadVehicles(); // Reload to restore state
    }
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    AppSnackbar.showSuccess(context, message: message);
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    AppSnackbar.showError(context, message: message);
  }
}
