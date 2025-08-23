import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';

import 'fleet_management_view_mixin.dart';

/// Fleet management view for listing and managing vehicles
class FleetManagementView extends StatefulWidget {
  const FleetManagementView({super.key});

  @override
  State<FleetManagementView> createState() => _FleetManagementViewState();
}

class _FleetManagementViewState extends State<FleetManagementView>
    with FleetManagementViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      body: isLoading ? _buildLoadingState() : _buildScrollableMainContent(),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: DesignTokens.spacing4,
        children: [
          CircularProgressIndicator(color: context.primary),
          AppText.body(
            'Loading vehicles...',
            color: context.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return const AppEmptyState(
      imagePath: 'assets/png/image/image_car_repair.png',
      title: 'No vehicles added yet',
      description: 'Add your first vehicle to start accepting jobs',
    );
  }

  /// Build scrollable main content
  Widget _buildScrollableMainContent() {
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildAddVehicleSection()),
        if (vehicles.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState())
        else
          SliverPadding(
            padding: EdgeInsets.all(DesignTokens.spacing4),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildVehicleCard(vehicles[index], index),
                childCount: vehicles.length,
              ),
            ),
          ),
      ],
    );
  }

  /// Build add vehicle section
  Widget _buildAddVehicleSection() {
    return Container(
      margin: context.paddingL,
      child: AppCard.primary(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.spacingS,
                children: [
                  AppText.heading('Fleet Management'),
                  AppText.bodySmall(
                    '${vehicles.length} vehicles registered',
                    color: context.textSecondary,
                  ),
                ],
              ),
            ),
            AppButton.chip(
              'Add Vehicle',
              icon: Icons.directions_car_filled,
              onPressed: addNewVehicle,
            ),
          ],
        ),
      ),
    );
  }

  /// Build vehicle card
  Widget _buildVehicleCard(VehicleModel vehicle, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.spacing4),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        border: Border.all(
          color: vehicle.category.borderColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: DesignTokens.spacing4,
          children: [
            Row(
              spacing: DesignTokens.spacing4,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacing3,
                      vertical: DesignTokens.spacing2 - 2,
                    ),
                    decoration: BoxDecoration(
                      color: vehicle.category.backgroundColor,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMedium,
                      ),
                      border: Border.all(
                        color: vehicle.category.borderColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: DesignTokens.spacing2,
                      children: [
                        Icon(
                          vehicle.category.icon,
                          size: 20,
                          color: vehicle.category.primaryColor,
                        ),
                        AppText.body(
                          vehicle.category.displayName,
                          color: vehicle.category.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => editVehicle(vehicle),
                      icon: Icon(Icons.edit, color: context.primary),
                      tooltip: 'Edit vehicle',
                    ),
                    IconButton(
                      onPressed: () => deleteVehicle(index),
                      icon: Icon(Icons.delete, color: context.error),
                      tooltip: 'Delete vehicle',
                    ),
                  ],
                ),
              ],
            ),
            AppText.body(
              '${vehicle.brand} ${vehicle.model}',
              fontWeight: FontWeight.w600,
            ),
            AppText.bodySmall(
              'License: ${vehicle.licencePlate} • Year: ${vehicle.year} • Capacity: ${vehicle.capacity}',
              color: context.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
