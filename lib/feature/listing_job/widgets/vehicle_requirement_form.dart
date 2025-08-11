import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/shared/app_components.dart';

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
  int _vehicleCount = 1;

  final List<String> _brands = [
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

  @override
  void initState() {
    super.initState();
    if (widget.initialRequirement != null) {
      _selectedBrand = widget.initialRequirement!.specificBrand;
      _selectedVehicleType = widget.initialRequirement!.specificVehicleType;
      _vehicleCount = 1; // Default value
    }
  }

  void _updateRequirement() {
    if (_selectedBrand != null && _selectedVehicleType != null) {
      final requirement = VehicleRequirement.specific(
        brand: _selectedBrand!,
        vehicleType: _selectedVehicleType!,
      );
      widget.onRequirementChanged(requirement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.subtitle(
            'Araç Gereksinimleri',
            color: context.onSurface,
          ),

          const SizedBox(height: 20),

          // Vehicle Type
          AppInput.dropdown(
            labelText: 'Araç Türü',
            hintText: 'Araç türünü seçin',
            dropdownItems: _vehicleTypes,
            dropdownValue: _selectedVehicleType,
            onDropdownChanged: widget.enabled
                ? (value) {
                    setState(() {
                      _selectedVehicleType = value;
                    });
                    _updateRequirement();
                  }
                : null,
            prefixIcon: Icons.local_shipping_outlined,
          ),

          const SizedBox(height: 16),

          // Brand
          AppInput.dropdown(
            labelText: 'Marka',
            hintText: 'Marka seçin',
            dropdownItems: _brands,
            dropdownValue: _selectedBrand,
            onDropdownChanged: widget.enabled
                ? (value) {
                    setState(() {
                      _selectedBrand = value;
                    });
                    _updateRequirement();
                  }
                : null,
            prefixIcon: Icons.branding_watermark_outlined,
          ),

          const SizedBox(height: 16),

          // Vehicle Count
          AppInput.primary(
            labelText: 'Araç Sayısı',
            hintText: 'Kaç araç gerekli?',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.confirmation_number_outlined,
            onChanged: widget.enabled
                ? (value) {
                    final count = int.tryParse(value) ?? 1;
                    setState(() {
                      _vehicleCount = count;
                    });
                    _updateRequirement();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
