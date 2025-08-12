import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/profile_view_model.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/section_header.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, UserProvider>(
      builder: (context, viewModel, userProvider, child) {
        // Initialize ViewModel when user data is available
        if (userProvider.isLoggedIn && !viewModel.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.initialize(userProvider);
          });
        }

        return Scaffold(
          backgroundColor: context.surfaceContainer,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(context, userProvider),
                const SizedBox(height: 24),

                // User Information Section
                _buildUserInfoSection(context, viewModel),

                const SizedBox(height: 24),

                // Action Buttons
                _buildActionButtons(context, viewModel),

                // Error/Success Messages
                if (viewModel.errorMessage != null)
                  _buildErrorMessage(context, viewModel),
                if (viewModel.successMessage != null)
                  _buildSuccessMessage(context, viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the profile header section with avatar and user info
  Widget _buildProfileHeader(BuildContext context, UserProvider userProvider) {
    return Container(
      padding: PaddingConstants.allXl,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: GeneralConstants.borderRadius,
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
                AppText.heading(
                  userProvider.userDisplayName ?? 'User Name',
                  color: context.onSurface,
                ),
                AppText.body(
                  userProvider.userEmail ?? 'email@example.com',
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      PaddingConstants.horizontalM + PaddingConstants.verticalS,
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.1),
                    borderRadius: GeneralConstants.borderRadiusRound,
                  ),
                  child: AppText.caption(
                    'Active User',
                    color: context.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the user information section with editable fields
  Widget _buildUserInfoSection(
      BuildContext context, ProfileViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: GeneralConstants.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                const SectionHeader(
                  icon: Icons.person,
                  title: 'Personal Information',
                ),
                const SizedBox(height: 20),

                // Display Name (Read-only from Google)
                ProfileInfoCard(
                  icon: Icons.person,
                  label: 'Full Name',
                  value: userProvider.userDisplayName ?? 'Not specified',
                  badgeText: 'Google',
                ),
                const SizedBox(height: 16),

                // Email (Read-only from Google)
                ProfileInfoCard(
                  icon: Icons.email,
                  label: 'Email',
                  value: userProvider.userEmail ?? 'Not specified',
                  badgeText: 'Google',
                ),
                const SizedBox(height: 16),

                // Phone Number (Editable in edit mode, read-only in view mode)
                AppInput.primary(
                  controller: viewModel.phoneController,
                  labelText: 'Phone',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  enabled: viewModel.isEditing, // Only enabled in edit mode
                  inputFormatters: viewModel.isEditing
                      ? [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9+\-\(\)\s]')),
                        ]
                      : null,
                  onChanged: viewModel.isEditing
                      ? (value) {
                          // Clear any previous error messages when user types
                          if (viewModel.errorMessage != null) {
                            viewModel.clearError();
                          }
                        }
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds the action buttons section for saving/canceling changes
  Widget _buildActionButtons(BuildContext context, ProfileViewModel viewModel) {
    if (viewModel.isEditing) {
      // Edit mode: Show Cancel and Save buttons
      return Row(
        children: [
          Expanded(
            child: AppButton.secondary(
              'Cancel',
              onPressed: viewModel.cancelEditing,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton.primary(
              'Save Changes',
              onPressed: viewModel.saveChanges,
              isLoading: viewModel.isLoading,
            ),
          ),
        ],
      );
    } else {
      // View mode: Show only Edit button
      return SizedBox(
        width: double.infinity,
        child: AppButton.primary(
          'Edit Profile',
          onPressed: viewModel.startEditing,
        ),
      );
    }
  }

  /// Builds error message widget
  Widget _buildErrorMessage(BuildContext context, ProfileViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.error.withValues(alpha: 0.1),
        borderRadius: GeneralConstants.borderRadius,
        border: Border.all(color: context.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.error),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.body(
              viewModel.errorMessage!,
              color: context.error,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: context.error),
            onPressed: viewModel.clearError,
          ),
        ],
      ),
    );
  }

  /// Builds success message widget
  Widget _buildSuccessMessage(
      BuildContext context, ProfileViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.success.withValues(alpha: 0.1),
        borderRadius: GeneralConstants.borderRadius,
        border: Border.all(color: context.success),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: context.success),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.body(
              viewModel.successMessage!,
              color: context.success,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: context.success),
            onPressed: viewModel.clearSuccess,
          ),
        ],
      ),
    );
  }
}
