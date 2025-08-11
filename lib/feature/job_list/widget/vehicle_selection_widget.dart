import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';

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
    // Filter vehicles that can handle this job
    final eligibleVehicles = _getEligibleVehicles();

    if (eligibleVehicles.isEmpty) {
      return _buildNoEligibleVehiclesCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(eligibleVehicles),
        const SizedBox(height: 16),
        _buildVehicleList(eligibleVehicles),
        if (_selectedVehicle != null) ...[
          const SizedBox(height: 16),
          _buildSelectedVehicleCard(),
        ],
      ],
    );
  }

  Widget _buildHeader(List<VehicleModel> eligibleVehicles) {
    return Row(
      children: [
        Container(
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
        ),
        const SizedBox(width: 12),
        Text(
          'Uygun Araçlarınız',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.onSurface,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${eligibleVehicles.length} araç',
            style: TextStyle(
              color: context.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoEligibleVehiclesCard() {
    // Get ineligible vehicles and their upgrade information
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
          Icon(
            Icons.warning_amber_rounded,
            color: context.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Uygun Araç Bulunamadı',
            style: TextStyle(
              color: context.error,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu iş için uygun kategoride araç bulunmuyor. Araç kategorinizi yükseltmeyi düşünebilirsiniz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.error.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          if (ineligibleVehicles.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildUpgradeSuggestions(ineligibleVehicles),
          ],
        ],
      ),
    );
  }

  Widget _buildUpgradeSuggestions(
      List<Map<String, dynamic>> ineligibleVehicles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Yükseltme Önerileri:',
          style: TextStyle(
            color: context.error,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...ineligibleVehicles.map((vehicleInfo) {
          final vehicle = vehicleInfo['vehicle'] as VehicleModel;
          final eligibility =
              vehicleInfo['eligibility'] as Map<String, dynamic>;

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
                Row(
                  children: [
                    Text(
                      '${vehicle.brand} ${vehicle.model}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        vehicle.category.displayName,
                        style: TextStyle(
                          color: context.secondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Gerekli: ${eligibility['requiredCategory']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                if (eligibility['canUpgrade'] == true) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: const Color(0xFF10B981),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Yükseltme mümkün',
                        style: TextStyle(
                          color: const Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (eligibility['estimatedCost'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Tahmini maliyet: \$${eligibility['estimatedCost'].toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: context.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVehicleList(List<VehicleModel> eligibleVehicles) {
    return Column(
      children: eligibleVehicles.map((vehicle) {
        final requirement = _getBestMatchingRequirement(vehicle);
        final isSelected =
            _selectedVehicle?.licencePlate == vehicle.licencePlate;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildVehicleCard(vehicle, requirement, isSelected),
        );
      }).toList(),
    );
  }

  Widget _buildVehicleCard(
      VehicleModel vehicle, VehicleRequirement? requirement, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectVehicle(vehicle, requirement),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primary.withValues(alpha: 0.1)
              : Colors.white,
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Vehicle icon
                Container(
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
                ),
                const SizedBox(width: 12),

                // Vehicle info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle.brand} ${vehicle.model}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vehicle.year} • ${vehicle.capacity} kişi • ${vehicle.licencePlate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: context.primary,
                    size: 24,
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Category and pricing info
            Row(
              children: [
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    vehicle.category.displayName,
                    style: TextStyle(
                      color: context.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Category compatibility indicator
                if (requirement?.minimumCategory != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: vehicle.category
                              .canApplyToJob(requirement!.minimumCategory!)
                          ? const Color(0xFF10B981).withValues(alpha: 0.1)
                          : context.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      vehicle.category
                              .canApplyToJob(requirement.minimumCategory!)
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: vehicle.category
                              .canApplyToJob(requirement.minimumCategory!)
                          ? const Color(0xFF10B981)
                          : context.error,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Pricing info
                if (requirement != null) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        requirement.getPricingSummary(),
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // Category upgrade suggestion (if applicable)
            if (requirement?.minimumCategory != null &&
                vehicle.category
                    .canUpgradeToCategory(requirement!.minimumCategory!)) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: const Color(0xFFF59E0B),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Bu araç ${requirement.minimumCategory!.displayName} kategorisine yükseltilebilir',
                        style: TextStyle(
                          color: const Color(0xFFF59E0B),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedVehicleCard() {
    if (_selectedVehicle == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: context.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Seçilen Araç',
                style: TextStyle(
                  color: context.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${_selectedVehicle!.brand} ${_selectedVehicle!.model} (${_selectedVehicle!.licencePlate})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.onSurface,
            ),
          ),
          if (_selectedRequirement != null) ...[
            const SizedBox(height: 8),
            _buildCategoryCompatibilityInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryCompatibilityInfo() {
    if (_selectedVehicle == null || _selectedRequirement == null) {
      return const SizedBox.shrink();
    }

    final requirement = _selectedRequirement!;
    final vehicle = _selectedVehicle!;

    if (requirement.minimumCategory == null) {
      return Text(
        'Kategori gereksinimi belirtilmemiş',
        style: TextStyle(
          fontSize: 14,
          color: context.onSurface.withValues(alpha: 0.7),
        ),
      );
    }

    final isCompatible =
        vehicle.category.canApplyToJob(requirement.minimumCategory!);
    final canUpgrade =
        vehicle.category.canUpgradeToCategory(requirement.minimumCategory!);
    final upgradePath = vehicle.getUpgradePath(requirement.minimumCategory!);
    final estimatedCost =
        vehicle.getUpgradeCostEstimate(requirement.minimumCategory!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isCompatible ? Icons.check_circle : Icons.info,
              color: isCompatible
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              isCompatible ? 'Kategori uyumlu' : 'Kategori uyumsuz',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isCompatible
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Mevcut: ${vehicle.category.displayName} (${vehicle.category.levelDescription})',
          style: TextStyle(
            fontSize: 12,
            color: context.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          'Gerekli: ${requirement.minimumCategory!.displayName} (${requirement.minimumCategory!.levelDescription})',
          style: TextStyle(
            fontSize: 12,
            color: context.onSurface.withValues(alpha: 0.7),
          ),
        ),
        if (canUpgrade && upgradePath.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: const Color(0xFFF59E0B),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Yükseltme Yolu:',
                      style: TextStyle(
                        color: const Color(0xFFF59E0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  upgradePath.map((cat) => cat.displayName).join(' → '),
                  style: TextStyle(
                    color: const Color(0xFFF59E0B),
                    fontSize: 11,
                  ),
                ),
                if (estimatedCost != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Tahmini maliyet: \$${estimatedCost.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: const Color(0xFFF59E0B),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<VehicleModel> _getEligibleVehicles() {
    final eligibleVehicles = <VehicleModel>[];

    for (final vehicle in widget.availableVehicles) {
      for (final requirement in widget.job.vehicleRequirements) {
        if (requirement.matchesVehicle(vehicle)) {
          eligibleVehicles.add(vehicle);
          break;
        }
      }
    }

    // Sort by category ID (highest first)
    eligibleVehicles.sort((a, b) => b.category.id.compareTo(a.category.id));

    return eligibleVehicles;
  }

  VehicleRequirement? _getBestMatchingRequirement(VehicleModel vehicle) {
    VehicleRequirement? bestMatch;
    int? bestCategoryId;

    for (final requirement in widget.job.vehicleRequirements) {
      if (requirement.matchesVehicle(vehicle)) {
        final categoryId = requirement.minimumCategory?.id ?? 0;
        if (bestMatch == null || categoryId > (bestCategoryId ?? 0)) {
          bestMatch = requirement;
          bestCategoryId = categoryId;
        }
      }
    }

    return bestMatch;
  }

  List<Map<String, dynamic>> _getIneligibleVehiclesWithUpgradeInfo() {
    final ineligibleVehicles = <Map<String, dynamic>>[];

    for (final vehicle in widget.availableVehicles) {
      bool isEligibleForAnyRequirement = false;

      for (final requirement in widget.job.vehicleRequirements) {
        if (requirement.matchesVehicle(vehicle)) {
          isEligibleForAnyRequirement = true;
          break;
        }
      }

      if (!isEligibleForAnyRequirement) {
        // Find the highest category requirement to show upgrade path
        VehicleRequirement? highestRequirement;
        int? highestCategoryId;

        for (final requirement in widget.job.vehicleRequirements) {
          if (requirement.minimumCategory != null) {
            final categoryId = requirement.minimumCategory!.id;
            if (highestRequirement == null ||
                categoryId > (highestCategoryId ?? 0)) {
              highestRequirement = requirement;
              highestCategoryId = categoryId;
            }
          }
        }

        if (highestRequirement != null) {
          final eligibility =
              vehicle.getJobEligibilitySummary(highestRequirement);
          ineligibleVehicles.add({
            'vehicle': vehicle,
            'eligibility': eligibility,
          });
        }
      }
    }

    return ineligibleVehicles;
  }

  void _selectVehicle(VehicleModel vehicle, VehicleRequirement? requirement) {
    setState(() {
      _selectedVehicle = vehicle;
      _selectedRequirement = requirement;
    });

    widget.onVehicleSelected(vehicle, requirement);
  }
}
