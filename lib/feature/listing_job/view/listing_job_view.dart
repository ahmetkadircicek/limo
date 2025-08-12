import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/coordinate_model.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:limo/feature/listing_job/services/job_creation_service.dart';
import 'package:limo/feature/listing_job/widgets/multiple_vehicle_requirements_form.dart';
import 'package:limo/feature/map/models/location_model.dart';
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
      backgroundColor: context.surfaceContainer,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: PaddingConstants.allL,
                        child: Column(
                          children: [
                            _buildCompanySection(),
                            SizedBox(height: PaddingConstants.spacingXl),
                            _buildJobTypeSection(),
                            SizedBox(height: PaddingConstants.spacingXl),
                            _buildLocationSection(),
                            SizedBox(height: PaddingConstants.spacingXl),
                            _buildVehicleSection(),
                            SizedBox(height: PaddingConstants.spacingXl),
                            _buildDescriptionSection(),
                            SizedBox(height: PaddingConstants.spacingXxl),
                            _buildActionButtons(),
                            SizedBox(
                                height: PaddingConstants.spacingXxl +
                                    PaddingConstants.spacingL),
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

  // Build company information section with form inputs
  Widget _buildCompanySection() {
    return _buildSection(
      title: 'Company Information',
      icon: Icons.business_outlined,
      children: [
        AppInput.primary(
          controller: _companyNameController,
          hintText: 'Enter your company name',
          prefixIcon: Icons.business,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _contactInfoController,
          hintText: 'Enter your phone number',
          prefixIcon: Icons.phone,
        ),
      ],
    );
  }

  // Build job type selection section with dropdown and info
  Widget _buildJobTypeSection() {
    return _buildSection(
      title: 'Job Type',
      icon: Icons.work_outline,
      children: [
        AppInput.dropdown(
          hintText: 'Select job type',
          dropdownItems: [
            'Point to Point',
            'Daily Rental',
            'Hourly Rental',
          ],
          dropdownValue: _selectedJobType,
          onDropdownChanged: (value) {
            setState(() {
              _selectedJobType = value;
              if (value != 'Point to Point') {
                _toLocation = null;
              }
            });
          },
          prefixIcon: Icons.work,
        ),
        const SizedBox(height: 8),
        _buildJobTypeInfoCard(),
      ],
    );
  }

  // Build info card explaining job type requirements
  Widget _buildJobTypeInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.onSurface.withValues(alpha: 0.6),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.caption(
              _selectedJobType == 'Point to Point'
                  ? 'Point-to-point transfer requires both pickup and destination locations'
                  : 'Daily/Hourly rental only requires pickup location',
              color: context.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Build location section with pickup and destination inputs
  Widget _buildLocationSection() {
    return _buildSection(
      title: 'Location Information',
      icon: Icons.location_on_outlined,
      children: [
        _buildLocationCard(
          title: 'Pickup Location',
          icon: Icons.radio_button_checked,
          color: const Color(0xFF10B981),
          location: _fromLocation,
          onTap: () => _showLocationPicker(
            title: 'Select Pickup Location',
            onLocationSelected: (location) {
              setState(() {
                _fromLocation = location;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedJobType == 'Point to Point') ...[
          _buildLocationCard(
            title: 'Destination Location',
            icon: Icons.location_on,
            color: const Color(0xFFEF4444),
            location: _toLocation,
            onTap: () => _showLocationPicker(
              title: 'Select Destination Location',
              onLocationSelected: (location) {
                setState(() {
                  _toLocation = location;
                });
              },
            ),
          ),
          if (_fromLocation != null && _toLocation != null) ...[
            const SizedBox(height: 16),
            _buildRouteInfo(),
          ],
        ] else ...[
          _buildOtherJobTypeInfoCard(),
        ],
      ],
    );
  }

  // Build info card for non-point-to-point job types
  Widget _buildOtherJobTypeInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.warning,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.caption(
              'For $_selectedJobType job type, only pickup location is required. Customers will receive service from this point.',
              color: context.warning,
            ),
          ),
        ],
      ),
    );
  }

  // Build vehicle requirements section
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

  // Build description section with optional text input
  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Description',
      icon: Icons.description_outlined,
      children: [
        AppInput.primary(
          controller: _descriptionController,
          hintText: 'Additional information about the job...',
          prefixIcon: Icons.description,
        ),
      ],
    );
  }

  // Build reusable section container with title and icon
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.surface,
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
            _buildSectionHeader(title, icon),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // Build section header with icon and title
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
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
        const SizedBox(width: 12),
        AppText.heading(
          title,
          color: context.onSurface,
        ),
      ],
    );
  }

  // Build location selection card with tap functionality
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
          color: context.surfaceContainer,
          borderRadius: GeneralConstants.borderRadius,
          border: Border.all(
            color: context.onSurface.withValues(alpha: 0.1),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: context.onSurface.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildLocationIcon(icon, color),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLocationInfo(title, location),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.chevron_right,
              color: context.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  // Build location icon with background
  Widget _buildLocationIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  // Build location information text
  Widget _buildLocationInfo(String title, LocationModel? location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          title,
          color: context.onSurface,
        ),
        AppText.bodySmall(
          location?.placeName ?? 'Select location',
          color: location != null
              ? context.onSurface
              : context.onSurface.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  // Build route information display with distance and time
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

    final distanceKm = distanceMiles * 1.60934;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.primary.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: context.onSurface.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteHeader(),
          const SizedBox(height: 12),
          _buildRouteMetrics(distanceKm),
          const SizedBox(height: 8),
          _buildRouteSummary(),
        ],
      ),
    );
  }

  // Build route header with icon and title
  Widget _buildRouteHeader() {
    return Row(
      children: [
        Icon(
          Icons.route,
          color: context.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        AppText.body(
          'Route Information',
          color: context.primary,
        ),
      ],
    );
  }

  // Build route metrics (distance and time)
  Widget _buildRouteMetrics(double distanceKm) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
              'Distance', '${distanceKm.toStringAsFixed(1)} km'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
              'Estimated Time', '${(distanceKm / 80).ceil()} hours'),
        ),
      ],
    );
  }

  // Build individual metric card
  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          AppText.caption(
            label,
            color: context.onSurface.withValues(alpha: 0.6),
          ),
          AppText.body(
            value,
            color: context.primary,
          ),
        ],
      ),
    );
  }

  // Build route summary text
  Widget _buildRouteSummary() {
    return AppText.bodySmall(
      '${_fromLocation!.placeName} → ${_toLocation!.placeName}',
      color: context.onSurface.withValues(alpha: 0.8),
    );
  }

  // Build action buttons section
  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildCreateJobButton(),
        _buildClearButton(),
      ],
    );
  }

  // Build create job button
  Widget _buildCreateJobButton() {
    return AppButton.primary(
      'Create Job Post',
      onPressed: () async {
        await _createJob();
      },
      width: double.infinity,
      height: 52,
    );
  }

  // Build clear form button
  Widget _buildClearButton() {
    return AppButton.tertiary(
      'Clear',
      onPressed: _clearForm,
      width: double.infinity,
      height: 52,
    );
  }

  // Show location picker modal
  void _showLocationPicker({
    required String title,
    required Function(LocationModel) onLocationSelected,
  }) {
    debugPrint("Navigation to Location Picker from Listing Job");
    context.push('/location-picker', extra: onLocationSelected);
  }

  // Create job with validation and service call
  Future<void> _createJob() async {
    if (!_validateForm()) return;

    final job = _buildJobModel();
    if (job == null) return;

    try {
      _showLoadingDialog();
      final response = await JobCreationService.createJob(job);
      context.pop();

      if (response['success'] == true) {
        JobCreationService.logDebugInfo(job);
        _showSuccessSnackbar('Job posted successfully!');
        if (context.mounted) {
          context.pop();
        }
      } else {
        _showErrorSnackbar(
            'Error creating job: ${response['error']['message']}');
      }
    } catch (error) {
      context.pop();
      _showErrorSnackbar('An unexpected error occurred: $error');
    }
  }

  // Validate form inputs
  bool _validateForm() {
    if (_companyNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter company name');
      return false;
    }

    if (_contactInfoController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter contact information');
      return false;
    }

    if (_fromLocation == null) {
      _showErrorSnackbar('Please select pickup location');
      return false;
    }

    if (_selectedJobType == 'Point to Point' && _toLocation == null) {
      _showErrorSnackbar('Please select destination location');
      return false;
    }

    if (_vehicleRequirements.isEmpty) {
      _showErrorSnackbar('Please add at least one vehicle requirement');
      return false;
    }

    if (!_validateVehicleRequirements()) return false;

    return true;
  }

  // Validate vehicle requirements
  bool _validateVehicleRequirements() {
    for (int i = 0; i < _vehicleRequirements.length; i++) {
      final requirement = _vehicleRequirements[i];
      if (!requirement.isFlexible) {
        if (requirement.minimumCategory == null) {
          _showErrorSnackbar(
              'Please select minimum category for vehicle requirement ${i + 1}');
          return false;
        }
        if (requirement.hourlyRate == null &&
            requirement.pricePerMile == null) {
          _showErrorSnackbar(
              'Please set at least one price for vehicle requirement ${i + 1}');
          return false;
        }
      }
    }
    return true;
  }

  // Build job model from form data
  JobModel? _buildJobModel() {
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

    return JobModel(
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
  }

  // Clear form and reset all values
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

    _showSuccessSnackbar('Form cleared successfully!');
  }

  // Show error snackbar with red background
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText.body(message),
        backgroundColor: context.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        dismissDirection: DismissDirection.up,
      ),
    );
  }

  // Show success snackbar with green background
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText.body(message),
        backgroundColor: context.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        dismissDirection: DismissDirection.up,
      ),
    );
  }

  // Show loading dialog during operations
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              AppText.body('Creating job...'),
            ],
          ),
        );
      },
    );
  }

  // Calculate distance between two coordinates using Haversine formula
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

  // Convert degrees to radians for distance calculation
  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
