import 'package:flutter/material.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_card.dart';
import 'package:limo/shared/app_input.dart';
import 'package:limo/shared/app_text.dart';

class VehicleRequirementPage extends StatefulWidget {
  final VehicleRequirement? initialRequirement;
  final Function(VehicleRequirement) onSave;

  const VehicleRequirementPage({
    super.key,
    this.initialRequirement,
    required this.onSave,
  });

  @override
  State<VehicleRequirementPage> createState() => _VehicleRequirementPageState();
}

class _VehicleRequirementPageState extends State<VehicleRequirementPage> {
  String? _selectedBrand;
  String? _selectedVehicleType;
  int? _minCapacity;
  int? _minYear;
  VehicleCategory? _selectedCategory;
  double? _pricePerMile;
  double? _pricePerHour;

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

  final _minCapacityController = TextEditingController();
  final _minYearController = TextEditingController();
  final _pricePerMileController = TextEditingController();
  final _pricePerHourController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialRequirement != null) {
      final req = widget.initialRequirement!;
      _selectedBrand = req.specificBrand;
      _selectedVehicleType = _migrateVehicleType(req.specificModel);
      _minCapacity = req.capacity;
      _minYear = req.year;
      _selectedCategory = req.minimumCategory;

      // Update controllers
      _minCapacityController.text = _minCapacity?.toString() ?? '';
      _minYearController.text = _minYear?.toString() ?? '';
      _pricePerMileController.text = _pricePerMile?.toString() ?? '';
      _pricePerHourController.text = _pricePerHour?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _minCapacityController.dispose();
    _minYearController.dispose();
    _pricePerMileController.dispose();
    _pricePerHourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: AppBar(
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () {
            // Form'u sıfırla ve geri git
            _resetForm();
            Navigator.of(context).pop();
          },
        ),
        title: AppText.heading(
          'Vehicle Requirements',
          color: context.onSurface,
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  // Build main body content
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: context.paddingL,
      child: SafeArea(
        child: Column(
          spacing: context.spacingL,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehicleSpecsSection(),
            _buildRequirementsSection(),
            _buildPricingSection(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return AppButton.primary(
      'Save',
      onPressed: _saveRequirement,
      width: double.infinity,
    );
  }

  // Build vehicle specifications section (category, brand and type)
  Widget _buildVehicleSpecsSection() {
    return _buildSection(
      title: 'Vehicle Specifications',
      children: [
        _buildDropdownField(
          label: 'Category',
          hint: 'Select minimum category',
          value: _selectedCategory?.displayName,
          items: VehicleCategory.values.map((c) => c.displayName).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = VehicleCategory.values.firstWhere(
                (c) => c.displayName == value,
                orElse: () => VehicleCategory.values.first,
              );
            });
          },
          icon: Icons.category,
        ),
        SizedBox(height: context.spacingL),
        _buildDropdownField(
          label: 'Brand',
          hint: 'Select brand (optional)',
          value: _selectedBrand,
          items: _vehicleBrands,
          onChanged: (value) {
            setState(() {
              _selectedBrand = value;
            });
          },
          icon: Icons.branding_watermark,
        ),
        SizedBox(height: context.spacingL),
        _buildDropdownField(
          label: 'Type',
          hint: 'Select vehicle type (optional)',
          value: _selectedVehicleType,
          items: _vehicleTypes,
          onChanged: (value) {
            setState(() {
              _selectedVehicleType = value;
            });
          },
          icon: Icons.directions_car,
        ),
      ],
    );
  }

  // Build requirements section (capacity, year)
  Widget _buildRequirementsSection() {
    return _buildSection(
      title: 'Requirements',
      children: [
        _buildNumberInputField(
          label: 'Min Capacity',
          hint: 'Min passengers (e.g., 4)',
          controller: _minCapacityController,
          onChanged: (value) {
            setState(() {
              _minCapacity = int.tryParse(value);
            });
          },
          icon: Icons.people,
        ),
        SizedBox(height: context.spacingL),
        _buildNumberInputField(
          label: 'Min Year',
          hint: 'Min year (e.g., 2010)',
          controller: _minYearController,
          onChanged: (value) {
            setState(() {
              _minYear = int.tryParse(value);
            });
          },
          icon: Icons.calendar_today,
        ),
      ],
    );
  }

  // Build pricing section
  Widget _buildPricingSection() {
    return AppCard.primary(
      padding: context.paddingL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Pricing'),
          SizedBox(height: context.spacingXl),
          _buildPriceInputField(
            label: 'Price per Mile',
            hint: 'Price per mile (e.g., 2.50)',
            controller: _pricePerMileController,
            onChanged: (value) {
              setState(() {
                _pricePerMile = double.tryParse(value);
              });
            },
            icon: Icons.route,
          ),
          SizedBox(height: context.spacingL),
          _buildPriceInputField(
            label: 'Price per Hour',
            hint: 'Price per hour (e.g., 25.00)',
            controller: _pricePerHourController,
            onChanged: (value) {
              setState(() {
                _pricePerHour = double.tryParse(value);
              });
            },
            icon: Icons.access_time,
          ),
        ],
      ),
    );
  }

  // Build reusable section container
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return AppCard.primary(
      padding: context.paddingL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title),
          SizedBox(height: context.spacingXl),
          ...children,
        ],
      ),
    );
  }

  // Build section header with title only
  Widget _buildSectionHeader(String title) {
    return AppText.heading(title, color: context.onSurface);
  }

  // Build dropdown field
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    // Add "Any" option to the beginning of items
    final itemsWithAny = ['Any', ...items];
    return AppInput.dropdown(
      labelText: label,
      hintText: hint,
      dropdownValue: value ?? 'Any',
      dropdownItems: itemsWithAny,
      onDropdownChanged: (newValue) {
        // Convert "Any" back to null
        onChanged(newValue == 'Any' ? null : newValue);
      },
    );
  }

  // Build number input field
  Widget _buildNumberInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return AppInput.primary(
      labelText: label,
      controller: controller,
      hintText: hint,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  // Build price input field
  Widget _buildPriceInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return AppInput.primary(
      labelText: label,
      controller: controller,
      hintText: hint,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
    );
  }

  // Save vehicle requirement and navigate back
  void _saveRequirement() {
    final requirement = VehicleRequirement(
      id:
          widget.initialRequirement?.id ??
          'req_${DateTime.now().millisecondsSinceEpoch}',
      category: _selectedCategory ?? VehicleCategory.standardSedan,
      count: 1,
      specificBrand: _selectedBrand,
      specificModel: _selectedVehicleType,
      capacity: _minCapacity,
      year: _minYear,
      minimumCategory: _selectedCategory,
      notes: 'Mile: ${_pricePerMile ?? 0}, Hour: ${_pricePerHour ?? 0}',
      pricePerMile: _pricePerMile,
      hourlyRate: _pricePerHour,
    );

    widget.onSave(requirement);
    Navigator.of(context).pop();
  }

  // Reset form to initial state
  void _resetForm() {
    setState(() {
      _selectedBrand = null;
      _selectedVehicleType = null;
      _minCapacity = null;
      _minYear = null;
      _selectedCategory = null;
      _pricePerMile = null;
      _pricePerHour = null;

      // Reset controllers
      _minCapacityController.clear();
      _minYearController.clear();
      _pricePerMileController.clear();
      _pricePerHourController.clear();
    });
  }

  // Migrate old Turkish vehicle types to new English ones
  String? _migrateVehicleType(String? oldType) {
    if (oldType == null) return null;

    const Map<String, String> typeMapping = {
      'Truck': 'Truck',
      'Semi-Truck': 'Semi-Truck',
      'Pickup': 'Pickup Truck',
      'Tractor': 'Tractor',
      'Minibus': 'Minibus',
      'Bus': 'Bus',
      'Sedan': 'Sedan',
      'SUV': 'SUV',
      'Van': 'Van',
      'Hatchback': 'Hatchback',
    };

    return typeMapping[oldType] ?? oldType;
  }
}
