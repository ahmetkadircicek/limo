import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/enums/pickup_type_enum.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/model/location_data_model.dart';
import 'package:limo/feature/job_list/model/vehicle_requirement_model.dart';

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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _durationValue = 1;
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
                            _buildDateTimeSection(),
                            SizedBox(height: PaddingConstants.spacingXl),
                            _buildLocationSection(),
                            SizedBox(height: PaddingConstants.spacingXl),
                            _buildVehicleSection(),
                            SizedBox(height: PaddingConstants.spacingXl),
                            _buildDescriptionSection(),
                            SizedBox(height: PaddingConstants.spacingXxl),
                            _buildActionButtons(),
                            SizedBox(
                              height:
                                  PaddingConstants.spacingXxl +
                                  PaddingConstants.spacingL,
                            ),
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
      children: [
        AppInput.primary(
          controller: _companyNameController,
          labelText: 'Company Name',
          hintText: 'ABC Logistics Ltd.',
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          labelText: 'Contact Information',
          controller: _contactInfoController,
          hintText: '+1 (555) 123-4567',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  // Build job type selection section with dropdown and info
  Widget _buildJobTypeSection() {
    return _buildSection(
      title: 'Job Type',
      children: [
        AppInput.dropdown(
          labelText: 'Job Type',
          hintText: 'Select job type...',
          dropdownItems: ['Point to Point', 'Hourly Rental', 'Daily Rental'],
          dropdownValue: _selectedJobType,
          onDropdownChanged: (value) {
            setState(() {
              _selectedJobType = value;
              if (value != 'Point to Point') {
                _toLocation = null;
              }
            });
          },
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
        border: Border.all(color: context.onSurface.withValues(alpha: 0.1)),
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

  // Build date and time selection section
  Widget _buildDateTimeSection() {
    return _buildSection(
      title: 'Date & Time',
      children: [
        // Date Selection
        _buildDateField(),
        const SizedBox(height: 16),

        // Time Selection
        _buildTimeField(),
        const SizedBox(height: 16),

        // Duration Value Selection based on Job Type
        AppInput.dropdown(
          labelText: _selectedJobType == 'Hourly Rental' ? 'Hours' : 'Days',
          hintText: 'Select duration...',
          dropdownItems:
              _selectedJobType == 'Hourly Rental'
                  ? List.generate(23, (index) => (index + 1).toString())
                  : List.generate(30, (index) => (index + 1).toString()),
          dropdownValue: _durationValue.toString(),
          onDropdownChanged: (value) {
            setState(() {
              _durationValue = int.parse(value!);
            });
          },
        ),
      ],
    );
  }

  // Build date selection field using AppInfoCard
  Widget _buildDateField() {
    return AppInfoCard(
      icon: Icons.calendar_today,
      label: 'Pickup Date',
      onTap: () => _selectDate(context),
      value:
          _selectedDate != null
              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : 'Select pickup date',
      valueColor:
          _selectedDate != null
              ? context.onSurface
              : context.onSurface.withValues(alpha: 0.5),
    );
  }

  // Build time selection field using AppInfoCard
  Widget _buildTimeField() {
    return AppInfoCard(
      icon: Icons.access_time,
      iconColor: context.primary,
      label: 'Pickup Time',
      onTap: () => _selectTime(context),
      value:
          _selectedTime != null
              ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
              : 'Select pickup time',
      valueColor:
          _selectedTime != null
              ? context.onSurface
              : context.onSurface.withValues(alpha: 0.5),
    );
  }

  // Select date method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Select time method
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: Theme.of(context).timePickerTheme.copyWith(
                entryModeIconColor: Colors.transparent,
                // Keyboard input'u gizle
                hourMinuteTextStyle: GoogleFonts.montserrat(
                  fontSize: DesignTokens.h1.fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.transparent, // Saat/dakika text'i gizle
                  height: DesignTokens.h1.height,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Build location section with pickup and destination inputs
  Widget _buildLocationSection() {
    return _buildSection(
      title: 'Location Information',
      children: [
        AppInfoCard(
          icon: Icons.radio_button_checked,
          label: 'Pickup Location',
          value: _fromLocation?.placeName ?? 'Select location',
          iconColor: const Color(0xFF10B981),
          valueColor:
              _fromLocation != null
                  ? context.onSurface
                  : context.onSurface.withValues(alpha: 0.5),
          onTap:
              () => _showLocationPicker(
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
          AppInfoCard(
            icon: Icons.location_on,
            label: 'Destination Location',
            value: _toLocation?.placeName ?? 'Select location',
            iconColor: const Color(0xFFEF4444),
            valueColor:
                _toLocation != null
                    ? context.onSurface
                    : context.onSurface.withValues(alpha: 0.5),
            onTap:
                () => _showLocationPicker(
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
        border: Border.all(color: context.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: context.warning, size: 16),
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
      children: [
        AppInput.primary(
          controller: _descriptionController,
          labelText: 'Job Description',
          hintText: 'Job details, requirements...',
        ),
      ],
    );
  }

  // Build reusable section container with title and icon
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: GeneralConstants.borderRadius,
        boxShadow: [
          BoxShadow(
            color: context.onSurface.withValues(alpha: 0.04),
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
            _buildSectionHeader(title),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // Build section header with title only
  Widget _buildSectionHeader(String title) {
    return AppText.heading(title, color: context.onSurface);
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
        Icon(Icons.route, color: context.primary, size: 20),
        const SizedBox(width: 12),
        AppText.body('Route Information', color: context.primary),
      ],
    );
  }

  // Build route metrics (distance and time)
  Widget _buildRouteMetrics(double distanceKm) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Distance',
            '${distanceKm.toStringAsFixed(1)} km',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            'Estimated Time',
            '${(distanceKm / 80).ceil()} hours',
          ),
        ),
      ],
    );
  }

  // Build individual metric card
  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: PaddingConstants.allS,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: GeneralConstants.borderRadius,
        border: Border.all(color: context.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          AppText.caption(
            label,
            color: context.onSurface.withValues(alpha: 0.6),
          ),
          AppText.body(value, color: context.primary),
        ],
      ),
    );
  }

  // Build route summary text with icon inside a nice container
  Widget _buildRouteSummary() {
    final from = _fromLocation?.placeName.trim();
    final to = _toLocation?.placeName.trim();

    String summary;
    if ((from?.isNotEmpty ?? false) && (to?.isNotEmpty ?? false)) {
      summary = '$from → $to';
    } else if (from?.isNotEmpty ?? false) {
      summary = from!;
    } else if (to?.isNotEmpty ?? false) {
      summary = to!;
    } else {
      summary = 'Route not specified';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.location_on,
            size: 16,
            color: context.primary.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: AppText.bodySmall(
            summary,
            color: context.onSurface.withValues(alpha: 0.8),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Build action buttons section
  Widget _buildActionButtons() {
    return Column(children: [_buildCreateJobButton(), _buildClearButton()]);
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
  }) async {
    

    // TODO: Navigate to location picker page
    // For now, just show a message or handle differently
  }

  // Create job with validation and service call
  Future<void> _createJob() async {
    if (!_validateForm()) return;

    final job = _buildJobModel();
    if (job == null) return;

    try {
      _showLoadingDialog();
      // TODO: Implement job creation
      _showSuccessSnackbar('Job creation henüz implement edilmedi');
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      Navigator.of(context).pop();
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

    if (_selectedDate == null) {
      _showErrorSnackbar('Please select pickup date');
      return false;
    }

    if (_selectedTime == null) {
      _showErrorSnackbar('Please select pickup time');
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
      if (requirement.specificBrand != null ||
          requirement.specificVehicleType != null) {
        if (requirement.minimumCategory == null) {
          _showErrorSnackbar(
            'Please select minimum category for vehicle requirement ${i + 1}',
          );
          return false;
        }
        if (requirement.hourlyRate == null &&
            requirement.pricePerMile == null) {
          _showErrorSnackbar(
            'Please set at least one price for vehicle requirement ${i + 1}',
          );
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

    final fromLocationData = LocationData(
      placeName: _fromLocation!.placeName,
      address: _fromLocation!.address,
      latitude: _fromLocation!.latitude,
      longitude: _fromLocation!.longitude,
      placeId: _fromLocation!.placeId,
    );

    final toLocationData =
        _toLocation != null
            ? LocationData(
              placeName: _toLocation!.placeName,
              address: _toLocation!.address,
              latitude: _toLocation!.longitude,
              longitude: _toLocation!.longitude,
              placeId: _toLocation!.placeId,
            )
            : null;

    // Calculate start and end dates based on selected date, time and duration
    final startDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final endDateTime =
        _selectedJobType == 'Hourly Rental'
            ? startDateTime.add(Duration(hours: _durationValue))
            : startDateTime.add(Duration(days: _durationValue));

    return JobModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),

      fromLocation: fromLocationData,
      toLocation: toLocationData,

      jobType: jobType,
      companyName: _companyNameController.text,
      contactInfo: _contactInfoController.text,
      description:
          _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
      startDate: startDateTime,
      endDate: endDateTime,
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
      _selectedDate = null;
      _selectedTime = null;
      _durationValue = 1;
      _fromLocation = null;
      _toLocation = null;
      _vehicleRequirements = [];
    });

    _showSuccessSnackbar('Form cleared successfully!');
  }

  // Show error snackbar with red background
  void _showErrorSnackbar(String message) {
    AppSnackbar.showError(context, message: message);
  }

  // Show success snackbar with green background
  void _showSuccessSnackbar(String message) {
    AppSnackbar.showSuccess(context, message: message);
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
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    const double kmToMiles = 0.621371;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
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
