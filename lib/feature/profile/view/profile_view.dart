import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  // Vehicle Information
  final List<Map<String, String>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // User data will be loaded from UserProvider
    // Mock data is kept as fallback for company and vehicle information
    _companyController.text = 'ABC Transport Company';
    _addressController.text = 'Istanbul, Turkey';
    _licenseController.text = '1234567890';

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
      {
        'brand': 'BMW',
        'model': 'X5',
        'year': '2021',
        'plateNumber': '34 GHI 789',
        'vehicleType': 'SUV',
      },
      {
        'brand': 'Audi',
        'model': 'A6',
        'year': '2022',
        'plateNumber': '34 JKL 012',
        'vehicleType': 'Sedan',
      },
      {
        'brand': 'Volkswagen',
        'model': 'Golf',
        'year': '2020',
        'plateNumber': '34 MNO 345',
        'vehicleType': 'Hatchback',
      },
      {
        'brand': 'Toyota',
        'model': 'Camry',
        'year': '2021',
        'plateNumber': '34 PQR 678',
        'vehicleType': 'Sedan',
      },
      {
        'brand': 'Honda',
        'model': 'CR-V',
        'year': '2022',
        'plateNumber': '34 STU 901',
        'vehicleType': 'SUV',
      },
      {
        'brand': 'Nissan',
        'model': 'Leaf',
        'year': '2023',
        'plateNumber': '34 VWX 234',
        'vehicleType': 'Electric',
      },
      {
        'brand': 'Hyundai',
        'model': 'Tucson',
        'year': '2021',
        'plateNumber': '34 YZA 567',
        'vehicleType': 'SUV',
      },
      {
        'brand': 'Kia',
        'model': 'Sportage',
        'year': '2022',
        'plateNumber': '34 BCD 890',
        'vehicleType': 'SUV',
      },
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Add a red background container
    return Container(
      color: context.surfaceContainer,
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Update controllers with user data if available
          if (userProvider.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (userProvider.userDisplayName != null) {
                _nameController.text = userProvider.userDisplayName!;
              }
              if (userProvider.userEmail != null) {
                _emailController.text = userProvider.userEmail!;
              }
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(context, userProvider),
                const SizedBox(height: 24),

                // User Information Section
                _buildUserInfoSection(context),
                const SizedBox(height: 24),

                // Company Information Section
                _buildCompanyInfoSection(context),
                const SizedBox(height: 24),

                // Vehicles Section
                _buildVehiclesSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 40,
            backgroundImage:
                userProvider.isLoggedIn && userProvider.userPhotoUrl != null
                    ? NetworkImage(userProvider.userPhotoUrl!)
                    : null,
            backgroundColor: context.primary.withOpacity(0.1),
            child: userProvider.isLoggedIn && userProvider.userPhotoUrl != null
                ? null
                : Icon(
                    Icons.person,
                    size: 40,
                    color: context.primary,
                  ),
          ),
          const SizedBox(width: 20),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProvider.userDisplayName ?? 'Kullanıcı Adı',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userProvider.userEmail ?? 'email@example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Aktif Kullanıcı',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.person,
                color: context.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Kişisel Bilgiler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        shape: const Border(), // Üst çizgiyi kaldır
        collapsedShape: const Border(), // Kapalı haldeki üst çizgiyi kaldır
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Column(
                  children: [
                    // Display Name (Read-only from Google)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: context.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ad Soyad',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userProvider.userDisplayName ??
                                      'Belirtilmemiş',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: context.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 10,
                                color: context.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email (Read-only from Google)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: context.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'E-posta',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userProvider.userEmail ?? 'Belirtilmemiş',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: context.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 10,
                                color: context.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone Number (Editable)
                    AppInput.primary(
                      controller: _phoneController,
                      labelText: 'Telefon',
                      hintText: 'Telefon numaranızı girin',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfoSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.business,
                color: context.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Şirket Bilgileri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        shape: const Border(), // Üst çizgiyi kaldır
        collapsedShape: const Border(), // Kapalı haldeki üst çizgiyi kaldır
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppInput.primary(
                  controller: _companyController,
                  labelText: 'Şirket Adı',
                  hintText: 'Şirket adını girin',
                  prefixIcon: Icons.business,
                ),
                const SizedBox(height: 16),
                AppInput.primary(
                  controller: _addressController,
                  labelText: 'Şirket Adresi',
                  hintText: 'Şirket adresini girin',
                  prefixIcon: Icons.location_on,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                AppInput.primary(
                  controller: _licenseController,
                  labelText: 'Vergi Numarası',
                  hintText: 'Vergi numarasını girin',
                  prefixIcon: Icons.receipt,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiclesSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.directions_car,
                color: context.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Araç Yönetimi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        shape: const Border(), // Üst çizgiyi kaldır
        collapsedShape: const Border(), // Kapalı haldeki üst çizgiyi kaldır
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Vehicle List
                ..._vehicles
                    .map((vehicle) => _buildVehicleCard(context, vehicle)),
                const SizedBox(height: 16),

                // Add New Vehicle Button
                SizedBox(
                  width: double.infinity,
                  child: AppButton.secondary(
                    'Yeni Araç Ekle',
                    onPressed: () => _showAddVehicleDialog(context),
                    icon: Icons.add,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, Map<String, String> vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.onSurface.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.directions_car,
              color: context.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle['brand']} ${vehicle['model']} (${vehicle['year']})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle['plateNumber'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle['vehicleType'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _editVehicle(context, vehicle),
            icon: Icon(
              Icons.edit,
              color: context.primary,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () => _deleteVehicle(context, vehicle),
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    // TODO: Implement add vehicle dialog
  }

  void _editVehicle(BuildContext context, Map<String, String> vehicle) {
    // TODO: Implement edit vehicle
  }

  void _deleteVehicle(BuildContext context, Map<String, String> vehicle) {
    // TODO: Implement delete vehicle
  }
}
