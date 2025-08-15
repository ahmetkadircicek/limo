import 'package:flutter/material.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_input.dart';
import 'package:limo/shared/app_text.dart';

class VehicleRequirementForm extends StatefulWidget {
  final VehicleRequirement? initialRequirement;
  final Function(VehicleRequirement) onRequirementChanged;
  final bool enabled;

  const VehicleRequirementForm({
    super.key,
    this.initialRequirement,
    required this.onRequirementChanged,
    this.enabled = true,
  });

  @override
  State<VehicleRequirementForm> createState() => _VehicleRequirementFormState();
}

class _VehicleRequirementFormState extends State<VehicleRequirementForm> {
  String? _selectedBrand;
  String? _selectedVehicleType;
  VehicleCategory? _selectedCategory;
  double? _hourlyRate;
  double? _pricePerMile;

  final List<String> _vehicleBrands = [
    'Ford',
    'Mercedes',
    'Volvo',
    'Scania',
    'MAN',
    'Iveco',
    'DAF',
    'Renault',
    'BMW',
    'Audi',
    'Toyota',
    'Honda',
    'Nissan',
    'Chevrolet',
    'Hyundai',
    'Kia',
  ];

  final List<String> _vehicleTypes = [
    'Truck',
    'Semi-Truck',
    'Pickup Truck',
    'Tractor',
    'Minibus',
    'Bus',
    'Sedan',
    'SUV',
    'Van',
    'Hatchback',
  ];

  final _hourlyRateController = TextEditingController();
  final _pricePerMileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialRequirement != null) {
      final req = widget.initialRequirement!;
      _selectedBrand = req.specificBrand;
      _selectedVehicleType = req.specificVehicleType;
      _selectedCategory = req.minimumCategory;
      _hourlyRate = req.hourlyRate;
      _pricePerMile = req.pricePerMile;

      _hourlyRateController.text = _hourlyRate?.toString() ?? '';
      _pricePerMileController.text = _pricePerMile?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _pricePerMileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildBrandSection(),
          const SizedBox(height: 16),
          _buildVehicleTypeSection(),
          const SizedBox(height: 16),
          _buildCategorySection(),
          const SizedBox(height: 16),
          _buildPricingSection(),
        ],
      ),
    );
  }

  // Build form header with title and icon
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.directions_car, color: context.primary, size: 20),
        ),
        const SizedBox(width: 12),
        AppText.body('Vehicle Requirements', color: context.onSurface),
      ],
    );
  }

  // Build brand selection section
  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall('Brand Preference', color: context.onSurface),
        const SizedBox(height: 8),
        // BURASI: Dropdown menü panelinin tasarımını değiştirmek için app_theme.dart'taki dropdownMenuTheme'i güncelleyin.
        // Bu sayede tüm uygulamadaki dropdown'lar aynı anda güncellenir. Dropdown trigger/button'ı etkilemez.
        AppInput.dropdown(
          labelText: '',
          hintText: 'Select brand...',
          dropdownItems: ['Any Brand', ..._vehicleBrands],
          dropdownValue: _selectedBrand ?? 'Any Brand',
          onDropdownChanged:
              widget.enabled
                  ? (value) {
                    setState(() {
                      _selectedBrand = value == 'Any Brand' ? null : value;
                    });
                    _notifyChanges();
                  }
                  : (value) {},
          enabled: widget.enabled,
        ),
      ],
    );
  }

  // Build vehicle type selection section
  Widget _buildVehicleTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall('Vehicle Type', color: context.onSurface),
        const SizedBox(height: 8),
        // BURASI: Dropdown menü panelinin tasarımını değiştirmek için app_theme.dart'taki dropdownMenuTheme'i güncelleyin.
        // Bu sayede tüm uygulamadaki dropdown'lar aynı anda güncellenir. Dropdown trigger/button'ı etkilemez.
        AppInput.dropdown(
          labelText: '',
          hintText: 'Select type...',
          dropdownItems: ['Any Type', ..._vehicleTypes],
          dropdownValue: _selectedVehicleType ?? 'Any Type',
          onDropdownChanged:
              widget.enabled
                  ? (value) {
                    setState(() {
                      _selectedVehicleType = value == 'Any Type' ? null : value;
                    });
                    _notifyChanges();
                  }
                  : (value) {},
          enabled: widget.enabled,
        ),
      ],
    );
  }

  // Build category selection section
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall('Minimum Category', color: context.onSurface),
        const SizedBox(height: 8),
        // BURASI: Dropdown menü panelinin tasarımını değiştirmek için app_theme.dart'taki dropdownMenuTheme'i güncelleyin.
        // Bu sayede tüm uygulamadaki dropdown'lar aynı anda güncellenir. Dropdown trigger/button'ı etkilemez.
        AppInput.dropdown(
          labelText: '',
          hintText: 'Select category...',
          dropdownItems: [
            'Any Category',
            ...VehicleCategory.values.map((category) => category.name),
          ],
          dropdownValue:
              _selectedCategory == null
                  ? 'Any Category'
                  : _selectedCategory!.name,
          onDropdownChanged:
              widget.enabled
                  ? (value) {
                    setState(() {
                      _selectedCategory =
                          value == 'Any Category'
                              ? null
                              : VehicleCategory.values.firstWhere(
                                (cat) => cat.name == value,
                              );
                    });
                    _notifyChanges();
                  }
                  : (value) {},
          enabled: widget.enabled,
        ),
      ],
    );
  }

  // Build pricing input section
  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall('Pricing', color: context.onSurface),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildHourlyRateInput()),
            const SizedBox(width: 16),
            Expanded(child: _buildPricePerMileInput()),
          ],
        ),
      ],
    );
  }

  // Build hourly rate input field
  Widget _buildHourlyRateInput() {
    return TextFormField(
      controller: _hourlyRateController,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '25.00',
        prefixText: '\$ ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: context.onSurface.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: context.onSurface.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.primary),
        ),
      ),
      onChanged:
          widget.enabled
              ? (value) {
                _hourlyRate = double.tryParse(value);
                _notifyChanges();
              }
              : null,
    );
  }

  // Build price per mile input field
  Widget _buildPricePerMileInput() {
    return TextFormField(
      controller: _pricePerMileController,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: '2.50',
        prefixText: '\$ ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: context.onSurface.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: context.onSurface.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.primary),
        ),
      ),
      onChanged:
          widget.enabled
              ? (value) {
                _pricePerMile = double.tryParse(value);
                _notifyChanges();
              }
              : null,
    );
  }

  // Notify parent about changes
  void _notifyChanges() {
    final requirement = VehicleRequirement(
      id:
          widget.initialRequirement?.id ??
          'req_${DateTime.now().millisecondsSinceEpoch}',
      isFlexible:
          _selectedBrand == null &&
          _selectedVehicleType == null &&
          _selectedCategory == null,
      specificBrand: _selectedBrand,
      specificVehicleType: _selectedVehicleType,
      minimumCategory: _selectedCategory,
      hourlyRate: _hourlyRate,
      pricePerMile: _pricePerMile,
    );

    widget.onRequirementChanged(requirement);
  }
}
