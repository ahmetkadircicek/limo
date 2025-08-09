import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/enums/pickup_type_enum.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/coordinate_model.dart';
import 'package:soforvarcom/feature/job_list/model/job_model.dart';
import 'package:soforvarcom/feature/job_list/model/pricing_model.dart';
import 'package:soforvarcom/feature/job_list/model/vehicle_requirement_model.dart';
import 'package:soforvarcom/feature/listing_job/widgets/multiple_vehicle_requirements_form.dart';
import 'package:soforvarcom/feature/listing_job/widgets/pricing_input_form.dart';
import 'package:soforvarcom/feature/map/models/location_model.dart';
import 'package:soforvarcom/feature/map/widgets/location_field.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_dropdown.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';
import 'package:soforvarcom/shared/modern_snackbar.dart';

class ListingJobView extends StatefulWidget {
  const ListingJobView({super.key});

  @override
  State<ListingJobView> createState() => _ListingJobViewState();
}

class _ListingJobViewState extends State<ListingJobView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form values
  String? _selectedJobType = 'Point to Point'; // Default to Point to Point
  LocationModel? _fromLocation;
  LocationModel? _toLocation;
  List<VehicleRequirement> _vehicleRequirements = [];
  PricingModel? _pricing;

  @override
  void dispose() {
    _priceController.dispose();
    _companyNameController.dispose();
    _contactInfoController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PaddingConstants.horizontalXl,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTitle(),
                  context.spacerHeight(1),
                  _buildSubtitle(),
                  context.spacerHeight(3),
                  _buildJobForm(),
                  context.spacerHeight(3),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return GeneralText(
      text: 'Post New Job',
      fontSize: GeneralConstants.fontSizeTitle,
      fontWeight: GeneralConstants.fontWeightTitle,
    );
  }

  Widget _buildSubtitle() {
    return GeneralText(
      text: 'Fill in the information below to create your job listing.',
      fontSize: GeneralConstants.fontSizeBody,
      fontWeight: GeneralConstants.fontWeightBody,
      color: context.secondary,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildJobForm() {
    return Column(
      children: [
        // Company Information Section
        // Company Name
        GeneralTextField(
          controller: _companyNameController,
          hintText: 'Company Name',
          prefixIcon: const Icon(Icons.business),
        ),
        SizedBox(height: PaddingConstants.spacingM),

        // Contact Info
        GeneralTextField(
          controller: _contactInfoController,
          hintText: 'Contact Information',
          prefixIcon: const Icon(Icons.phone),
        ),
        SizedBox(height: PaddingConstants.spacingM),

        // Job Type
        GeneralDropdown(
          items: [
            'Point to Point',
            'Daily Rental',
            'Hourly Rental',
          ],
          hintText: 'Job Type',
          value: _selectedJobType,
          prefixIcon: const Icon(Icons.work),
          onChanged: (value) {
            setState(() {
              _selectedJobType = value;
              // Reset pricing when job type changes
              _pricing = null;
              // Reset drop-off location if not Point to Point
              if (value != 'Point to Point') {
                _toLocation = null;
              }
            });
          },
        ),
        SizedBox(height: PaddingConstants.spacingM),

        // Location Section
        // Pickup Location
        LocationField(
          hintText: 'Pickup Location',
          prefixIcon: const Icon(Icons.location_on),
          pickerTitle: 'Select Pickup Location',
          selectedLocation: _fromLocation,
          onLocationSelected: (location) {
            setState(() {
              _fromLocation = location;
            });
          },
        ),
        SizedBox(height: PaddingConstants.spacingM),

        // Drop-off Location (only for Point to Point)
        if (_selectedJobType == 'Point to Point') ...[
          LocationField(
            hintText: 'Drop-off Location',
            prefixIcon: const Icon(Icons.flag),
            pickerTitle: 'Select Drop-off Location',
            selectedLocation: _toLocation,
            onLocationSelected: (location) {
              setState(() {
                _toLocation = location;
              });
            },
          ),
          SizedBox(height: PaddingConstants.spacingM),

          // Route Distance Info
          if (_fromLocation != null && _toLocation != null) ...[
            _buildRouteDistanceInfo(),
            SizedBox(height: PaddingConstants.spacingM),
          ],
        ],

        // Vehicle Requirements
        MultipleVehicleRequirementsForm(
          initialRequirements: _vehicleRequirements,
          onRequirementsChanged: (requirements) {
            setState(() {
              _vehicleRequirements = requirements;
            });
          },
        ),
        SizedBox(height: PaddingConstants.spacingM),

        // Pricing Options
        PricingInputForm(
          initialPricing: _pricing,
          jobType: _selectedJobType != null
              ? JobType.values.firstWhere(
                  (e) => e.name == _selectedJobType,
                  orElse: () => JobType.pointToPoint,
                )
              : null,
          onPricingChanged: (pricing) {
            setState(() {
              _pricing = pricing;
            });
          },
        ),
        SizedBox(height: PaddingConstants.spacingM),

        // Description
        GeneralTextField(
          controller: _descriptionController,
          hintText: 'Description (Optional)',
          prefixIcon: const Icon(Icons.description),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildCreateJobButton(),
        SizedBox(height: PaddingConstants.spacingM),
        _buildClearButton(),
      ],
    );
  }

  Widget _buildCreateJobButton() {
    return SizedBox(
      width: double.infinity,
      child: GeneralButton(
        fontSize: GeneralConstants.fontSizeBody,
        color: context.primary,
        text: 'Create Job Listing',
        onPressed: _createJob,
      ),
    );
  }

  Widget _buildClearButton() {
    return GeneralButton(
      fontSize: GeneralConstants.fontSizeBody,
      color: context.surface,
      fontColor: context.secondary,
      text: 'Clear',
      onPressed: _clearForm,
    );
  }

  void _createJob() {
    // Manual validation with error dialogs
    if (_companyNameController.text.trim().isEmpty) {
      context.showErrorSnackbar(
        title: 'Error',
        message: 'Please enter company name',
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (_contactInfoController.text.trim().isEmpty) {
      context.showErrorSnackbar(
        title: 'Error',
        message: 'Please enter contact information',
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (_fromLocation == null) {
      context.showErrorSnackbar(
        title: 'Error',
        message: 'Please select a pickup location',
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (_selectedJobType == 'Point to Point' && _toLocation == null) {
      context.showErrorSnackbar(
        title: 'Error',
        message: 'Please select a drop-off location',
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // All validations passed, create job
    {
      // Convert string job type to enum
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

      // Convert LocationModel to Coordinate
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
        pickupType: jobType,
        companyName: _companyNameController.text,
        contactInfo: _contactInfoController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        vehicleRequirements: _vehicleRequirements,
        pricing: _pricing,
      );

      // In a real app, save the job to database
      print('Job created: ${job.id}');
      print(
          'Pickup Location: ${_fromLocation!.placeName} (${_fromLocation!.wazeUrl})');
      if (_toLocation != null) {
        print(
            'Drop-off Location: ${_toLocation!.placeName} (${_toLocation!.wazeUrl})');
      }
      if (_vehicleRequirements.isNotEmpty) {
        print('Vehicle Requirements:');
        for (int i = 0; i < _vehicleRequirements.length; i++) {
          print('  ${i + 1}. ${_vehicleRequirements[i].getDescription()}');
        }
      }
      if (_pricing != null && _pricing!.hasAnyPrice) {
        print('Pricing: ${_pricing!.getPricingSummary()}');
      }

      // Show success snackbar
      context.showSuccessSnackbar(
        title: 'Success',
        message: 'Job listing created successfully!',
        duration: const Duration(seconds: 3),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  void _clearForm() {
    setState(() {
      // Clear all controllers
      _priceController.clear();
      _companyNameController.clear();
      _contactInfoController.clear();
      _descriptionController.clear();

      // Reset form values to defaults
      _selectedJobType = 'Point to Point';
      _fromLocation = null;
      _toLocation = null;
      _vehicleRequirements = [];
      _pricing = null;
    });

    // Show clear confirmation snackbar
    context.showSuccessSnackbar(
      title: 'Cleared',
      message: 'Form has been cleared successfully!',
      duration: const Duration(seconds: 2),
    );
  }

  Widget _buildRouteDistanceInfo() {
    if (_fromLocation == null || _toLocation == null) {
      return const SizedBox.shrink();
    }

    // Calculate distance between two points using Haversine formula
    final distance = _calculateDistanceInMiles(
      _fromLocation!.latitude,
      _fromLocation!.longitude,
      _toLocation!.latitude,
      _toLocation!.longitude,
    );

    return Container(
      height: 48.0, // Same as text fields
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: context.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: context.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.route,
            size: 24.0,
            color: context.primary.withOpacity(0.7),
          ),
          SizedBox(width: PaddingConstants.spacingM),
          Expanded(
            child: Text(
              'Route distance: ${distance.toStringAsFixed(1)} miles',
              style: TextStyle(
                fontSize: 16.0, // Same as text fields
                color: context.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
