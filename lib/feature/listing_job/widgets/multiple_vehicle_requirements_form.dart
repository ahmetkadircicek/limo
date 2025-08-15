import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_card.dart';

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
    return AppInfoCard(
      icon: requirement.isFlexible ? Icons.check_circle : Icons.directions_car,
      label: 'Vehicle Requirement ${index + 1}',
      value: requirement.isFlexible
          ? 'Flexible Requirements'
          : 'Specific Requirements',
      iconColor: requirement.isFlexible ? context.primary : context.secondary,
      valueColor: requirement.isFlexible
          ? context.primary
          : context.onSurface.withValues(alpha: 0.7),
      onTap: () => _showEditVehicleRequirement(index),
      trailing: widget.enabled
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditButton(index),
                const SizedBox(width: 8),
                _buildRemoveButton(index),
              ],
            )
          : null,
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
