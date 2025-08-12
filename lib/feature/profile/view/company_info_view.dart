import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/company_registration/model/company_model.dart';
import 'package:limo/shared/app_components.dart';

class CompanyInfoView extends StatefulWidget {
  const CompanyInfoView({super.key});

  @override
  State<CompanyInfoView> createState() => _CompanyInfoViewState();
}

class _CompanyInfoViewState extends State<CompanyInfoView> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _authorizedPersonController =
      TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _companyTaxNumberController =
      TextEditingController();
  final TextEditingController _companyWebsiteController =
      TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  final TextEditingController _companyFoundedYearController =
      TextEditingController();
  final TextEditingController _companyEmployeeCountController =
      TextEditingController();

  bool _isEditing = false;
  CompanyModel? _currentCompany;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  void _loadCompanyData() {
    // Load company data from storage or provider
    _currentCompany = CompanyModel(
      companyName: 'ABC Transport Company',
      authorizedPerson: 'Ahmet Yılmaz',
      companyAddress: 'Istanbul, Turkey',
      companyPhone: '+90 212 555 0123',
      companyEmail: 'info@abctransport.com',
      taxNumber: '1234567890',
      companyWebsite: 'www.abctransport.com',
      companyDescription:
          'Leading transportation company specializing in logistics and freight services across Turkey and Europe.',
      foundedYear: '2015',
      employeeCount: '150+',
      companyType: 'Transportation & Logistics',
      serviceAreas: '25 Cities',
    );

    _companyNameController.text = _currentCompany!.companyName;
    _authorizedPersonController.text = _currentCompany!.authorizedPerson;
    _companyAddressController.text = _currentCompany!.companyAddress;
    _companyPhoneController.text = _currentCompany!.companyPhone;
    _companyEmailController.text = _currentCompany!.companyEmail;
    _companyTaxNumberController.text = _currentCompany!.taxNumber;
    _companyWebsiteController.text = _currentCompany!.companyWebsite ?? '';
    _companyDescriptionController.text =
        _currentCompany!.companyDescription ?? '';
    _companyFoundedYearController.text = _currentCompany!.foundedYear ?? '';
    _companyEmployeeCountController.text = _currentCompany!.employeeCount ?? '';
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _authorizedPersonController.dispose();
    _companyAddressController.dispose();
    _companyPhoneController.dispose();
    _companyEmailController.dispose();
    _companyTaxNumberController.dispose();
    _companyWebsiteController.dispose();
    _companyDescriptionController.dispose();
    _companyFoundedYearController.dispose();
    _companyEmployeeCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText.heading('Company Management'),
        backgroundColor: context.surface,
        foregroundColor: context.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _cancelEditing();
                } else {
                  _startEditing();
                }
              });
            },
          ),
        ],
      ),
      backgroundColor: context.surfaceContainer,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with company overview
              _buildCompanyOverviewHeader(),
              const SizedBox(height: 24),

              // Company details section
              _buildCompanyDetailsSection(),
              const SizedBox(height: 24),

              // Contact information section
              _buildContactInfoSection(),
              const SizedBox(height: 24),

              // Additional company information
              _buildAdditionalInfoSection(),
              const SizedBox(height: 24),

              // Company statistics
              _buildCompanyStatsSection(),
              const SizedBox(height: 32),

              // Action buttons
              if (_isEditing) _buildActionButtons(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyOverviewHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.business,
                  color: context.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title(
                      _currentCompany?.companyName ?? 'Company Name',
                      color: context.onSurface,
                    ),
                    const SizedBox(height: 8),
                    AppText.body(
                      _currentCompany?.companyType ??
                          'Transportation & Logistics',
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    AppText.bodySmall(
                      'Established in ${_companyFoundedYearController.text}',
                      color: context.onSurface.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Employees',
                    _companyEmployeeCountController.text, Icons.people),
                _buildStatItem('Founded', _companyFoundedYearController.text,
                    Icons.calendar_today),
                _buildStatItem('Tax Number', _companyTaxNumberController.text,
                    Icons.receipt),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: context.primary, size: 24),
        const SizedBox(height: 8),
        AppText.body(
          value,
          fontWeight: FontWeight.bold,
          color: context.onSurface,
        ),
        AppText.caption(
          label,
          color: context.onSurface.withValues(alpha: 0.6),
        ),
      ],
    );
  }

  Widget _buildCompanyDetailsSection() {
    return _buildSectionCard(
      title: 'Company Details',
      icon: Icons.business,
      iconColor: context.primary,
      children: [
        AppInput.primary(
          controller: _companyNameController,
          labelText: 'Company Name',
          hintText: 'Enter company name',
          prefixIcon: Icons.business,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _authorizedPersonController,
          labelText: 'Authorized Person',
          hintText: 'Enter authorized person name',
          prefixIcon: Icons.person,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _companyAddressController,
          labelText: 'Company Address',
          hintText: 'Enter company address',
          prefixIcon: Icons.location_on,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _companyTaxNumberController,
          labelText: 'Tax Number',
          hintText: 'Enter tax number',
          prefixIcon: Icons.receipt,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _companyWebsiteController,
          labelText: 'Website',
          hintText: 'Enter company website',
          prefixIcon: Icons.language,
          enabled: _isEditing,
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return _buildSectionCard(
      title: 'Contact Information',
      icon: Icons.contact_phone,
      iconColor: context.secondary,
      children: [
        AppInput.primary(
          controller: _companyPhoneController,
          labelText: 'Phone Number',
          hintText: 'Enter company phone number',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _companyEmailController,
          labelText: 'Email Address',
          hintText: 'Enter company email address',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          enabled: _isEditing,
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection() {
    return _buildSectionCard(
      title: 'Additional Information',
      icon: Icons.info,
      iconColor: context.tertiary,
      children: [
        AppInput.primary(
          controller: _companyDescriptionController,
          labelText: 'Company Description',
          hintText: 'Enter company description',
          prefixIcon: Icons.description,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _companyFoundedYearController,
          labelText: 'Founded Year',
          hintText: 'Enter founded year',
          prefixIcon: Icons.calendar_today,
          keyboardType: TextInputType.number,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        AppInput.primary(
          controller: _companyEmployeeCountController,
          labelText: 'Employee Count',
          hintText: 'Enter employee count',
          prefixIcon: Icons.people,
          enabled: _isEditing,
        ),
      ],
    );
  }

  Widget _buildCompanyStatsSection() {
    return _buildSectionCard(
      title: 'Company Statistics',
      icon: Icons.analytics,
      iconColor: context.primary,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildStatRow('Total Jobs Completed', '1,250+', Icons.work),
              const SizedBox(height: 12),
              _buildStatRow('Active Vehicles', '45', Icons.local_shipping),
              const SizedBox(height: 12),
              _buildStatRow('Service Areas',
                  _currentCompany?.serviceAreas ?? '25 Cities', Icons.map),
              const SizedBox(height: 12),
              _buildStatRow('Customer Rating', '4.8/5.0', Icons.star),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: context.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: AppText.bodySmall(
            label,
            color: context.onSurface.withValues(alpha: 0.7),
          ),
        ),
        AppText.body(
          value,
          fontWeight: FontWeight.w600,
          color: context.onSurface,
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
          width: 1,
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
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              AppText.heading(
                title,
                color: context.onSurface,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section content
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton.secondary(
            'Cancel',
            onPressed: _cancelEditing,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton.primary(
            'Save Changes',
            onPressed: _saveChanges,
          ),
        ),
      ],
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _loadCompanyData(); // Reset to original values
    });
  }

  void _saveChanges() {
    // Save company information
    _showSuccessSnackBar('Company information updated successfully');
    setState(() {
      _isEditing = false;
    });
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText.body(message),
        backgroundColor: const Color(0xFF10B981),
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
}
