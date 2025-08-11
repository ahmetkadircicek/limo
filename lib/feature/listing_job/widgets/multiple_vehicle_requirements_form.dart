import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_components.dart';

import '../view/vehicle_requirement_page.dart';

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

  void _showAddVehicleRequirement() {
    if (!widget.enabled) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VehicleRequirementPage(
          onSave: (requirement) {
            setState(() {
              _requirements.add(requirement);
            });
            _notifyChanges();
          },
        ),
      ),
    );
  }

  void _showEditVehicleRequirement(int index) {
    if (!widget.enabled) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VehicleRequirementPage(
          initialRequirement: _requirements[index],
          onSave: (requirement) {
            setState(() {
              _requirements[index] = requirement;
            });
            _notifyChanges();
          },
        ),
      ),
    );
  }

  void _removeRequirement(int index) {
    if (_requirements.length > 1 && widget.enabled) {
      setState(() {
        _requirements.removeAt(index);
      });
      _notifyChanges();
    }
  }

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
              child: AppCard.secondary(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Vehicle icon
                        Container(
                          padding: EdgeInsets.all(PaddingConstants.spacingS),
                          decoration: BoxDecoration(
                            color: context.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.directions_car,
                            size: 20.0,
                            color: context.primary,
                          ),
                        ),
                        SizedBox(width: PaddingConstants.spacingM),

                        // Requirement details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.body(
                                requirement.isFlexible
                                    ? 'Any Vehicle Accepted'
                                    : requirement.getDescription(),
                                color: context.onSurface,
                                maxLines: 2,
                              ),

                              // Show category if specified
                              if (!requirement.isFlexible &&
                                  requirement.minimumCategory != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        context.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Min: ${requirement.minimumCategory!.displayName}',
                                    style: TextStyle(
                                      color: context.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Action buttons
                        if (widget.enabled) ...[
                          _buildActionButton(
                            icon: Icons.edit_outlined,
                            color: Color(0xFF9CA3AF),
                            onTap: () => _showEditVehicleRequirement(index),
                          ),
                          if (_requirements.length > 1)
                            _buildActionButton(
                              icon: Icons.delete_outline,
                              color: context.error,
                              onTap: () => _removeRequirement(index),
                            ),
                        ],
                      ],
                    ),

                    // Show pricing if specified
                    if (!requirement.isFlexible &&
                        (requirement.hourlyRate != null ||
                            requirement.pricePerMile != null)) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                const Color(0xFF10B981).withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.attach_money,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                requirement.getPricingSummary(),
                                style: const TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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
          }),
        ],

        // Add button
        if (widget.enabled) ...[
          Container(
            margin: EdgeInsets.only(top: PaddingConstants.spacingM),
            width: double.infinity,
            child: AppButton.secondary(
              'Add Vehicle Requirement',
              onPressed: _showAddVehicleRequirement,
              icon: Icons.add_circle_outline,
              width: double.infinity,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(left: PaddingConstants.spacingS),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(PaddingConstants.spacingS),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18.0,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
