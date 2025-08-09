import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:soforvarcom/shared/elevated_expansion_tile.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_dropdown.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';

class VehicleRequirementForm extends StatefulWidget {
  final VehicleRequirement? initialRequirement;
  final Function(VehicleRequirement) onRequirementChanged;
  final bool enabled;
  final bool embedded; // If true, won't show expansion tile wrapper

  const VehicleRequirementForm({
    super.key,
    this.initialRequirement,
    required this.onRequirementChanged,
    this.enabled = true,
    this.embedded = false,
  });

  @override
  State<VehicleRequirementForm> createState() => _VehicleRequirementFormState();
}

class _VehicleRequirementFormState extends State<VehicleRequirementForm> {
  bool _isFlexible = true;
  String? _selectedBrand;
  // String? _selectedModel; // Unused for now
  String? _selectedVehicleType;
  String? _selectedExteriorColor;
  String? _selectedInteriorColor;
  final TextEditingController _minCapacityController = TextEditingController();
  final TextEditingController _maxCapacityController = TextEditingController();
  final TextEditingController _minYearController = TextEditingController();
  final TextEditingController _maxYearController = TextEditingController();

  // Predefined options for dropdowns
  final List<String> _vehicleBrands = [
    'Any Brand',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Volkswagen',
    'Toyota',
    'Honda',
    'Ford',
    'Hyundai',
    'Kia',
    'Renault',
    'Fiat',
    'Other'
  ];

  final List<String> _vehicleTypes = [
    'Any Type',
    'Sedan',
    'Hatchback',
    'SUV',
    'Minivan',
    'Pickup',
    'Coupe',
    'Convertible',
    'Station Wagon'
  ];

  final List<String> _colors = [
    'Any Color',
    'White',
    'Black',
    'Silver',
    'Gray',
    'Blue',
    'Red',
    'Green',
    'Brown',
    'Yellow',
    'Orange',
    'Purple'
  ];

  @override
  void initState() {
    super.initState();
    _initializeFromRequirement();
  }

  void _initializeFromRequirement() {
    if (widget.initialRequirement != null) {
      final req = widget.initialRequirement!;
      _isFlexible = req.isFlexible;
      _selectedBrand = req.specificBrand ?? 'Any Brand';
      // _selectedModel = req.specificModel; // Unused for now
      _selectedVehicleType = req.specificVehicleType ?? 'Any Type';
      _selectedExteriorColor = req.specificExteriorColor ?? 'Any Color';
      _selectedInteriorColor = req.specificInteriorColor ?? 'Any Color';

      if (req.minimumCapacity != null) {
        _minCapacityController.text = req.minimumCapacity.toString();
      }
      if (req.maximumCapacity != null) {
        _maxCapacityController.text = req.maximumCapacity.toString();
      }
      if (req.minimumYear != null) {
        _minYearController.text = req.minimumYear.toString();
      }
      if (req.maximumYear != null) {
        _maxYearController.text = req.maximumYear.toString();
      }
    }
  }

  void _updateRequirement() {
    VehicleRequirement requirement;

    if (_isFlexible) {
      requirement = VehicleRequirement.anyVehicle();
    } else {
      requirement = VehicleRequirement.specific(
        brand: _selectedBrand == 'Any Brand' ? null : _selectedBrand,
        vehicleType:
            _selectedVehicleType == 'Any Type' ? null : _selectedVehicleType,
        exteriorColor: _selectedExteriorColor == 'Any Color'
            ? null
            : _selectedExteriorColor,
        interiorColor: _selectedInteriorColor == 'Any Color'
            ? null
            : _selectedInteriorColor,
        minCapacity: _minCapacityController.text.isNotEmpty
            ? int.tryParse(_minCapacityController.text)
            : null,
        maxCapacity: _maxCapacityController.text.isNotEmpty
            ? int.tryParse(_maxCapacityController.text)
            : null,
        minYear: _minYearController.text.isNotEmpty
            ? int.tryParse(_minYearController.text)
            : null,
        maxYear: _maxYearController.text.isNotEmpty
            ? int.tryParse(_maxYearController.text)
            : null,
      );
    }

    widget.onRequirementChanged(requirement);
  }

