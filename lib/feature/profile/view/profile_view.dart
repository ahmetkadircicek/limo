import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/elevated_expansion_tile.dart';
import 'package:soforvarcom/shared/elevated_material.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();

  // User Information Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Company Information Controllers
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _taxNumberController = TextEditingController();

  // Vehicle Information
  final List<Map<String, String>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+90 555 123 4567';
    _companyNameController.text = 'ABC Transport Company';
    _companyAddressController.text = 'Istanbul, Turkey';
    _taxNumberController.text = '1234567890';

    _vehicles.addAll([
      {
        'brand': 'Mercedes',
        'model': 'Actros',
        'year': '2020',
        'plateNumber': '34 ABC 123',
        'vehicleType': 'Truck',
      },
      {
        'brand': 'Ford',
        'model': 'Transit',
        'year': '2019',
        'plateNumber': '34 DEF 456',
        'vehicleType': 'Van',
      },
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _taxNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceContainer,
      child: SingleChildScrollView(
        child: Padding(
          padding: PaddingConstants.allMedium,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildPersonalInformation(),
                const SizedBox(height: 16),
                _buildCompanyInformation(),
                const SizedBox(height: 16),
                _buildVehicleManagement(),
                const SizedBox(height: 16),
                _buildChangePassword(),
                const SizedBox(height: 24),
                _buildActionButtons(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return ElevatedExpansionTile(
      initiallyExpanded: true,
      title: Row(
        children: [
          Icon(
            Icons.person,
            size: GeneralConstants.fontSizeMedium,
            color: context.primary,
          ),
          const SizedBox(width: 8),
          GeneralText(
            text: 'Personal Information',
            fontSize: GeneralConstants.fontSizeSmall,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.onSurface,
          ),
        ],
      ),
      children: [
        Padding(
          padding: PaddingConstants.allMedium,
          child: Column(
            children: [
              _buildTextField('Full Name', _nameController),
              const SizedBox(height: 16),
              _buildTextField('Email', _emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField('Phone Number', _phoneController,
                  keyboardType: TextInputType.phone),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyInformation() {
    return ElevatedExpansionTile(
      title: Row(
        children: [
          Icon(
            Icons.business,
            size: GeneralConstants.fontSizeMedium,
            color: context.primary,
          ),
          const SizedBox(width: 8),
          GeneralText(
            text: 'Company Information',
            fontSize: GeneralConstants.fontSizeSmall,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.onSurface,
          ),
        ],
      ),
      children: [
        Padding(
          padding: PaddingConstants.allMedium,
          child: Column(
            children: [
              _buildTextField('Company Name', _companyNameController),
              const SizedBox(height: 16),
              _buildTextField('Company Address', _companyAddressController,
                  maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField('Tax Number', _taxNumberController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleManagement() {
    return ElevatedExpansionTile(
      title: Row(
        children: [
          Icon(
            Icons.local_shipping,
            size: GeneralConstants.fontSizeMedium,
            color: context.primary,
          ),
          const SizedBox(width: 8),
          GeneralText(
            text: 'Vehicle Management',
            fontSize: GeneralConstants.fontSizeSmall,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.onSurface,
          ),
          const Spacer(),
          GeneralText(
            text: '(${_vehicles.length} vehicles)',
            fontSize: GeneralConstants.fontSizeExtraSmall,
            color: context.secondary,
          ),
        ],
      ),
      children: [
        Padding(
          padding: PaddingConstants.allMedium,
          child: Column(
            children: [
              // Add Vehicle Button
              SizedBox(
                width: double.infinity,
                child: GeneralButton(
                  text: 'Add New Vehicle',
                  color: context.secondary,
                  fontSize: GeneralConstants.fontSizeSmall,
                  onPressed: _showAddVehicleDialog,
                ),
              ),
              const SizedBox(height: 16),

              // Vehicle List
              if (_vehicles.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _vehicles.length,
                  itemBuilder: (context, index) {
                    return _buildVehicleCard(_vehicles[index], index);
                  },
                ),
              ] else ...[
                GeneralText(
                  text: 'No vehicles added yet',
                  fontSize: GeneralConstants.fontSizeSmall,
                  color: context.secondary,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(Map<String, String> vehicle, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedMaterial(
        child: Container(
          padding: PaddingConstants.allMedium,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GeneralText(
                      text:
                          '${vehicle['brand']} ${vehicle['model']} (${vehicle['year']})',
                      fontSize: GeneralConstants.fontSizeSmall,
                      fontWeight: GeneralConstants.fontWeightBold,
                      color: context.onSurface,
                    ),
                    const SizedBox(height: 4),
                    GeneralText(
                      text:
                          'Plate: ${vehicle['plateNumber']} | Type: ${vehicle['vehicleType']}',
                      fontSize: GeneralConstants.fontSizeExtraSmall,
                      color: context.secondary,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _removeVehicle(index),
                icon: Icon(
                  Icons.delete_outline,
                  color: context.error,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangePassword() {
    return ElevatedExpansionTile(
      title: Row(
        children: [
          Icon(
            Icons.lock_outline,
            size: GeneralConstants.fontSizeMedium,
            color: context.primary,
          ),
          const SizedBox(width: 8),
          GeneralText(
            text: 'Change Password',
            fontSize: GeneralConstants.fontSizeSmall,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.onSurface,
          ),
        ],
      ),
      children: [
        Padding(
          padding: PaddingConstants.allMedium,
          child: Column(
            children: [
              _buildTextField('Current Password', TextEditingController(),
                  isPassword: true),
              const SizedBox(height: 16),
              _buildTextField('New Password', TextEditingController(),
                  isPassword: true),
              const SizedBox(height: 16),
              _buildTextField('Confirm New Password', TextEditingController(),
                  isPassword: true),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: GeneralButton(
                  text: 'Update Password',
                  color: context.secondary,
                  fontSize: GeneralConstants.fontSizeSmall,
                  onPressed: _updatePassword,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GeneralText(
          text: label,
          fontSize: GeneralConstants.fontSizeSmall,
          fontWeight: GeneralConstants.fontWeightBold,
          color: context.onSurface,
        ),
        const SizedBox(height: 8),
        GeneralTextField(
          controller: controller,
          hintText: label,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: isPassword,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: GeneralButton(
            text: 'Save Profile',
            color: context.primary,
            fontSize: GeneralConstants.fontSizeSmall,
            onPressed: _saveProfile,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: GeneralButton(
            text: 'Delete Account',
            color: context.error,
            fontSize: GeneralConstants.fontSizeSmall,
            onPressed: _deleteAccount,
          ),
        ),
      ],
    );
  }

  void _showAddVehicleDialog() {
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final yearController = TextEditingController();
    final plateController = TextEditingController();
    String selectedVehicleType = 'Truck';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Vehicle'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: plateController,
                decoration: const InputDecoration(labelText: 'Plate Number'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedVehicleType,
                decoration: const InputDecoration(labelText: 'Vehicle Type'),
                items: ['Truck', 'Van', 'Car', 'Bus', 'Motorcycle'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  selectedVehicleType = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (brandController.text.isNotEmpty &&
                  modelController.text.isNotEmpty &&
                  yearController.text.isNotEmpty &&
                  plateController.text.isNotEmpty) {
                setState(() {
                  _vehicles.add({
                    'brand': brandController.text,
                    'model': modelController.text,
                    'year': yearController.text,
                    'plateNumber': plateController.text,
                    'vehicleType': selectedVehicleType,
                  });
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeVehicle(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Vehicle'),
        content: const Text('Are you sure you want to remove this vehicle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _vehicles.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _updatePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Password update functionality will be implemented')),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Account deletion functionality will be implemented')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
