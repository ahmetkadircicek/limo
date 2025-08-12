import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_text.dart';

/// Individual vehicle card widget for vehicle selection
class VehicleCardWidget extends StatelessWidget {
  final VehicleModel vehicle;
  final VehicleRequirement? requirement;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleCardWidget({
    super.key,
    required this.vehicle,
    required this.requirement,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _buildCardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehicleHeader(context),
            const SizedBox(height: 12),
            _buildVehicleDetails(context),
            if (requirement != null) ...[
              const SizedBox(height: 8),
              _buildRequirementInfo(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Build the card decoration based on selection state
  BoxDecoration _buildCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: isSelected ? context.primary.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isSelected
            ? context.primary
            : context.onSurface.withValues(alpha: 0.2),
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Build the vehicle header section
  Widget _buildVehicleHeader(BuildContext context) {
    return Row(
      children: [
        _buildVehicleIcon(context),
        const SizedBox(width: 12),
        Expanded(
          child: _buildVehicleInfo(context),
        ),
        _buildSelectionIndicator(context),
      ],
    );
  }

  /// Build the vehicle icon container
  Widget _buildVehicleIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.directions_car,
        color: context.primary,
        size: 24,
      ),
    );
  }

  /// Build the vehicle information section
  Widget _buildVehicleInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.body(
          '${vehicle.brand} ${vehicle.model}',
          color: context.onSurface,
        ),
        const SizedBox(height: 4),
        _buildCategoryBadge(),
      ],
    );
  }

  /// Build the category badge
  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: vehicle.category.backgroundColor,
        borderRadius: BorderRadius.circular(12),
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

  /// Build the selection indicator
  Widget _buildSelectionIndicator(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? context.primary : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? context.primary
              : context.onSurface.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            )
          : null,
    );
  }

  /// Build the vehicle details section
  Widget _buildVehicleDetails(BuildContext context) {
    return Row(
      children: [
        _buildDetailItem(
            context, Icons.confirmation_number, vehicle.licencePlate),
        const SizedBox(width: 16),
        _buildDetailItem(context, Icons.palette, vehicle.exteriorColor),
        const SizedBox(width: 16),
        _buildDetailItem(
            context, Icons.calendar_today, vehicle.year.toString()),
      ],
    );
  }

  /// Build individual detail item
  Widget _buildDetailItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: context.onSecondary,
          size: 16,
        ),
        const SizedBox(width: 4),
        AppText.caption(
          text,
          color: context.onSurface.withValues(alpha: 0.8),
        ),
      ],
    );
  }

  /// Build the requirement information section
  Widget _buildRequirementInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.secondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.secondary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.caption(
              'Requirement: ${requirement!.notes ?? 'Specific vehicle requirement'}',
              color: context.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
