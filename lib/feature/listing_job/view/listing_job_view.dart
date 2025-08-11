import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/coordinate_model.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/listing_job/widgets/multiple_vehicle_requirements_form.dart';
import 'package:limo/feature/map/models/location_model.dart';
import 'package:limo/feature/map/widgets/location_picker.dart';
import 'package:limo/shared/app_components.dart';

class ListingJobView extends StatefulWidget {
  const ListingJobView({super.key});

  @override
  State<ListingJobView> createState() => _ListingJobViewState();
}

class _ListingJobViewState extends State<ListingJobView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form values
  String? _selectedJobType = 'Point to Point';
  LocationModel? _fromLocation;
  LocationModel? _toLocation;
  List<VehicleRequirement> _vehicleRequirements = [];

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactInfoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Form Content
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildCompanySection(),
                            const SizedBox(height: 24),
                            _buildJobTypeSection(),
                            const SizedBox(height: 24),
                            _buildLocationSection(),
                            const SizedBox(height: 24),
                            _buildVehicleSection(),
                            const SizedBox(height: 24),
                            _buildDescriptionSection(),
                            const SizedBox(height: 32),
                            _buildActionButtons(),
                            const SizedBox(
                                height:
                                    96), // Added 80px bottom padding for navigation bar
                          ],
                        ),
                      ),
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

  Widget _buildCompanySection() {
    return _buildSection(
      title: 'Company Information',
      icon: Icons.business_outlined,
      children: [
        AppInput.primary(
          controller: _companyNameController,
          labelText: 'Company Name',
          hintText: 'Enter your company name',
          prefixIcon: Icons.business,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _contactInfoController,
          labelText: 'Contact Information',
          hintText: 'Enter your phone number',
          prefixIcon: Icons.phone,
        ),
      ],
    );
  }

  Widget _buildJobTypeSection() {
    return _buildSection(
      title: 'İş Türü',
      icon: Icons.work_outline,
      children: [
        AppInput.dropdown(
          labelText: 'İş Türü',
          hintText: 'İş türünü seçin',
          dropdownItems: [
            'Point to Point',
            'Daily Rental',
            'Hourly Rental',
          ],
          dropdownValue: _selectedJobType,
          onDropdownChanged: (value) {
            setState(() {
              _selectedJobType = value;

              // Sadece Point to Point için varış noktası gerekli
              if (value != 'Point to Point') {
                _toLocation = null;
              }
            });
          },
          prefixIcon: Icons.work,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFF6B7280),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedJobType == 'Point to Point'
                      ? 'Noktadan noktaya transfer için başlangıç ve varış noktası gerekli'
                      : 'Günlük/Saatlik kiralama için sadece başlangıç noktası gerekli',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return _buildSection(
      title: 'Lokasyon Bilgileri',
      icon: Icons.location_on_outlined,
      children: [
        // Başlangıç Lokasyonu (Tüm iş türleri için gerekli)
        _buildLocationCard(
          title: 'Başlangıç Lokasyonu',
          icon: Icons.radio_button_checked,
          color: const Color(0xFF10B981),
          location: _fromLocation,
          onTap: () => _showLocationPicker(
            title: 'Başlangıç Lokasyonu Seçin',
            onLocationSelected: (location) {
              setState(() {
                _fromLocation = location;
              });
            },
          ),
        ),

        const SizedBox(height: 16),

        // Varış Lokasyonu (Sadece Point to Point için)
        if (_selectedJobType == 'Point to Point') ...[
          _buildLocationCard(
            title: 'Varış Lokasyonu',
            icon: Icons.location_on,
            color: const Color(0xFFEF4444),
            location: _toLocation,
            onTap: () => _showLocationPicker(
              title: 'Varış Lokasyonu Seçin',
              onLocationSelected: (location) {
                setState(() {
                  _toLocation = location;
                });
              },
            ),
          ),

          // Rota Bilgisi (Sadece her iki lokasyon da seçildiğinde)
          if (_fromLocation != null && _toLocation != null) ...[
            const SizedBox(height: 16),
            _buildRouteInfo(),
          ],
        ] else ...[
          // Diğer iş türleri için bilgi kartı
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFF59E0B),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFFF59E0B),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$_selectedJobType iş türü için sadece başlangıç lokasyonu yeterli. Müşteriler bu noktadan hizmet alacak.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVehicleSection() {
    return _buildSection(
      title: 'Vehicle Requirements',
      icon: Icons.local_shipping_outlined,
      children: [
        MultipleVehicleRequirementsForm(
          initialRequirements: _vehicleRequirements,
          onRequirementsChanged: (requirements) {
            setState(() {
              _vehicleRequirements = requirements;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Description',
      icon: Icons.description_outlined,
      children: [
        AppInput.primary(
          controller: _descriptionController,
          labelText: 'Description (Optional)',
          hintText: 'Additional information about the job...',
          prefixIcon: Icons.description,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard({
    required String title,
    required IconData icon,
    required Color color,
    required LocationModel? location,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16), // Daha yuvarlak köşeler
          border: Border.all(
            color: context.onSurface.withValues(alpha: 0.1),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(12), // Daha yuvarlak köşeler
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location?.placeName ?? 'Lokasyon seçin',
                    style: TextStyle(
                      fontSize: 16,
                      color: location != null
                          ? context.onSurface
                          : context.onSurface.withValues(alpha: 0.5),
                      fontWeight: location != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfo() {
    if (_fromLocation == null || _toLocation == null) {
      return const SizedBox.shrink();
    }

    final distanceMiles = _calculateDistanceInMiles(
      _fromLocation!.latitude,
      _fromLocation!.longitude,
      _toLocation!.latitude,
      _toLocation!.longitude,
    );

    final distanceKm = distanceMiles * 1.60934; // Convert miles to kilometers

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.primary.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.route,
                color: context.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Rota Bilgileri',
                style: TextStyle(
                  color: context.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Mesafe',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        '${distanceKm.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tahmini Süre',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        '${(distanceKm / 80).ceil()} saat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_fromLocation!.placeName} → ${_toLocation!.placeName}',
            style: TextStyle(
              fontSize: 14,
              color: context.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Create Job Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _createJob,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'İş İlanı Oluştur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Clear Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: _clearForm,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6B7280),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Temizle',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLocationPicker({
    required String title,
    required Function(LocationModel) onLocationSelected,
  }) {
    // Show location picker directly (map page)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          title: title,
          onLocationSelected: onLocationSelected,
        ),
      ),
    );
  }

  void _createJob() {
    // Validation
    if (_companyNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter company name');
      return;
    }

    if (_contactInfoController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter contact information');
      return;
    }

    if (_fromLocation == null) {
      _showErrorSnackbar('Please select pickup location');
      return;
    }

    if (_selectedJobType == 'Point to Point' && _toLocation == null) {
      _showErrorSnackbar('Please select destination location');
      return;
    }

    // Validate vehicle requirements
    if (_vehicleRequirements.isEmpty) {
      _showErrorSnackbar('Please add at least one vehicle requirement');
      return;
    }

    // Validate that specific requirements have category and pricing
    for (int i = 0; i < _vehicleRequirements.length; i++) {
      final requirement = _vehicleRequirements[i];
      if (!requirement.isFlexible) {
        if (requirement.minimumCategory == null) {
          _showErrorSnackbar(
              'Please select minimum category for vehicle requirement ${i + 1}');
          return;
        }
        if (requirement.hourlyRate == null &&
            requirement.pricePerMile == null) {
          _showErrorSnackbar(
              'Please set at least one price for vehicle requirement ${i + 1}');
          return;
        }
      }
    }

    // Create job
    JobType? jobType;
    if (_selectedJobType != null) {
      switch (_selectedJobType!) {
        case 'Point to Point':
          jobType = JobType.pointToPoint;
          break;
        case 'Daily Rental':
          jobType = JobType.fullDay;
          break;
        case 'Hourly Rental':
          jobType = JobType.hourly;
          break;
      }
    }

    final fromCoordinate = Coordinate(
      latitude: _fromLocation!.latitude,
      longitude: _fromLocation!.longitude,
    );

    final toCoordinate = _toLocation != null
        ? Coordinate(
            latitude: _toLocation!.latitude,
            longitude: _toLocation!.longitude,
          )
        : null;

    final job = JobModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromProvince: _fromLocation!.placeName.toUpperCase(),
      toProvince: _toLocation?.placeName.toUpperCase() ?? '',
      fromLocation: fromCoordinate,
      toLocation: toCoordinate,
      fromCity: _fromLocation!.address,
      toCity: _toLocation?.address,
      jobType: jobType,
      companyName: _companyNameController.text,
      contactInfo: _contactInfoController.text,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      vehicleRequirements: _vehicleRequirements,
    );

    // TODO: Save job to database
    debugPrint('Job created: ${job.id}');
    debugPrint('Company: ${job.companyName}');
    debugPrint('From: ${job.fromProvince} To: ${job.toProvince}');

    _showSuccessSnackbar('İş ilanı başarıyla oluşturuldu!');
    Navigator.pop(context);
  }

  void _clearForm() {
    setState(() {
      _companyNameController.clear();
      _contactInfoController.clear();
      _descriptionController.clear();
      _selectedJobType = 'Point to Point';
      _fromLocation = null;
      _toLocation = null;
      _vehicleRequirements = [];
    });

    _showSuccessSnackbar('Form başarıyla temizlendi!');
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  double _calculateDistanceInMiles(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    const double kmToMiles = 0.621371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distanceKm = earthRadiusKm * c;

    return distanceKm * kmToMiles;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
