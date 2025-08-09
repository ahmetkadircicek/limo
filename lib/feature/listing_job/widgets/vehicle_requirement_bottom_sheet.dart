import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_dropdown.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';

class VehicleRequirementBottomSheet extends StatefulWidget {
  final VehicleRequirement? initialRequirement;
  final Function(VehicleRequirement) onSave;

  const VehicleRequirementBottomSheet({
    super.key,
    this.initialRequirement,
    required this.onSave,
  });

  @override
  State<VehicleRequirementBottomSheet> createState() =>
      _VehicleRequirementBottomSheetState();
}

class _VehicleRequirementBottomSheetState
    extends State<VehicleRequirementBottomSheet> {
  late bool _isFlexible;

  // Dropdown values
  String? _selectedBrand;
  String? _selectedVehicleType;
  String? _selectedExteriorColor;
  String? _selectedInteriorColor;

  // Controllers
  final TextEditingController _minCapacityController = TextEditingController();
  final TextEditingController _maxCapacityController = TextEditingController();
  final TextEditingController _minYearController = TextEditingController();
  final TextEditingController _maxYearController = TextEditingController();

  // Data lists
  final List<String> _vehicleBrands = [
    'Toyota',
    'Honda',
    'BMW',
    'Mercedes',
    'Audi',
    'Ford',
    'Chevrolet',
    'Nissan',
    'Hyundai',
    'Kia',
    'Volkswagen',
    'Subaru',
    'Mazda',
    'Lexus'
  ];

  final List<String> _vehicleTypes = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Coupe',
    'Truck',
    'Van',
    'Convertible'
  ];

  final List<String> _colors = [
    'Black',
    'White',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Green',
    'Brown'
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
      _selectedBrand = req.specificBrand;
      _selectedVehicleType = req.specificVehicleType;
      _selectedExteriorColor = req.specificExteriorColor;
      _selectedInteriorColor = req.specificInteriorColor;

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
    } else {
      _isFlexible = true;
    }
  }

  VehicleRequirement _buildRequirement() {
    if (_isFlexible) {
      return VehicleRequirement(isFlexible: true);
    }

    return VehicleRequirement.specific(
      brand: _selectedBrand,
      vehicleType: _selectedVehicleType,
      exteriorColor: _selectedExteriorColor,
      interiorColor: _selectedInteriorColor,
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

  void _save() {
    final requirement = _buildRequirement();
    widget.onSave(requirement);
    Navigator.of(context).pop();
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        left: PaddingConstants.spacingXl,
        right: PaddingConstants.spacingXl,
        top: PaddingConstants.spacingL,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            PaddingConstants.spacingXl,
      ),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: GeneralText(
                    text: widget.initialRequirement != null
                        ? 'Edit Vehicle Requirement'
                        : 'Add Vehicle Requirement',
                    fontSize: GeneralConstants.fontSizeTitle,
                    fontWeight: GeneralConstants.fontWeightTitle,
                    color: context.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: context.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            SizedBox(height: PaddingConstants.spacingL),

            // Vehicle type toggle
            _buildFlexibilityToggle(),

            if (!_isFlexible) ...[
              SizedBox(height: PaddingConstants.spacingL),

              // Brand
              GeneralDropdown(
                items: _vehicleBrands,
                value: _selectedBrand,
                hintText: 'Brand (Optional)',
                prefixIcon: const Icon(Icons.directions_car),
                onChanged: (value) => setState(() => _selectedBrand = value),
              ),
              SizedBox(height: PaddingConstants.spacingM),

              // Type
              GeneralDropdown(
                items: _vehicleTypes,
                value: _selectedVehicleType,
                hintText: 'Type (Optional)',
                prefixIcon: const Icon(Icons.category),
                onChanged: (value) =>
                    setState(() => _selectedVehicleType = value),
              ),
              SizedBox(height: PaddingConstants.spacingM),

              // Exterior Color
              GeneralDropdown(
                items: _colors,
                value: _selectedExteriorColor,
                hintText: 'Exterior Color (Optional)',
                prefixIcon: const Icon(Icons.palette),
                onChanged: (value) =>
                    setState(() => _selectedExteriorColor = value),
              ),
              SizedBox(height: PaddingConstants.spacingM),

              // Interior Color
              GeneralDropdown(
                items: _colors,
                value: _selectedInteriorColor,
                hintText: 'Interior Color (Optional)',
                prefixIcon: const Icon(Icons.airline_seat_recline_normal),
                onChanged: (value) =>
                    setState(() => _selectedInteriorColor = value),
              ),
              SizedBox(height: PaddingConstants.spacingM),

              // Capacity
              Row(
                children: [
                  Expanded(
                    child: GeneralTextField(
                      controller: _minCapacityController,
                      hintText: 'Min Capacity',
                      prefixIcon: const Icon(Icons.people),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: PaddingConstants.spacingS),
                  Expanded(
                    child: GeneralTextField(
                      controller: _maxCapacityController,
                      hintText: 'Max Capacity',
                      prefixIcon: const Icon(Icons.people_outline),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: PaddingConstants.spacingM),

              // Year
              Row(
                children: [
                  Expanded(
                    child: GeneralTextField(
                      controller: _minYearController,
                      hintText: 'Min Year',
                      prefixIcon: const Icon(Icons.calendar_today),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: PaddingConstants.spacingS),
                  Expanded(
                    child: GeneralTextField(
                      controller: _maxYearController,
                      hintText: 'Max Year',
                      prefixIcon: const Icon(Icons.event),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: PaddingConstants.spacingXl),

            // Save button
            SizedBox(
              width: double.infinity,
              child: GeneralButton(
                text: widget.initialRequirement != null
                    ? 'Update'
                    : 'Add Requirement',
                fontSize: GeneralConstants.fontSizeBody,
                color: context.primary,
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibilityToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                onPressed: () => setState(() => _isFlexible = true),
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
                onPressed: () => setState(() => _isFlexible = false),
              ),
            ),
          ],
        ),
        SizedBox(height: PaddingConstants.spacingS),
        Container(
          height: 48.0, // Same as text fields
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: context.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 24.0,
                color: context.primary.withOpacity(0.7),
              ),
              SizedBox(width: PaddingConstants.spacingM),
              Expanded(
                child: Text(
                  _isFlexible
                      ? 'Any vehicle type will be accepted for this job.'
                      : 'Only vehicles matching your requirements can apply.',
                  style: TextStyle(
                    fontSize: 16.0, // Same as text fields
                    color: context.onSurface.withOpacity(0.7),
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
