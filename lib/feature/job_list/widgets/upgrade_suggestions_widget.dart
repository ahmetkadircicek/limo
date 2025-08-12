import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_text.dart';

/// Widget displaying upgrade suggestions for ineligible vehicles
class UpgradeSuggestionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> ineligibleVehicles;

  const UpgradeSuggestionsWidget({
    super.key,
    required this.ineligibleVehicles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 12),
        ...ineligibleVehicles.map((vehicleInfo) {
          final vehicle = vehicleInfo['vehicle'] as VehicleModel;
          final eligibility =
              vehicleInfo['eligibility'] as Map<String, dynamic>;
          return _buildVehicleUpgradeCard(context, vehicle, eligibility);
        }),
      ],
    );
  }

  /// Build the title for upgrade suggestions
  Widget _buildTitle(BuildContext context) {
    return AppText.body(
      'Category Upgrade Suggestions:',
      color: context.error,
    );
  }

  /// Build individual vehicle upgrade card
  Widget _buildVehicleUpgradeCard(
    BuildContext context,
    VehicleModel vehicle,
    Map<String, dynamic> eligibility,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVehicleHeader(context, vehicle),
          const SizedBox(height: 4),
          _buildRequiredCategory(context, eligibility),
          if (eligibility['canUpgrade'] == true) ...[
            const SizedBox(height: 8),
            _buildUpgradeInfo(context, eligibility),
          ],
        ],
      ),
    );
  }

  /// Build vehicle header with brand, model and category
  Widget _buildVehicleHeader(BuildContext context, VehicleModel vehicle) {
    return Row(
      children: [
        AppText.bodySmall(
          '${vehicle.brand} ${vehicle.model}',
        ),
        const SizedBox(width: 8),
        _buildCategoryBadge(vehicle),
      ],
    );
  }

  /// Build category badge for vehicle
  Widget _buildCategoryBadge(VehicleModel vehicle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: vehicle.category.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: vehicle.category.borderColorV2,
          width: 1,
        ),
      ),
      child: AppText.caption(
        vehicle.category.displayName,
        color: vehicle.category.primaryColor,
      ),
    );
  }

  /// Build required category information
  Widget _buildRequiredCategory(
      BuildContext context, Map<String, dynamic> eligibility) {
    return AppText.caption(
      'Required: ${eligibility['requiredCategory']}',
      color: context.onSurface.withValues(alpha: 0.7),
    );
  }

  /// Build upgrade information section
  Widget _buildUpgradeInfo(
      BuildContext context, Map<String, dynamic> eligibility) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUpgradePossibleRow(),
        if (eligibility['estimatedCost'] != null) ...[
          const SizedBox(height: 4),
          _buildEstimatedCost(context, eligibility),
        ],
      ],
    );
  }

  /// Build upgrade possible indicator row
  Widget _buildUpgradePossibleRow() {
    return Row(
      children: [
        Icon(
          Icons.trending_up,
          color: const Color(0xFF10B981),
          size: 16,
        ),
        const SizedBox(width: 4),
        AppText.caption(
          'Upgrade possible',
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }

  /// Build estimated cost display
  Widget _buildEstimatedCost(
      BuildContext context, Map<String, dynamic> eligibility) {
    return AppText.caption(
      'Estimated cost: \$${eligibility['estimatedCost'].toStringAsFixed(0)}',
      color: context.onSurface.withValues(alpha: 0.6),
    );
  }
}
