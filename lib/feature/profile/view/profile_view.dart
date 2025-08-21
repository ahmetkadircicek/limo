import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/view/document_upload_view.dart';
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
  final _phoneController = TextEditingController();
  final _companyNameController = TextEditingController();

  bool _isEditing = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppStateProvider, ProfileViewModel>(
      builder: (context, appState, viewModel, child) {
        // Initialize controllers with current user data
        final user = appState.currentUser;
        if (user != null && !_isEditing) {
          _phoneController.text = user.phone ?? '';
          _companyNameController.text = user.companyName ?? '';
        }

        // Show AppSnackbar messages when they change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.errorMessage != null) {
            context.showErrorTopSnackbar(viewModel.errorMessage!);
            viewModel.clearError();
          }

          if (viewModel.successMessage != null) {
            context.showSuccessTopSnackbar(viewModel.successMessage!);
            viewModel.clearSuccess();
          }
        });

        return Scaffold(
          backgroundColor: context.surfaceContainer,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(context, appState),
                const SizedBox(height: 24),

                // User Information Section
                _buildUserInfoSection(context, user),

                const SizedBox(height: 24),

                // Action Buttons
                _buildActionButtons(context, viewModel, user),

                // Bottom Spacing
                _buildBottomSpacing(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the profile header section with avatar and user info
  Widget _buildProfileHeader(BuildContext context, AppStateProvider appState) {
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
          Consumer<AppStateProvider>(
            builder: (context, appState, child) {
              return AppProfileImage(
                imageBase64: appState.currentUser?.userPhoto,
                size: 70,
                onTap:
                    _isEditing
                        ? () {
                          // Open image picker for profile photo selection
                          final viewModel = Provider.of<ProfileViewModel>(
                            context,
                            listen: false,
                          );
                          viewModel.updateProfileImageFromGallery(appState);
                        }
                        : null,
                showEditIcon: _isEditing,
              );
            },
          ),
          const SizedBox(width: 20),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.heading(
                  appState.currentUser?.userName ?? 'Not specified',
                  color: context.onSurface,
                ),
                AppText.body(
                  appState.currentUser?.email ?? 'Not specified',
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the user information section with editable fields
  Widget _buildUserInfoSection(BuildContext context, user) {
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
        child: Column(
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
              value: user?.userName ?? 'Not specified',
              badgeText: 'Google',
            ),
            const SizedBox(height: 16),

            // Email (Read-only from Google)
            ProfileInfoCard(
              icon: Icons.email,
              label: 'Email',
              value: user?.email ?? 'Not specified',
              badgeText: 'Google',
            ),
            const SizedBox(height: 16),

            // Phone Number (Editable)
            AppInput.primary(
              controller: _phoneController,
              labelText: 'Phone',
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              enabled: _isEditing,
              inputFormatters:
                  _isEditing
                      ? [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9+\-\(\)\s]'),
                        ),
                      ]
                      : null,
            ),
            const SizedBox(height: 16),

            // Company Name (Editable)
            AppInput.primary(
              controller: _companyNameController,
              labelText: 'Company Name',
              hintText: 'Enter your company name',
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),

            // Driver License Status
            Consumer<AppStateProvider>(
              builder: (context, appState, child) {
                final currentUser = appState.currentUser;
                return AppInfoCard(
                  icon: Icons.drive_eta,
                  label: 'Driver License',
                  value: _getDriverLicenseStatus(currentUser),
                  iconColor:
                      _canUploadDriverLicense(currentUser)
                          ? context.primary
                          : context.onSurface.withValues(alpha: 0.5),
                  valueColor: _getDriverLicenseStatusColor(currentUser),
                  onTap:
                      _canUploadDriverLicense(currentUser)
                          ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => DocumentUploadView(
                                      purpose:
                                          DocumentUploadPurpose.driverLicense,
                                    ),
                              ),
                            );
                          }
                          : null,
                );
              },
            ),

            // Driver License Info Box
            const SizedBox(height: 12),
            _buildDriverLicenseInfoBox(user),
          ],
        ),
      ),
    );
  }

  /// Builds the action buttons section for saving/canceling changes
  Widget _buildActionButtons(
    BuildContext context,
    ProfileViewModel viewModel,
    user,
  ) {
    if (_isEditing) {
      // Edit mode: Show Cancel and Save buttons
      return Row(
        children: [
          Expanded(
            child: AppButton.secondary(
              'Cancel',
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  // Reset controllers to original values
                  if (user != null) {
                    _phoneController.text = user.phone ?? '';
                    _companyNameController.text = user.companyName ?? '';
                  }
                });
                viewModel.clearError();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton.primary(
              'Save Changes',
              onPressed: () => _saveProfile(viewModel, user),
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
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
        ),
      );
    }
  }

  /// Build driver license info box
  Widget _buildDriverLicenseInfoBox(dynamic user) {
    String infoText = _getDriverLicenseInfoText(user);
    IconData infoIcon = _getDriverLicenseInfoIcon(user);
    Color infoColor = _getDriverLicenseStatusColor(user);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: infoColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(infoIcon, color: infoColor, size: 16),
          const SizedBox(width: 8),
          Expanded(child: AppText.caption(infoText, color: infoColor)),
        ],
      ),
    );
  }

  /// Get driver license info text for info box
  String _getDriverLicenseInfoText(dynamic user) {
    if (user == null) return 'Driver license information unavailable';

    // If user is approved, show positive message
    if (user.approved == true) {
      return 'Your driver license is approved. You can upload a new one if needed.';
    }

    // If driver license is not uploaded, show upload instruction
    if (user.driverLicense == null || user.driverLicense!.isEmpty) {
      return 'Upload your driver license to start driving with us.';
    }

    // If driver license is uploaded but pending approval, show waiting message
    return 'Your driver license is under review. Please wait for approval.';
  }

  /// Get driver license info icon for info box
  IconData _getDriverLicenseInfoIcon(dynamic user) {
    if (user == null) return Icons.help_outline;

    // If user is approved, show check icon
    if (user.approved == true) {
      return Icons.check_circle_outline;
    }

    // If driver license is not uploaded, show upload icon
    if (user.driverLicense == null || user.driverLicense!.isEmpty) {
      return Icons.upload_outlined;
    }

    // If driver license is uploaded but pending approval, show clock icon
    return Icons.schedule_outlined;
  }

  /// Get driver license status text based on user data
  String _getDriverLicenseStatus(dynamic user) {
    if (user == null) return 'Unknown';

    // Check if user is approved
    if (user.approved == true) {
      return 'Approved';
    }

    // Check if driver license is uploaded but not yet approved
    if (user.driverLicense != null && user.driverLicense!.isNotEmpty) {
      return 'Pending Approval';
    }

    // No driver license uploaded
    return 'Not Uploaded';
  }

  /// Check if user can upload driver license (not pending approval)
  bool _canUploadDriverLicense(dynamic user) {
    if (user == null) return false;

    // If user is approved, they can upload again
    if (user.approved == true) return true;

    // If driver license is not uploaded, they can upload
    if (user.driverLicense == null || user.driverLicense!.isEmpty) {
      return true;
    }

    // If driver license is uploaded but pending approval, they cannot upload again
    return false;
  }

  /// Get driver license status color based on user data
  Color _getDriverLicenseStatusColor(dynamic user) {
    if (user == null) return Colors.grey;

    // Check if user is approved
    if (user.approved == true) {
      return Colors.green;
    }

    // Check if driver license is uploaded but not yet approved
    if (user.driverLicense != null && user.driverLicense!.isNotEmpty) {
      return Colors.orange;
    }

    // No driver license uploaded
    return Colors.red;
  }

  /// Save profile with updated UserModel
  void _saveProfile(ProfileViewModel viewModel, user) {
    if (user == null) return;

    final updatedUser = user.copyWith(
      phone: _phoneController.text.trim(),
      companyName: _companyNameController.text.trim(),
      // Preserve driver license and approval status - these should only be updated via document upload
      driverLicense: user.driverLicense,
      approved: user.approved,
      // Include profile photo if it exists
      userPhoto: user.userPhoto,
    );

    // Get AppStateProvider to update user data
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    viewModel.updateUser(updatedUser, appState).then((_) {
      if (viewModel.successMessage != null) {
        setState(() {
          _isEditing = false;
        });
      }
    });
  }

  /// Builds bottom spacing for better layout
  Widget _buildBottomSpacing() {
    return const SizedBox(height: 100);
  }
}
