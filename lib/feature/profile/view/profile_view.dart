import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/view/document_upload_view.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../../profile_update/view/profile_edit_view.dart';
import '../viewmodel/profile_view_model.dart';
import 'profile_view_mixin.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with ProfileViewMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppStateProvider, ProfileViewModel>(
      builder: (context, appState, viewModel, child) {
        return _buildScaffold(context, appState, viewModel);
      },
    );
  }

  /// Build main scaffold with profile content
  Widget _buildScaffold(
    BuildContext context,
    AppStateProvider appState,
    ProfileViewModel viewModel,
  ) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      body: _buildBody(context, appState, viewModel),
    );
  }

  /// Build main body content
  Widget _buildBody(
    BuildContext context,
    AppStateProvider appState,
    ProfileViewModel viewModel,
  ) {
    return SingleChildScrollView(
      padding: context.paddingL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.spacingXl,
        children: [
          _buildProfilePhotoSection(context, appState.currentUser),
          _buildPersonalInfoSection(context, appState.currentUser),
          _buildStatisticsSection(context, appState.currentUser),
          _buildDriverLicenseSection(context, appState.currentUser),
        ],
      ),
    );
  }

  /// Build statistics section
  Widget _buildStatisticsSection(BuildContext context, user) {
    if (user == null) return const SizedBox.shrink();

    return _buildProviderInfoCard(context, user);
  }

  /// Build provider information card with black background
  Widget _buildProviderInfoCard(BuildContext context, user) {
    return Container(
      width: double.infinity,
      padding: context.paddingL,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: context.radiusMedium,
      ),
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: AppText.caption(
                  'Provider',
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText.caption(
                  'ID',
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText.caption(
                  'Since',
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          // Values row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: AppText.body(
                  user.provider ?? 'Unknown',
                  textAlign: TextAlign.center,
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText.body(
                  user.userId ?? 'Unknown',
                  textAlign: TextAlign.center,
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText.body(
                  _formatYearMonth(user.createdAt),
                  textAlign: TextAlign.center,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build personal information section
  Widget _buildPersonalInfoSection(BuildContext context, user) {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.spacingM,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.heading(
                  'Personal Information',
                  color: context.onSurface,
                ),
              ),
              AppButton.chip(
                'Edit',
                onPressed: () => _navigateToProfileEdit(context),
                icon: CupertinoIcons.pencil,
              ),
            ],
          ),
          _buildInfoRow('Full Name', user.userName),
          _buildInfoRow('Email', user.email),
          _buildInfoRow('Phone', user.phone),
          _buildInfoRow('Company Name', user.companyName),
        ],
      ),
    );
  }

  /// Build profile photo section
  Widget _buildProfilePhotoSection(BuildContext context, user) {
    if (user == null) return const SizedBox.shrink();

    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.spacingL,
        children: [
          // Title row with profile picture title and change button
          Row(
            children: [
              Expanded(
                child: AppText.heading(
                  'Profile Picture',
                  color: context.onSurface,
                ),
              ),
              AppButton.chip(
                'Change',
                onPressed: () => _navigateToProfilePhotoUpload(context),
                icon: CupertinoIcons.camera,
              ),
            ],
          ),
          // Profile image and greeting section
          Row(
            spacing: context.spacingL,
            children: [
              // Profile image - circular and smaller
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.onSurface.withValues(alpha: 0.1),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child:
                      user.userPhoto != null && user.userPhoto!.isNotEmpty
                          ? Image.memory(
                            base64Decode(user.userPhoto!),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            'assets/png/image/image_profile.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              // Greeting message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: context.spacingXs,
                  children: [
                    AppText.heading(
                      'Hello, ${_getFirstName(user.userName ?? 'User')}!',
                      color: context.onSurface,
                    ),
                    AppText.bodySmall(
                      'Welcome back to your profile',
                      color: context.onSurface.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Info message
          AppInfo.info(
            message: 'Complete your profile to get more job opportunities',
            icon: Icons.tips_and_updates,
          ),
        ],
      ),
    );
  }

  /// Get first name from full name
  String _getFirstName(String fullName) {
    return fullName.split(' ').first;
  }

  /// Build individual information row
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.spacingS,
      children: [
        AppText.caption(label, color: context.onSurface.withValues(alpha: 0.7)),
        AppText.body(value, color: context.onSurface),
        const Divider(),
      ],
    );
  }

  /// Format date to show only year and month
  String _formatYearMonth(DateTime? date) {
    if (date == null) return 'Not specified';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  /// Navigate to profile edit page
  void _navigateToProfileEdit(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileEditView()));
  }

  /// Navigate to profile photo upload
  void _navigateToProfilePhotoUpload(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                DocumentUploadView(purpose: DocumentUploadPurpose.profilePhoto),
      ),
    );

    // Refresh the view when returning from document upload
    if (result == true && mounted) {
      setState(() {
        // Trigger rebuild to reflect changes
      });
    }
  }

  /// Build driver license section
  Widget _buildDriverLicenseSection(BuildContext context, user) {
    if (user == null) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.spacingL,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.heading(
                  'Driver License Status',
                  color: context.onSurface,
                ),
              ),
              AppButton.chip(
                'Upload',
                onPressed: () => _navigateToDriverLicenseUpload(context),
                icon: CupertinoIcons.doc_text,
              ),
            ],
          ),
          _buildInfoRow('Status', _getDriverLicenseStatus(user)),
          AppInfo(
            icon: _getDriverLicenseInfoIcon(user),
            message: _getDriverLicenseInfoText(user),
            color: _getDriverLicenseStatusColor(user),
          ),
          if (_canUploadDriverLicense(user))
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                'Upload Driver License',
                onPressed: () => _navigateToDriverLicenseUpload(context),
              ),
            ),
        ],
      ),
    );
  }

  /// Navigate to driver license upload
  void _navigateToDriverLicenseUpload(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => DocumentUploadView(
              purpose: DocumentUploadPurpose.driverLicense,
            ),
      ),
    );

    // Refresh the view when returning from document upload
    if (result == true && mounted) {
      setState(() {
        // Trigger rebuild to reflect changes
      });
    }
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
    if (user == null) return CupertinoIcons.question_circle;

    // If user is approved, show check icon
    if (user.approved == true) {
      return CupertinoIcons.check_mark_circled;
    }

    // If driver license is not uploaded, show upload icon
    if (user.driverLicense == null || user.driverLicense!.isEmpty) {
      return CupertinoIcons.arrow_up_circle;
    }

    // If driver license is uploaded but pending approval, show clock icon
    return CupertinoIcons.clock;
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
}
