import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/padding_constants.dart';
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
      _selectedVehicleType = _migrateVehicleType(req.specificVehicleType);
      _minCapacity = req.minimumCapacity;
      _minYear = req.minimumYear;
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
      body: _buildBody(),
    );
  }

  // Build main body content
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: PaddingConstants.allXl,
      child: SafeArea(
        child: Column(
          spacing: PaddingConstants.spacingL,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlexibleSection(),
            _buildVehicleSpecsSection(),
            _buildCategorySection(),
            _buildRequirementsSection(),
            _buildPricingSection(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton.primary(
          'Save',
          onPressed: _saveRequirement,
          width: double.infinity,
          height: 52,
        ),
        SizedBox(height: PaddingConstants.spacingL),
        AppButton.secondary(
          'Cancel',
          onPressed: () => context.pop(),
          width: double.infinity,
          height: 52,
        ),
      ],
    );
  }

  // Build flexible requirements header section
  Widget _buildFlexibleSection() {
    return AppCard.primary(
      padding: PaddingConstants.allXl,
      child: Row(
        children: [
          Container(
            padding: PaddingConstants.allM,
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.settings,
              color: context.primary,
              size: 20,
            ),
          ),
          SizedBox(width: PaddingConstants.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.heading(
                  'Vehicle Requirements',
                  color: context.onSurface,
                ),
                AppText.bodySmall(
                  'Specify vehicle criteria for your job posting',
                  color: context.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build vehicle specifications section (brand and type)
  Widget _buildVehicleSpecsSection() {
    return _buildSection(
      title: 'Vehicle Specifications',
      icon: Icons.directions_car,
      children: [
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
        SizedBox(height: PaddingConstants.spacingL),
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
      icon: Icons.assignment,
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
        SizedBox(height: PaddingConstants.spacingL),
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

  // Build category section (prominent placement)
  Widget _buildCategorySection() {
    return _buildSection(
      title: 'Vehicle Category',
      icon: Icons.category,
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
      ],
    );
  }

  // Build pricing section
  Widget _buildPricingSection() {
    return AppCard.primary(
      padding: PaddingConstants.allXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Pricing', Icons.attach_money),
          SizedBox(height: PaddingConstants.spacingXl),
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
          SizedBox(height: PaddingConstants.spacingL),
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
    required IconData icon,
    required List<Widget> children,
  }) {
    return AppCard.primary(
      padding: PaddingConstants.allXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title, icon),
          SizedBox(height: PaddingConstants.spacingXl),
          ...children,
        ],
      ),
    );
  }

  // Build section header with icon and title
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: PaddingConstants.allM,
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: context.primary,
            size: 20,
          ),
        ),
        SizedBox(width: PaddingConstants.spacingL),
        AppText.heading(
          title,
          color: context.onSurface,
        ),
      ],
    );
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

  // Build text input field
  Widget _buildTextField({
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
      onChanged: onChanged,
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
      id: widget.initialRequirement?.id ??
          'req_${DateTime.now().millisecondsSinceEpoch}',
      isFlexible: false, // Always false since we removed the flexible mode
      specificBrand: _selectedBrand,
      specificVehicleType: _selectedVehicleType,
      minimumCapacity: _minCapacity,
      minimumYear: _minYear,
      minimumCategory: _selectedCategory,
      notes:
          'Mile: ${_pricePerMile ?? 0}, Hour: ${_pricePerHour ?? 0}', // Store pricing info in notes field
    );

    widget.onSave(requirement);
    context.pop();
  }

  // Migrate old Turkish vehicle types to new English ones
  String? _migrateVehicleType(String? oldType) {
    if (oldType == null) return null;

    const Map<String, String> typeMapping = {
      'Kamyon': 'Truck',
      'Tır': 'Semi-Truck',
      'Pickup': 'Pickup Truck',
      'Traktör': 'Tractor',
      'Minibüs': 'Minibus',
      'Otobüs': 'Bus',
      'Sedan': 'Sedan',
      'SUV': 'SUV',
      'Van': 'Van',
      'Hatchback': 'Hatchback',
    };

    return typeMapping[oldType] ?? oldType;
  }
}
