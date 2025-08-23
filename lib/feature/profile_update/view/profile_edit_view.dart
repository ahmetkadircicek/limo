import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/profile_update_view_model.dart';
import 'profile_edit_view_mixin.dart';

/// Profile edit view for updating user information
class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView>
    with ProfileEditViewMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppStateProvider, ProfileUpdateViewModel>(
      builder: (context, appState, viewModel, child) {
        return _buildScaffold(context, appState, viewModel);
      },
    );
  }

  /// Build main scaffold
  Widget _buildScaffold(
    BuildContext context,
    AppStateProvider appState,
    ProfileUpdateViewModel viewModel,
  ) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      appBar: _buildAppBar(context),
      body: _buildBody(context, appState, viewModel),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppAppBar.secondary(title: 'Edit Profile');
  }

  /// Build main body content
  Widget _buildBody(
    BuildContext context,
    AppStateProvider appState,
    ProfileUpdateViewModel viewModel,
  ) {
    return SingleChildScrollView(
      padding: context.paddingL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.spacingXl,
        children: [
          _buildPersonalInfoSection(context, appState.currentUser, viewModel),
        ],
      ),
    );
  }

  /// Build personal information section
  Widget _buildPersonalInfoSection(
    BuildContext context,
    user,
    ProfileUpdateViewModel viewModel,
  ) {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.spacingL,
        children: [
          _buildInputField(
            context,
            label: 'Full Name',
            controller: fullNameController,
            hintText: 'Enter your full name',
          ),
          _buildInputField(
            context,
            label: 'Phone',
            controller: phoneController,
            hintText: 'Enter your phone number',
            keyboardType: TextInputType.phone,
          ),
          _buildInputField(
            context,
            label: 'Company Name',
            controller: companyNameController,
            hintText: 'Enter your company name',
          ),
          SizedBox(height: context.spacingXl),
          _buildSaveButton(context, viewModel),
        ],
      ),
    );
  }

  /// Build input field
  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return AppInput.primary(
      controller: controller,
      labelText: label,
      hintText: hintText,
      keyboardType: keyboardType,
    );
  }

  /// Build save button
  Widget _buildSaveButton(
    BuildContext context,
    ProfileUpdateViewModel viewModel,
  ) {
    return SizedBox(
      width: double.infinity,
      child: AppButton.primary(
        'Save Changes',
        onPressed:
            viewModel.isLoading ? null : () => _saveChanges(context, viewModel),
        isLoading: viewModel.isLoading,
      ),
    );
  }

  /// Save profile changes
  Future<void> _saveChanges(
    BuildContext context,
    ProfileUpdateViewModel viewModel,
  ) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final success = await viewModel.saveProfileChanges(
      fullName: fullNameController.text,
      phone: phoneController.text,
      companyName: companyNameController.text,
      appState: appState,
    );

    if (context.mounted && success) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Reset form when leaving the page
    resetForm();
    super.dispose();
  }
}
