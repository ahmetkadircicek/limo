import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_text.dart';

class MultipleVehicleRequirementsForm extends StatefulWidget {
  final List<VehicleRequirement> initialRequirements;
  final Function(List<VehicleRequirement>) onRequirementsChanged;
  final bool enabled;

  const MultipleVehicleRequirementsForm({
    super.key,
    this.initialRequirements = const [],
    required this.onRequirementsChanged,
    this.enabled = true,
  });

  @override
  State<MultipleVehicleRequirementsForm> createState() =>
      _MultipleVehicleRequirementsFormState();
}

class _MultipleVehicleRequirementsFormState
    extends State<MultipleVehicleRequirementsForm> {
  List<VehicleRequirement> _requirements = [];

  @override
  void initState() {
    super.initState();
    _requirements = List.from(widget.initialRequirements);
    if (_requirements.isEmpty) {
      _requirements.add(VehicleRequirement(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        isFlexible: true,
      ));
    }
  }

  // Show add vehicle requirement page
  void _showAddVehicleRequirement() {
    if (!widget.enabled) return;

    debugPrint(
        "Navigation to Vehicle Requirements (Add) from Multiple Requirements Form");
    context.push('/vehicle-requirements', extra: {
      'onSave': (requirement) {
        setState(() {
          _requirements.add(requirement);
        });
        _notifyChanges();
      },
    });
  }

  // Show edit vehicle requirement page
  void _showEditVehicleRequirement(int index) {
    if (!widget.enabled) return;

    debugPrint(
        "Navigation to Vehicle Requirements (Edit) from Multiple Requirements Form");
    context.push('/vehicle-requirements', extra: {
      'initialRequirement': _requirements[index],
      'onSave': (requirement) {
        setState(() {
          _requirements[index] = requirement;
        });
        _notifyChanges();
      },
    });
  }

  // Remove vehicle requirement at specified index
  void _removeRequirement(int index) {
    if (_requirements.length > 1 && widget.enabled) {
      setState(() {
        _requirements.removeAt(index);
      });
      _notifyChanges();
    }
  }

  // Notify parent about changes
  void _notifyChanges() {
    widget.onRequirementsChanged(_requirements);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vehicle requirements list
        if (_requirements.isNotEmpty) ...[
          ...List.generate(_requirements.length, (index) {
            final requirement = _requirements[index];
            return Container(
              margin: EdgeInsets.only(bottom: PaddingConstants.spacingM),
              child: _buildRequirementCard(requirement, index),
            );
          }),
        ],

        // Add new requirement button
        if (widget.enabled) ...[
          const SizedBox(height: 16),
          _buildAddButton(),
        ],
      ],
    );
  }

  // Build individual requirement card
  Widget _buildRequirementCard(VehicleRequirement requirement, int index) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: GeneralConstants.borderRadius,
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          _buildRequirementHeader(requirement, index),
          if (!requirement.isFlexible) ...[
            const Divider(height: 1),
            _buildRequirementDetails(requirement),
          ],
        ],
      ),
    );
  }

  // Build requirement header with title and actions
  Widget _buildRequirementHeader(VehicleRequirement requirement, int index) {
    return Container(
      color: context.surfaceContainer,
      child: Padding(
        padding: PaddingConstants.allM,
        child: Row(
          children: [
            _buildRequirementIcon(requirement),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRequirementTitle(requirement, index),
            ),
            if (widget.enabled) ...[
              _buildEditButton(index),
              const SizedBox(width: 8),
              _buildRemoveButton(index),
            ],
          ],
        ),
      ),
    );
  }

  // Build requirement icon based on flexibility
  Widget _buildRequirementIcon(VehicleRequirement requirement) {
    return Container(
      padding: PaddingConstants.allS,
      decoration: BoxDecoration(
        color: requirement.isFlexible
            ? context.primary.withValues(alpha: 0.1)
            : context.secondary.withValues(alpha: 0.1),
        borderRadius: GeneralConstants.borderRadius,
      ),
      child: Icon(
        requirement.isFlexible ? Icons.check_circle : Icons.directions_car,
        color: requirement.isFlexible ? context.primary : context.secondary,
        size: 20,
      ),
    );
  }

  // Build requirement title and subtitle
  Widget _buildRequirementTitle(VehicleRequirement requirement, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          'Vehicle Requirement ${index + 1}',
          color: context.onSurface,
        ),
        AppText.bodySmall(
          requirement.isFlexible
              ? 'Flexible Requirements'
              : 'Specific Requirements',
          color: context.onSurface.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  // Build edit button as a custom icon button (icon only, no ActionChip)
  Widget _buildEditButton(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Material(
        color: context.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: context.primary.withValues(alpha: 0.2),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showEditVehicleRequirement(index),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Icon(
                Icons.edit,
                color: context.primary,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build remove button as a custom icon button (icon only, no ActionChip)
  Widget _buildRemoveButton(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Material(
        color: context.error.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: context.error.withOpacity(0.2),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _removeRequirement(index),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Icon(
                Icons.delete,
                color: context.error,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build requirement details for specific requirements
  Widget _buildRequirementDetails(VehicleRequirement requirement) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Brand', requirement.specificBrand ?? 'Any'),
          _buildDetailRow('Type', requirement.specificVehicleType ?? 'Any'),
          _buildDetailRow(
              'Category', requirement.minimumCategory?.name ?? 'Any'),
          if (requirement.minimumCapacity != null ||
              requirement.maximumCapacity != null)
            _buildDetailRow('Capacity', _buildCapacityText(requirement)),
          if (requirement.minimumYear != null ||
              requirement.maximumYear != null)
            _buildDetailRow('Year', _buildYearText(requirement)),
          if (requirement.hourlyRate != null ||
              requirement.pricePerMile != null)
            _buildDetailRow('Pricing', _buildPricingText(requirement)),
        ],
      ),
    );
  }

  // Build detail row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: AppText.bodySmall(
              '$label:',
              color: context.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: AppText.bodySmall(
              value,
              color: context.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // Build capacity text
  String _buildCapacityText(VehicleRequirement requirement) {
    if (requirement.minimumCapacity != null &&
        requirement.maximumCapacity != null) {
      return '${requirement.minimumCapacity} - ${requirement.maximumCapacity} passengers';
    } else if (requirement.minimumCapacity != null) {
      return 'Min ${requirement.minimumCapacity} passengers';
    } else if (requirement.maximumCapacity != null) {
      return 'Max ${requirement.maximumCapacity} passengers';
    }
    return 'Any capacity';
  }

  // Build year text
  String _buildYearText(VehicleRequirement requirement) {
    if (requirement.minimumYear != null && requirement.maximumYear != null) {
      return '${requirement.minimumYear} - ${requirement.maximumYear}';
    } else if (requirement.minimumYear != null) {
      return 'Min ${requirement.minimumYear}';
    } else if (requirement.maximumYear != null) {
      return 'Max ${requirement.maximumYear}';
    }
    return 'Any year';
  }

  // Build pricing text
  String _buildPricingText(VehicleRequirement requirement) {
    final parts = <String>[];
    if (requirement.hourlyRate != null) {
      parts.add('\$${requirement.hourlyRate}/hour');
    }
    if (requirement.pricePerMile != null) {
      parts.add('\$${requirement.pricePerMile}/mile');
    }
    return parts.isEmpty ? 'Not specified' : parts.join(', ');
  }

  // Build add new requirement button
  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton.secondary(
        'Add Vehicle Requirement',
        onPressed: _showAddVehicleRequirement,
        icon: Icons.add,
        width: double.infinity,
        height: 48,
      ),
    );
  }
}
