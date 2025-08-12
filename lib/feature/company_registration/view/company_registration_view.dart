import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/company_registration_view_model.dart';

/// Main view for company registration and management with edit mode support
class CompanyRegistrationView extends StatelessWidget {
  const CompanyRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyRegistrationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: context.surfaceContainer,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: PaddingConstants.allL,
                child: Column(
                  spacing: PaddingConstants.spacingM,
                  children: [
                    _buildHeader(context, viewModel),
                    _buildCompanyInfoSection(context, viewModel),
                    _buildContactSection(context, viewModel),
                    _buildActionButtons(context, viewModel),
                    SizedBox(height: PaddingConstants.spacingXxl),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build the page header with title, description and edit button
  Widget _buildHeader(
      BuildContext context, CompanyRegistrationViewModel viewModel) {
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
            padding: PaddingConstants.allL,
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
                AppText.body(
                  'Company Management',
                  color: context.onSurface,
                ),
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

  /// Build company information section with edit mode support
  Widget _buildCompanyInfoSection(
      BuildContext context, CompanyRegistrationViewModel viewModel) {
    return _buildSection(
      context: context,
      title: 'Company Information',
      icon: Icons.business_outlined,
      children: [
        AppInput.primary(
          hintText: 'Enter your company name',
          controller: viewModel.companyNameController,
          prefixIcon: Icons.business_outlined,
          enabled: viewModel.isEditMode,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          hintText: 'Enter your company type (e.g., Limited Company)',
          controller: viewModel.companyTypeController,
          prefixIcon: Icons.category_outlined,
          enabled: viewModel.isEditMode,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          hintText: 'Enter a brief description about your company',
          controller: viewModel.descriptionController,
          prefixIcon: Icons.description_outlined,
          enabled: viewModel.isEditMode,
        ),
      ],
    );
  }

  /// Build contact information section with edit mode support
  Widget _buildContactSection(
      BuildContext context, CompanyRegistrationViewModel viewModel) {
    return _buildSection(
      context: context,
      title: 'Contact Information',
      icon: Icons.contact_phone_outlined,
      children: [
        AppInput.primary(
          hintText: 'Enter your company address',
          controller: viewModel.addressController,
          prefixIcon: Icons.location_on_outlined,
          enabled: viewModel.isEditMode,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          hintText: 'Enter your company phone number',
          controller: viewModel.phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          enabled: viewModel.isEditMode,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          hintText: 'Enter your company email address',
          controller: viewModel.emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          enabled: viewModel.isEditMode,
        ),
        SizedBox(height: PaddingConstants.spacingM),
        AppInput.primary(
          hintText: 'Enter your company website (optional)',
          controller: viewModel.websiteController,
          keyboardType: TextInputType.url,
          prefixIcon: Icons.language_outlined,
          enabled: viewModel.isEditMode,
        ),
      ],
    );
  }

  /// Build action buttons section with edit mode support
  Widget _buildActionButtons(
      BuildContext context, CompanyRegistrationViewModel viewModel) {
    if (viewModel.isEditMode) {
      // Edit mode: Show Cancel and Update buttons
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  'Cancel',
                  onPressed:
                      viewModel.isLoading ? null : viewModel.toggleEditMode,
                ),
              ),
              SizedBox(width: PaddingConstants.spacingM),
              Expanded(
                child: AppButton.primary(
                  'Save Changes',
                  isLoading: viewModel.isLoading,
                  onPressed: viewModel.isLoading || !viewModel.hasChanges
                      ? null
                      : () async {
                          final success =
                              await viewModel.updateCompany(context);
                          if (success) {
                            // Success - edit mode will be disabled automatically
                          }
                        },
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Normal mode: Show only Edit button
      return SizedBox(
        width: double.infinity,
        child: AppButton.primary(
          'Edit Company Information',
          onPressed: viewModel.isLoading ? null : viewModel.toggleEditMode,
        ),
      );
    }
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
