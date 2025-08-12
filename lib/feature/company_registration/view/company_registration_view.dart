import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/company_registration_view_model.dart';

class CompanyRegistrationView extends StatelessWidget {
  const CompanyRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyRegistrationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: context.surfaceContainer,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: PaddingConstants.allL,
                    child: Column(
                      children: [
                        _buildHeader(context),
                        SizedBox(height: PaddingConstants.spacingXl),
                        _buildCompanyInfoSection(context, viewModel),
                        SizedBox(height: PaddingConstants.spacingXl),
                        _buildContactSection(context, viewModel),
                        SizedBox(height: PaddingConstants.spacingXxl),
                        _buildActionButtons(context, viewModel),
                        SizedBox(height: PaddingConstants.spacingXxl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build the page header with title and description
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: PaddingConstants.allL,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.1),
              borderRadius: GeneralConstants.borderRadius,
            ),
            child: Icon(
              Icons.business,
              color: context.primary,
              size: 32,
            ),
          ),
          SizedBox(width: PaddingConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.heading(
                  'Company Management',
                  color: context.onSurface,
                ),
                SizedBox(height: PaddingConstants.spacingS),
                AppText.bodySmall(
                  'Update and manage your company information',
                  color: context.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build company information section
  Widget _buildCompanyInfoSection(
      BuildContext context, CompanyRegistrationViewModel viewModel) {
    return _buildSection(
      context: context,
      title: 'Company Information',
      icon: Icons.business_outlined,
      children: [
        AppInput.primary(
          labelText: 'Company Name',
          hintText: 'Enter your company name',
          controller: viewModel.companyNameController,
          prefixIcon: Icons.business_outlined,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          labelText: 'Company Type',
          hintText: 'Enter your company type (e.g., Limited Company)',
          controller: viewModel.companyTypeController,
          prefixIcon: Icons.category_outlined,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          labelText: 'Company Description',
          hintText: 'Enter a brief description about your company',
          controller: viewModel.descriptionController,
          prefixIcon: Icons.description_outlined,
        ),
      ],
    );
  }

  /// Build contact information section
  Widget _buildContactSection(
      BuildContext context, CompanyRegistrationViewModel viewModel) {
    return _buildSection(
      context: context,
      title: 'Contact Information',
      icon: Icons.contact_phone_outlined,
      children: [
        AppInput.primary(
          labelText: 'Address',
          hintText: 'Enter your company address',
          controller: viewModel.addressController,
          prefixIcon: Icons.location_on_outlined,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          labelText: 'Phone',
          hintText: 'Enter your company phone number',
          controller: viewModel.phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          labelText: 'Email',
          hintText: 'Enter your company email address',
          controller: viewModel.emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          labelText: 'Website',
          hintText: 'Enter your company website (optional)',
          controller: viewModel.websiteController,
          keyboardType: TextInputType.url,
          prefixIcon: Icons.language_outlined,
        ),
      ],
    );
  }

  /// Build action buttons section
  Widget _buildActionButtons(
      BuildContext context, CompanyRegistrationViewModel viewModel) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton.primary(
            'Save Company Information',
            isLoading: viewModel.isLoading,
            onPressed: viewModel.isLoading
                ? null
                : () async {
                    await viewModel.registerCompany(context);
                  },
          ),
        ),
        SizedBox(height: PaddingConstants.spacingM),
        SizedBox(
          width: double.infinity,
          child: AppButton.secondary(
            'Clear Form',
            onPressed: viewModel.isLoading
                ? null
                : () {
                    viewModel.clearForm();
                  },
          ),
        ),
      ],
    );
  }

  /// Build reusable section container
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
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
        padding: PaddingConstants.allL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, title, icon),
            SizedBox(height: PaddingConstants.spacingL),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Build section header with icon and title
  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.1),
            borderRadius: GeneralConstants.borderRadius,
          ),
          child: Icon(
            icon,
            color: context.primary,
            size: 20,
          ),
        ),
        SizedBox(width: PaddingConstants.spacingM),
        AppText.body(
          title,
          color: context.onSurface,
        ),
      ],
    );
  }
}
