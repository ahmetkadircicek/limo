import 'package:flutter/material.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/job_list/widgets/upgrade_suggestions_widget.dart';
import 'package:limo/feature/job_list/widgets/vehicle_card_widget.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/shared/app_text.dart';

/// Main widget for vehicle selection in job applications
class VehicleSelectionWidget extends StatefulWidget {
  final JobModel job;
  final List<VehicleModel> availableVehicles;
  final Function(VehicleModel selectedVehicle, VehicleRequirement? requirement)
      onVehicleSelected;

  const VehicleSelectionWidget({
    super.key,
    required this.job,
    required this.availableVehicles,
    required this.onVehicleSelected,
  });

  @override
  State<VehicleSelectionWidget> createState() => _VehicleSelectionWidgetState();
}

class _VehicleSelectionWidgetState extends State<VehicleSelectionWidget> {
  VehicleModel? _selectedVehicle;
  VehicleRequirement? _selectedRequirement;

  @override
  Widget build(BuildContext context) {
    final eligibleVehicles = _getEligibleVehicles();

    if (eligibleVehicles.isEmpty) {
      return _buildNoEligibleVehiclesCard(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, eligibleVehicles),
        const SizedBox(height: 16),
        _buildVehicleList(context, eligibleVehicles),
        if (_selectedVehicle != null) ...[
          const SizedBox(height: 16),
          _buildSelectedVehicleCard(context),
        ],
      ],
    );
  }

  /// Build the header section with vehicle count
  Widget _buildHeader(
      BuildContext context, List<VehicleModel> eligibleVehicles) {
    return Row(
      children: [
        _buildHeaderIcon(context),
        const SizedBox(width: 12),
        _buildHeaderTitle(context),
        const SizedBox(width: 8),
        _buildVehicleCountBadge(context, eligibleVehicles.length),
      ],
    );
  }

  /// Build the header icon container
  Widget _buildHeaderIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.directions_car,
        color: context.primary,
        size: 20,
      ),
    );
  }

  /// Build the header title text
  Widget _buildHeaderTitle(BuildContext context) {
    return AppText.body(
      'Your Eligible Vehicles',
      color: context.onSurface,
    );
  }

  /// Build the vehicle count badge
  Widget _buildVehicleCountBadge(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText.caption(
        '$count vehicles',
        color: context.secondary,
      ),
    );
  }

  /// Build the no eligible vehicles card
  Widget _buildNoEligibleVehiclesCard(BuildContext context) {
    final ineligibleVehicles = _getIneligibleVehiclesWithUpgradeInfo();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildNoVehiclesIcon(context),
          const SizedBox(height: 16),
          _buildNoVehiclesTitle(context),
          const SizedBox(height: 8),
          _buildNoVehiclesDescription(context),
          if (ineligibleVehicles.isNotEmpty) ...[
            const SizedBox(height: 16),
            UpgradeSuggestionsWidget(ineligibleVehicles: ineligibleVehicles),
          ],
        ],
      ),
    );
  }

  /// Build the no vehicles warning icon
  Widget _buildNoVehiclesIcon(BuildContext context) {
    return Icon(
      Icons.warning_amber_rounded,
      color: context.error,
      size: 48,
    );
  }

  /// Build the no vehicles title
  Widget _buildNoVehiclesTitle(BuildContext context) {
    return AppText.body(
      'No Eligible Vehicle Found',
      color: context.error,
    );
  }

  /// Build the no vehicles description
  Widget _buildNoVehiclesDescription(BuildContext context) {
    return AppText.bodySmall(
      'No vehicle in the appropriate category found for this job. You may consider upgrading your vehicle category.',
      color: context.error.withValues(alpha: 0.8),
    );
  }

  /// Build the vehicle list
  Widget _buildVehicleList(
      BuildContext context, List<VehicleModel> eligibleVehicles) {
    return Column(
      children: eligibleVehicles.map((vehicle) {
        final requirement = _getBestMatchingRequirement(vehicle);
        final isSelected =
            _selectedVehicle?.licencePlate == vehicle.licencePlate;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: VehicleCardWidget(
            vehicle: vehicle,
            requirement: requirement,
            isSelected: isSelected,
            onTap: () => _selectVehicle(vehicle, requirement),
          ),
        );
      }).toList(),
    );
  }

  /// Build the selected vehicle card
  Widget _buildSelectedVehicleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.secondary,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: context.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              AppText.body(
                'Selected Vehicle',
                color: context.secondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText.bodySmall(
            '${_selectedVehicle!.brand} ${_selectedVehicle!.model}',
            color: context.onSurface,
          ),
          if (_selectedRequirement != null) ...[
            const SizedBox(height: 4),
            AppText.caption(
              'Requirement: ${_selectedRequirement!.notes ?? 'Specific requirement'}',
              color: context.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );
  }

  /// Select a vehicle and notify parent
  void _selectVehicle(VehicleModel vehicle, VehicleRequirement? requirement) {
    setState(() {
      _selectedVehicle = vehicle;
      _selectedRequirement = requirement;
    });
    widget.onVehicleSelected(vehicle, requirement);
  }

  /// Get vehicles that can handle this job
  List<VehicleModel> _getEligibleVehicles() {
    return widget.availableVehicles.where((vehicle) {
      // Check if vehicle matches any of the job requirements
      for (final requirement in widget.job.vehicleRequirements) {
        if (requirement.matchesVehicle(vehicle)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  /// Get ineligible vehicles with upgrade information
  List<Map<String, dynamic>> _getIneligibleVehiclesWithUpgradeInfo() {
    final ineligibleVehicles = widget.availableVehicles.where((vehicle) {
      // Check if vehicle matches any of the job requirements
      for (final requirement in widget.job.vehicleRequirements) {
        if (requirement.matchesVehicle(vehicle)) {
          return false; // Vehicle is eligible
        }
      }
      return true; // Vehicle is ineligible
    }).toList();

    return ineligibleVehicles.map((vehicle) {
      // Find the highest category requirement to show upgrade path
      VehicleCategory? highestRequiredCategory;
      for (final requirement in widget.job.vehicleRequirements) {
        if (requirement.minimumCategory != null) {
          final category = VehicleCategory.fromId(requirement.minimumCategory!);
          if (highestRequiredCategory == null ||
              category.id > highestRequiredCategory.id) {
            highestRequiredCategory = category;
          }
        }
      }

      if (highestRequiredCategory == null) {
        return {
          'vehicle': vehicle,
          'eligibility': {
            'requiredCategory': 'Any category',
            'canUpgrade': false,
            'estimatedCost': null,
          },
        };
      }

      final currentCategory = vehicle.category;
      final canUpgrade = currentCategory.index < highestRequiredCategory.index;
      final estimatedCost = canUpgrade
          ? _estimateUpgradeCost(currentCategory, highestRequiredCategory)
          : null;

      return {
        'vehicle': vehicle,
        'eligibility': {
          'requiredCategory': highestRequiredCategory.displayName,
          'canUpgrade': canUpgrade,
          'estimatedCost': estimatedCost,
        },
      };
    }).toList();
  }

  /// Get the best matching requirement for a vehicle
  VehicleRequirement? _getBestMatchingRequirement(VehicleModel vehicle) {
    if (widget.job.vehicleRequirements.isEmpty) return null;

    // Find the best matching requirement (highest category priority)
    VehicleRequirement? bestMatch;
    int? bestCategoryId;

    for (final requirement in widget.job.vehicleRequirements) {
      if (requirement.matchesVehicle(vehicle)) {
        final categoryId = requirement.minimumCategory ?? 0;
        if (bestMatch == null || categoryId > (bestCategoryId ?? 0)) {
          bestMatch = requirement;
          bestCategoryId = categoryId;
        }
      }
    }

    return bestMatch;
  }

  /// Estimate upgrade cost between categories
  double? _estimateUpgradeCost(
      VehicleCategory current, VehicleCategory required) {
    final categoryIndexDiff = required.index - current.index;
    if (categoryIndexDiff <= 0) return null;

    // Rough estimation: $5000 per category level
    return categoryIndexDiff * 5000.0;
  }
}
