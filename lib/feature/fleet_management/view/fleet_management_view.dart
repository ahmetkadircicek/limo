import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/constants/padding_constants.dart';
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
    return Padding(
      padding: PaddingConstants.allL,
      child: Column(
        spacing: PaddingConstants.spacingXs,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 64,
            color: context.onSurface.withValues(alpha: 0.5),
          ),
          AppText.heading(
            'No vehicles added yet',
            color: context.onSurface.withValues(alpha: 0.7),
          ),
          AppText.bodySmall(
            'Add your first vehicle to start accepting jobs',
            color: context.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  /// Build scrollable main content
  Widget _buildScrollableMainContent() {
    return RefreshIndicator(
      onRefresh: refreshVehicles,
      child: CustomScrollView(
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
      ),
    );
  }

  /// Build add vehicle section
  Widget _buildAddVehicleSection() {
    return Container(
      margin: PaddingConstants.allL,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primary, context.primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: addNewVehicle,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing6,
                vertical: DesignTokens.spacing5,
              ),
              child: Row(
                spacing: DesignTokens.spacing4,
                children: [
                  Icon(
                    Icons.directions_car_filled,
                    color: context.surface,
                    size: 30,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: DesignTokens.spacing1,
                      children: [
                        AppText.body(
                          'Add Vehicle',
                          color: context.surface,
                          fontWeight: FontWeight.w700,
                        ),
                        AppText.bodySmall(
                          'Register new vehicle',
                          color: context.surface.withValues(alpha: 0.85),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: context.surface.withValues(alpha: 0.8),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
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
