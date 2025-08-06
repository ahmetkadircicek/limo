import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/enums/pickup_type_enum.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/job_list/model/coordinate_model.dart';
import 'package:soforvarcom/feature/job_list/model/job_model.dart';
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
  final TextEditingController _fromProvinceController = TextEditingController();
  final TextEditingController _toProvinceController = TextEditingController();
  final TextEditingController _fromCityController = TextEditingController();
  final TextEditingController _toCityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vehicleCountController = TextEditingController();

  // Form values
  String? _selectedJobType;
  Coordinate? _fromLocation;
  Coordinate? _toLocation;

  @override
  void dispose() {
    _fromProvinceController.dispose();
    _toProvinceController.dispose();
    _fromCityController.dispose();
    _toCityController.dispose();
    _priceController.dispose();
    _companyNameController.dispose();
    _contactInfoController.dispose();
    _descriptionController.dispose();
    _vehicleCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PaddingConstants.allMedium,
          child: Column(
            children: [
              _buildTitle(),
              context.spacerHeight(1),
              _buildSubtitle(),
              context.spacerHeight(3),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildJobForm(),
                        context.spacerHeight(3),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return GeneralText(
      text: 'Yeni İş İlanı',
      fontSize: GeneralConstants.fontSizeLarge,
      fontWeight: GeneralConstants.fontWeightBold,
    );
  }

  Widget _buildSubtitle() {
    return GeneralText(
      text: 'İş ilanınızı oluşturmak için aşağıdaki bilgileri doldurun.',
      fontSize: GeneralConstants.fontSizeSmall,
      fontWeight: GeneralConstants.fontWeightLight,
      color: context.secondary,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildJobForm() {
    return Column(
      children: [
        // Job Type
        GeneralDropdown(
          items: [
            'Nokta-Nokta Taşıma',
            'Günlük Kiralama',
            'Saatlik Kiralama',
          ],
          hintText: 'İş Türü',
          value: _selectedJobType,
          prefixIcon: const Icon(Icons.work),
          onChanged: (value) {
            setState(() {
              _selectedJobType = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // From Province
        GeneralTextField(
          controller: _fromProvinceController,
          hintText: 'Nereden (İl)',
          prefixIcon: const Icon(Icons.location_on),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen çıkış ilini girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // From City
        GeneralTextField(
          controller: _fromCityController,
          hintText: 'Nereden (İlçe)',
          prefixIcon: const Icon(Icons.place),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen çıkış ilçesini girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // To Province
        GeneralTextField(
          controller: _toProvinceController,
          hintText: 'Nereye (İl)',
          prefixIcon: const Icon(Icons.location_on),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen varış ilini girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // To City
        GeneralTextField(
          controller: _toCityController,
          hintText: 'Nereye (İlçe)',
          prefixIcon: const Icon(Icons.place),
        ),
        const SizedBox(height: 16),

        // Vehicle Count
        GeneralTextField(
          controller: _vehicleCountController,
          hintText: 'Araç Sayısı',
          prefixIcon: const Icon(Icons.directions_car),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen araç sayısını girin';
            }
            final count = int.tryParse(value);
            if (count == null || count <= 0) {
              return 'Lütfen geçerli bir araç sayısı girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Price (Optional)
        GeneralTextField(
          controller: _priceController,
          hintText: 'Fiyat (Opsiyonel - Boş bırakılırsa teklif usulü)',
          prefixIcon: const Icon(Icons.monetization_on),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Lütfen geçerli bir fiyat girin';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Company Name
        GeneralTextField(
          controller: _companyNameController,
          hintText: 'Şirket Adı',
          prefixIcon: const Icon(Icons.business),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen şirket adını girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Contact Info
        GeneralTextField(
          controller: _contactInfoController,
          hintText: 'İletişim Bilgisi',
          prefixIcon: const Icon(Icons.phone),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen iletişim bilgisini girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Description
        GeneralTextField(
          controller: _descriptionController,
          hintText: 'Açıklama (Opsiyonel)',
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
        const SizedBox(height: 12),
        _buildCancelButton(),
      ],
    );
  }

  Widget _buildCreateJobButton() {
    return SizedBox(
      width: double.infinity,
      height: GeneralConstants.heightMedium,
      child: GeneralButton(
        fontSize: GeneralConstants.fontSizeMedium,
        color: context.primary,
        text: 'İş İlanı Oluştur',
        onPressed: _createJob,
      ),
    );
  }

  Widget _buildCancelButton() {
    return GeneralButton(
      fontSize: GeneralConstants.fontSizeSmall,
      color: context.surface,
      fontColor: context.secondary,
      text: 'İptal',
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  void _createJob() {
    if (_formKey.currentState!.validate()) {
      // Create mock coordinates (in a real app, you'd get these from a map/geocoding service)
      _fromLocation = Coordinate(latitude: 40.0, longitude: 32.0);
      _toLocation = Coordinate(latitude: 41.0, longitude: 33.0);

      // Convert string job type to enum
      JobType? jobType;
      if (_selectedJobType != null) {
        switch (_selectedJobType!) {
          case 'Nokta-Nokta Taşıma':
            jobType = JobType.pointToPoint;
            break;
          case 'Günlük Kiralama':
            jobType = JobType.fullDay;
            break;
          case 'Saatlik Kiralama':
            jobType = JobType.hourly;
            break;
        }
      }

      final job = JobModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromProvince: _fromProvinceController.text.toUpperCase(),
        toProvince: _toProvinceController.text.toUpperCase(),
        fromLocation: _fromLocation!,
        toLocation: _toLocation,
        fromCity: _fromCityController.text.isNotEmpty
            ? _fromCityController.text
            : null,
        toCity:
            _toCityController.text.isNotEmpty ? _toCityController.text : null,
        price: _priceController.text.isNotEmpty
            ? double.tryParse(_priceController.text)
            : null,
        pickupType: jobType,
        companyName: _companyNameController.text,
        contactInfo: _contactInfoController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        vehicleCount: int.tryParse(_vehicleCountController.text),
      );

      // In a real app, save the job to database
      print('Job created: ${job.id}');

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
}
