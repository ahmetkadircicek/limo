import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/fleet_vehicle_registration/widgets/fleet_vehicle_registration_widget.dart';
import 'package:limo/feature/job_vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';

/// Fleet vehicle registration view for adding/editing vehicles
class FleetVehicleRegistrationView extends StatelessWidget {
  final VehicleModel? vehicleToEdit;

  const FleetVehicleRegistrationView({super.key, this.vehicleToEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppAppBar.secondary(
      title:
          vehicleToEdit != null ? 'Edit Fleet Vehicle' : 'Add Vehicle to Fleet',
    );
  }

  /// Build body
  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.spacing4),
        child: FleetVehicleRegistrationWidget(
          vehicleToEdit: vehicleToEdit,
          onSuccess: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
