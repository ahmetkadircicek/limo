import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/vehicle_category_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_components.dart';

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
  String? _selectedExteriorColor;
  String? _selectedInteriorColor;
  int? _minCapacity;
  int? _maxCapacity;
  int? _minYear;
  int? _maxYear;
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
  ];

  final List<String> _vehicleTypes = [
    'Kamyon',
    'Tır',
    'Kamyonet',
    'Çekici',
    'Minibüs',
    'Otobüs',
  ];

  final List<String> _colors = [
    'Beyaz',
    'Siyah',
    'Gri',
    'Kırmızı',
    'Mavi',
    'Yeşil',
  ];

  final _minCapacityController = TextEditingController();
  final _maxCapacityController = TextEditingController();
  final _minYearController = TextEditingController();
  final _maxYearController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _pricePerMileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialRequirement != null) {
      final req = widget.initialRequirement!;
      _selectedBrand = req.specificBrand;
      _selectedVehicleType = req.specificVehicleType;
      _selectedExteriorColor = req.specificExteriorColor;
      _selectedInteriorColor = req.specificInteriorColor;
      _minCapacity = req.minimumCapacity;
      _maxCapacity = req.maximumCapacity;
      _minYear = req.minimumYear;
      _maxYear = req.maximumYear;
      _selectedCategory = req.minimumCategory;
      _hourlyRate = req.hourlyRate;
      _pricePerMile = req.pricePerMile;

      _minCapacityController.text = _minCapacity?.toString() ?? '';
      _maxCapacityController.text = _maxCapacity?.toString() ?? '';
      _minYearController.text = _minYear?.toString() ?? '';
      _maxYearController.text = _maxYear?.toString() ?? '';
      _hourlyRateController.text = _hourlyRate?.toString() ?? '';
      _pricePerMileController.text = _pricePerMile?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Requirements'),
        backgroundColor: context.surface,
        foregroundColor: context.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: context.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: PaddingConstants.allXl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    AppInput.dropdown(
                      labelText: 'Brand',
                      hintText: 'Select brand (Optional)',
                      dropdownItems: _vehicleBrands,
                      dropdownValue: _selectedBrand,
                      prefixIcon: Icons.directions_car,
                      onDropdownChanged: (value) =>
                          setState(() => _selectedBrand = value),
                    ),

                    const SizedBox(height: 16),

                    // Vehicle Type
                    AppInput.dropdown(
                      labelText: 'Vehicle Type',
                      hintText: 'Select vehicle type (Optional)',
                      dropdownItems: _vehicleTypes,
                      dropdownValue: _selectedVehicleType,
                      prefixIcon: Icons.category,
                      onDropdownChanged: (value) =>
                          setState(() => _selectedVehicleType = value),
                    ),

                    const SizedBox(height: 16),

                    // Vehicle Category
                    AppInput.dropdown(
                      labelText: 'Minimum Vehicle Category',
                      hintText: 'Select minimum category',
                      dropdownItems: VehicleCategory.values
                          .map((category) => category.displayName)
                          .toList(),
                      dropdownValue: _selectedCategory?.displayName,
                      prefixIcon: Icons.star,
                      onDropdownChanged: (value) {
                        if (value != null) {
                          _selectedCategory = VehicleCategory.values.firstWhere(
                            (category) => category.displayName == value,
                          );
                        } else {
                          _selectedCategory = null;
                        }
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 16),

                    // Exterior Color
                    AppInput.dropdown(
                      labelText: 'Exterior Color',
                      hintText: 'Select exterior color (Optional)',
                      dropdownItems: _colors,
                      dropdownValue: _selectedExteriorColor,
                      prefixIcon: Icons.palette,
                      onDropdownChanged: (value) =>
                          setState(() => _selectedExteriorColor = value),
                    ),

                    const SizedBox(height: 16),

                    // Interior Color
                    AppInput.dropdown(
                      labelText: 'Interior Color',
                      hintText: 'Select interior color (Optional)',
                      dropdownItems: _colors,
                      dropdownValue: _selectedInteriorColor,
                      prefixIcon: Icons.airline_seat_recline_normal,
                      onDropdownChanged: (value) =>
                          setState(() => _selectedInteriorColor = value),
                    ),

                    const SizedBox(height: 20),

                    // Capacity Range
                    Row(
                      children: [
                        Expanded(
                          child: AppInput.primary(
                            labelText: 'Min Capacity',
                            hintText: 'Min',
                            controller: _minCapacityController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.people,
                            onChanged: (value) {
                              _minCapacity = int.tryParse(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppInput.primary(
                            labelText: 'Max Capacity',
                            hintText: 'Max',
                            controller: _maxCapacityController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.people,
                            onChanged: (value) {
                              _maxCapacity = int.tryParse(value);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Year Range
                    Row(
                      children: [
                        Expanded(
                          child: AppInput.primary(
                            labelText: 'Min Year',
                            hintText: 'Min year',
                            controller: _minYearController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.calendar_today,
                            onChanged: (value) {
                              _minYear = int.tryParse(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppInput.primary(
                            labelText: 'Max Year',
                            hintText: 'Max year',
                            controller: _maxYearController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.calendar_today,
                            onChanged: (value) {
                              _maxYear = int.tryParse(value);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Pricing Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: context.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pricing (For This Vehicle)',
                                style: TextStyle(
                                  color: context.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Hourly Rate
                          AppInput.primary(
                            labelText: 'Hourly Rate (₺)',
                            hintText: '0.00',
                            controller: _hourlyRateController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            prefixIcon: Icons.access_time,
                            onChanged: (value) {
                              _hourlyRate = double.tryParse(value);
                            },
                          ),

                          const SizedBox(height: 16),

                          // Price Per Mile
                          AppInput.primary(
                            labelText: 'Price Per Mile (₺)',
                            hintText: '0.00',
                            controller: _pricePerMileController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            prefixIcon: Icons.straighten,
                            onChanged: (value) {
                              _pricePerMile = double.tryParse(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: PaddingConstants.allXl,
              decoration: BoxDecoration(
                color: context.surface,
                border: Border(
                  top: BorderSide(
                    color: context.onSurface.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton.tertiary(
                      'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton.secondary(
                      'Flexible',
                      onPressed: () {
                        final requirement = VehicleRequirement.anyVehicle();
                        widget.onSave(requirement);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton.primary(
                      'Save',
                      onPressed: () {
                        final requirement = VehicleRequirement.specific(
                          id: 'req_${DateTime.now().millisecondsSinceEpoch}',
                          brand: _selectedBrand,
                          vehicleType: _selectedVehicleType,
                          exteriorColor: _selectedExteriorColor,
                          interiorColor: _selectedInteriorColor,
                          minCapacity: _minCapacity,
                          maxCapacity: _maxCapacity,
                          minYear: _minYear,
                          maxYear: _maxYear,
                          minCategory: _selectedCategory,
                          hourlyRate: _hourlyRate,
                          pricePerMile: _pricePerMile,
                        );
                        widget.onSave(requirement);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _minCapacityController.dispose();
    _maxCapacityController.dispose();
    _minYearController.dispose();
    _maxYearController.dispose();
    _hourlyRateController.dispose();
    _pricePerMileController.dispose();
    super.dispose();
  }
}