  @override
  void dispose() {
    _minCapacityController.dispose();
    _maxCapacityController.dispose();
    _minYearController.dispose();
    _maxYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flexible toggle
        _buildFlexibilityToggle(),
        SizedBox(height: PaddingConstants.spacingL),

        if (!_isFlexible) ...[
          SizedBox(height: PaddingConstants.spacingM),

          // Vehicle brand and type in a row
          Row(
            children: [
              Expanded(child: _buildBrandDropdown()),
              SizedBox(width: PaddingConstants.spacingS),
              Expanded(child: _buildVehicleTypeDropdown()),
            ],
          ),
          SizedBox(height: PaddingConstants.spacingM),

          // Colors in a row
          Row(
            children: [
              Expanded(child: _buildExteriorColorDropdown()),
              SizedBox(width: PaddingConstants.spacingS),
              Expanded(child: _buildInteriorColorDropdown()),
            ],
          ),
          SizedBox(height: PaddingConstants.spacingM),

          // Capacity range
          _buildCapacityRange(),
          SizedBox(height: PaddingConstants.spacingM),

          // Year range
          _buildYearRange(),
        ],
      ],
    );

    if (widget.embedded) {
      return content;
    }

    return ElevatedExpansionTile(
      title: GeneralText(
        text: 'Vehicle Requirements',
        fontSize: GeneralConstants.fontSizeBody,
        fontWeight: GeneralConstants.fontWeightSubtitle,
      ),
      initiallyExpanded: !_isFlexible,
      children: [
        Padding(
          padding: PaddingConstants.allL,
          child: content,
        ),
      ],
    );
  }

  Widget _buildFlexibilityToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle buttons
        Row(
          children: [
            Expanded(
              child: GeneralButton(
                text: 'Accept Any Vehicle',
                color: _isFlexible
                    ? context.primary
                    : context.surface.withOpacity(0.5),
                fontColor: _isFlexible
                    ? context.onPrimary
                    : context.onSurface.withOpacity(0.7),
                fontSize: GeneralConstants.fontSizeBody,
                onPressed: widget.enabled
                    ? () {
                        setState(() {
                          _isFlexible = true;
                        });
                        _updateRequirement();
                      }
                    : null,
              ),
            ),
            SizedBox(width: PaddingConstants.spacingS),
            Expanded(
              child: GeneralButton(
                text: 'Specific Vehicle',
                color: !_isFlexible
                    ? context.primary
                    : context.surface.withOpacity(0.5),
                fontColor: !_isFlexible
                    ? context.onPrimary
                    : context.onSurface.withOpacity(0.7),
                fontSize: GeneralConstants.fontSizeBody,
                onPressed: widget.enabled
                    ? () {
                        setState(() {
                          _isFlexible = false;
                        });
                        _updateRequirement();
                      }
                    : null,
              ),
            ),
          ],
        ),

        // Info text
        SizedBox(height: PaddingConstants.spacingS),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: PaddingConstants.spacingM,
            vertical: PaddingConstants.spacingS,
          ),
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: context.primary.withOpacity(0.7),
              ),
              SizedBox(width: PaddingConstants.spacingS),
              Expanded(
                child: Text(
                  _isFlexible
                      ? 'Any vehicle type will be accepted for this job.'
                      : 'Only vehicles matching your requirements can apply.',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.onSurface.withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBrandDropdown() {
    return GeneralDropdown(
      items: _vehicleBrands,
      value: _selectedBrand,
      hintText: 'Vehicle Brand',
      prefixIcon: const Icon(Icons.branding_watermark),
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _selectedBrand = value;
              });
              _updateRequirement();
            }
          : null,
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return GeneralDropdown(
      items: _vehicleTypes,
      value: _selectedVehicleType,
      hintText: 'Vehicle Type',
      prefixIcon: const Icon(Icons.directions_car),
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _selectedVehicleType = value;
              });
              _updateRequirement();
            }
          : null,
    );
  }

  Widget _buildExteriorColorDropdown() {
    return GeneralDropdown(
      items: _colors,
      value: _selectedExteriorColor,
      hintText: 'Exterior Color',
      prefixIcon: const Icon(Icons.palette),
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _selectedExteriorColor = value;
              });
              _updateRequirement();
            }
          : null,
    );
  }

  Widget _buildInteriorColorDropdown() {
    return GeneralDropdown(
      items: _colors,
      value: _selectedInteriorColor,
      hintText: 'Interior Color',
      prefixIcon: const Icon(Icons.airline_seat_recline_normal),
      onChanged: widget.enabled
          ? (value) {
              setState(() {
                _selectedInteriorColor = value;
              });
              _updateRequirement();
            }
          : null,
    );
  }

  Widget _buildCapacityRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GeneralText(
          text: 'Passenger Capacity',
          fontSize: GeneralConstants.fontSizeBody,
          fontWeight: GeneralConstants.fontWeightSubtitle,
        ),
        SizedBox(height: PaddingConstants.spacingS),
        Row(
          children: [
            Expanded(
              child: GeneralTextField(
                controller: _minCapacityController,
                hintText: 'Min Capacity',
                prefixIcon: const Icon(Icons.people),
                keyboardType: TextInputType.number,
                enabled: widget.enabled,
                onChanged:
                    widget.enabled ? (value) => _updateRequirement() : null,
              ),
            ),
            SizedBox(width: PaddingConstants.spacingM),
            Expanded(
              child: GeneralTextField(
                controller: _maxCapacityController,
                hintText: 'Max Capacity',
                prefixIcon: const Icon(Icons.people_outline),
                keyboardType: TextInputType.number,
                enabled: widget.enabled,
                onChanged:
                    widget.enabled ? (value) => _updateRequirement() : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYearRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GeneralText(
          text: 'Vehicle Year',
          fontSize: GeneralConstants.fontSizeBody,
          fontWeight: GeneralConstants.fontWeightSubtitle,
        ),
        SizedBox(height: PaddingConstants.spacingS),
        Row(
          children: [
            Expanded(
              child: GeneralTextField(
                controller: _minYearController,
                hintText: 'Min Year',
                prefixIcon: const Icon(Icons.calendar_today),
                keyboardType: TextInputType.number,
                enabled: widget.enabled,
                onChanged:
                    widget.enabled ? (value) => _updateRequirement() : null,
              ),
            ),
            SizedBox(width: PaddingConstants.spacingM),
            Expanded(
              child: GeneralTextField(
                controller: _maxYearController,
                hintText: 'Max Year',
                prefixIcon: const Icon(Icons.event),
                keyboardType: TextInputType.number,
                enabled: widget.enabled,
                onChanged:
                    widget.enabled ? (value) => _updateRequirement() : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
