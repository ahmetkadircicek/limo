import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:soforvarcom/feature/listing_job/widgets/vehicle_requirement_bottom_sheet.dart';
import 'package:soforvarcom/shared/general_text.dart';

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
      _requirements.add(VehicleRequirement(isFlexible: true));
    }
  }

  void _showAddBottomSheet() {
    if (!widget.enabled) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => VehicleRequirementBottomSheet(
        onSave: (requirement) {
          setState(() {
            _requirements.add(requirement);
          });
          _notifyChanges();
        },
      ),
    );
  }

  void _showEditBottomSheet(int index) {
    if (!widget.enabled) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => VehicleRequirementBottomSheet(
        initialRequirement: _requirements[index],
        onSave: (requirement) {
          setState(() {
            _requirements[index] = requirement;
          });
          _notifyChanges();
        },
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
              height: 48.0, // Same as text fields
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: context.onSurface.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Vehicle icon (like text field prefix icons)
                  Icon(
                    Icons.directions_car,
                    size: 24.0,
                    color: context.onSurface.withOpacity(0.6),
                  ),
                  SizedBox(width: PaddingConstants.spacingM),

                  // Requirement details
                  Expanded(
                    child: GeneralText(
                      text: requirement.isFlexible
                          ? 'Any Vehicle Accepted'
                          : requirement.getDescription(),
                      fontSize: 16.0, // Same as text field font size
                      fontWeight: GeneralConstants.fontWeightBody,
                      color: context.onSurface,
                      maxLines: 1,
                    ),
                  ),

                  // Action buttons
                  if (widget.enabled) ...[
                    InkWell(
                      onTap: () => _showEditBottomSheet(index),
                      child: Padding(
                        padding: EdgeInsets.all(PaddingConstants.spacingS),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20.0,
                          color: context.primary,
                        ),
                      ),
                    ),
                    if (_requirements.length > 1)
                      InkWell(
                        onTap: () => _removeRequirement(index),
                        child: Padding(
                          padding: EdgeInsets.all(PaddingConstants.spacingS),
                          child: Icon(
                            Icons.delete_outline,
                            size: 20.0,
                            color: context.error,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            );
          }),
        ],

        // Add button
        if (widget.enabled) ...[
          InkWell(
            onTap: _showAddBottomSheet,
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              height: 48.0, // Same as text fields
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: context.primary.withOpacity(0.3),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: context.primary,
                    size: 24.0, // Same as other icons
                  ),
                  SizedBox(width: PaddingConstants.spacingM),
                  GeneralText(
                    text: 'Add Vehicle Requirement',
                    fontSize: 16.0, // Same as text field font size
                    color: context.primary,
                    fontWeight: GeneralConstants.fontWeightBody,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
