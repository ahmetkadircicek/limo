import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/constants/general_constants.dart'
    show GeneralConstants;
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:limo/shared/app_text.dart';

class VehicleManagementView extends StatefulWidget {
  const VehicleManagementView({super.key});

  @override
  State<VehicleManagementView> createState() => _VehicleManagementViewState();
}

class _VehicleManagementViewState extends State<VehicleManagementView> {
  List<VehicleModel> _vehicles = [];
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();

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

  /// Load vehicles from data source - mock data removed
  Future<void> _loadVehicles() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Mock data loading removed - implement real API call here
      debugPrint(
          'VehicleManagementView: Mock data loading removed - implement real API call');

      setState(() {
        _vehicles = [];
      });
    } catch (e) {
      debugPrint('Error loading vehicles: $e');
      _showErrorSnackBar('Error loading vehicles: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Refresh the vehicle list
  Future<void> _refreshVehicles() async {
    await _loadVehicles();
    _showSuccessSnackBar('Vehicle list updated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      body: _isLoading ? _buildLoadingState() : _buildScrollableMainContent(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.primary,
          ),
          SizedBox(height: PaddingConstants.spacingL),
          AppText.body(
            'Loading vehicles...',
            color: context.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  /// The whole page is scrollable, including header and list.
  Widget _buildScrollableMainContent() {
    return RefreshIndicator(
      onRefresh: _refreshVehicles,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeaderSection()),
          if (_vehicles.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(),
            )
          else
            SliverPadding(
              padding:
                  EdgeInsets.symmetric(horizontal: PaddingConstants.spacingL),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final vehicle = _vehicles[index];
                    return _buildVehicleCard(vehicle, index);
                  },
                  childCount: _vehicles.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return _FramedContainer(
      margin: PaddingConstants.allL,
      padding: EdgeInsets.all(PaddingConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main header row
          Row(
            children: [
              // Left side with title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main title with icon
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(PaddingConstants.spacingS),
                          decoration: BoxDecoration(
                            color: context.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                DesignTokens.radiusMedium),
                          ),
                          child: Icon(
                            Icons.directions_car,
                            size: 24,
                            color: context.primary,
                          ),
                        ),
                        SizedBox(width: PaddingConstants.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.heading(
                                'My Vehicles',
                                color: context.onSurface,
                              ),
                              AppText.bodySmall(
                                '${_vehicles.length} vehicles in your fleet',
                                color: context.onSurface.withValues(alpha: 0.6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right side with add button
              Container(
                decoration: BoxDecoration(
                  color: context.primary,
                  borderRadius: GeneralConstants.borderRadiusRound,
                ),
                child: InkWell(
                  onTap: _addNewVehicle,
                  borderRadius: GeneralConstants.borderRadiusRound,
                  child: Padding(
                    padding: PaddingConstants.allS,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: context.surface,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 64,
            color: context.onSurface.withValues(alpha: 0.5),
          ),
          SizedBox(height: PaddingConstants.spacingL),
          AppText.heading(
            'No vehicles added yet',
            color: context.onSurface.withValues(alpha: 0.7),
          ),
          SizedBox(height: PaddingConstants.spacingS),
          AppText.bodySmall(
            'Add your first vehicle to start accepting jobs',
            color: context.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(VehicleModel vehicle, int index) {
    return _FramedContainer(
      margin: EdgeInsets.only(bottom: PaddingConstants.spacingM),
      borderColor: vehicle.category.borderColor.withValues(alpha: 0.2),
      boxShadow: DesignTokens.elevationLow,
      child: Padding(
        padding: PaddingConstants.allL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with category badge and action buttons
            Row(
              children: [
                // Category badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        PaddingConstants.spacingS + PaddingConstants.spacingXs,
                    vertical: PaddingConstants.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: vehicle.category.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: vehicle.category.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        vehicle.category.icon,
                        size: 30,
                        color: vehicle.category.primaryColor,
                      ),
                      SizedBox(width: PaddingConstants.spacingS),
                      AppText.caption(
                        vehicle.category.badgeText,
                        color: vehicle.category.primaryColor,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      color: context.primary,
                      onTap: () => _editVehicle(vehicle),
                      tooltip: 'Edit',
                    ),
                    SizedBox(width: PaddingConstants.spacingXs),
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      color: context.error,
                      onTap: () => _deleteVehicle(index),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: PaddingConstants.spacingL),

            // Vehicle information grid
            Row(
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        icon: Icons.confirmation_number,
                        label: 'License Plate',
                        value: vehicle.licencePlate,
                        color: context.primary,
                      ),
                      SizedBox(height: PaddingConstants.spacingM),
                      _buildInfoRow(
                        icon: Icons.branding_watermark,
                        label: 'Brand & Model',
                        value: '${vehicle.brand} ${vehicle.model}',
                        color: context.onSurface,
                      ),
                      SizedBox(height: PaddingConstants.spacingM),
                      _buildInfoRow(
                        icon: Icons.category,
                        label: 'Category',
                        value: vehicle.category.displayName,
                        color: vehicle.category.primaryColor,
                      ),
                    ],
                  ),
                ),

                // Right column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        icon: Icons.people,
                        label: 'Capacity',
                        value: '${vehicle.capacity} people',
                        color: context.primary,
                      ),
                      SizedBox(height: PaddingConstants.spacingM),
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Year',
                        value: vehicle.year.toString(),
                        color: context.primary,
                      ),
                      SizedBox(height: PaddingConstants.spacingM),
                      _buildInfoRow(
                        icon: Icons.palette,
                        label: 'Colors',
                        value:
                            '${vehicle.exteriorColor} / ${vehicle.interiorColor}',
                        color: context.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.onSurface.withValues(alpha: 0.7),
        ),
        SizedBox(width: PaddingConstants.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.caption(
                label,
                color: context.onSurface.withValues(alpha: 0.5),
              ),
              AppText.bodySmall(
                value,
                color: context.onSurface,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: PaddingConstants.spacingM,
              vertical: PaddingConstants.spacingS,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  void _addNewVehicle() {
    debugPrint("Navigation to Vehicle Registration from Vehicle Management");
    context.push('/vehicle-registration').then((_) {
      _loadVehicles();
    });
  }

  void _editVehicle(VehicleModel vehicle) {
    debugPrint(
        "Navigation to Vehicle Registration (Edit) from Vehicle Management");
    context.push('/vehicle-registration', extra: vehicle).then((_) {
      _loadVehicles();
    });
  }

  void _deleteVehicle(int index) {
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
              onPressed: () => context.pop(),
              child: const AppText.body('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                _confirmDeleteVehicle(index);
              },
              style: TextButton.styleFrom(
                foregroundColor: context.error,
              ),
              child: const AppText.body('Delete'),
            ),
          ],
        );
      },
    );
  }

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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText.body(message),
        backgroundColor: context.success,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: PaddingConstants.spacingL,
          left: PaddingConstants.spacingL,
          right: PaddingConstants.spacingL,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        dismissDirection: DismissDirection.up,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText.body(message),
        backgroundColor: context.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: PaddingConstants.spacingL,
          left: PaddingConstants.spacingL,
          right: PaddingConstants.spacingL,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        dismissDirection: DismissDirection.up,
      ),
    );
  }
}

/// Universal frame widget for all cards/sections
class _FramedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const _FramedContainer({
    required this.child,
    this.margin,
    this.padding,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
          width: 1.0,
        ),
        boxShadow: boxShadow ?? DesignTokens.elevationLow,
      ),
      child: child,
    );
  }
}
