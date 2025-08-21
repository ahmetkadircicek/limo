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
      padding: context.horizontalL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          _buildProfileHeader(context, appState),
          _buildUserInfoSection(context, appState.currentUser),
          buildActionButtons(viewModel, appState.currentUser),
          _buildBottomSpacing(),
        ],
      ),
    );
  }

  /// Build profile header section with avatar and user info
  Widget _buildProfileHeader(BuildContext context, AppStateProvider appState) {
    return Container(
      padding: PaddingConstants.allXl,
      decoration: _buildHeaderDecoration(context),
      child: Row(
        children: [
          _buildProfilePicture(context, appState),
          const SizedBox(width: 20),
          _buildProfileInfo(context, appState),
        ],
      ),
    );
  }

  /// Build header decoration with shadow
  BoxDecoration _buildHeaderDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: GeneralConstants.borderRadius,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Build profile picture with edit functionality
  Widget _buildProfilePicture(BuildContext context, AppStateProvider appState) {
    return AppProfileImage(
      imageBase64: appState.currentUser?.userPhoto,
      size: 70,
      onTap: isEditing ? () => updateProfileImageFromGallery(appState) : null,
      showEditIcon: isEditing,
    );
  }

  /// Build profile info text section
  Widget _buildProfileInfo(BuildContext context, AppStateProvider appState) {
    return Expanded(
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
    );
  }

  /// Build user information section with editable fields
  Widget _buildUserInfoSection(BuildContext context, user) {
    return Container(
      decoration: _buildUserInfoDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            _buildSectionHeader(context),
            _buildReadOnlyFields(user),
            _buildEditableFields(),
            _buildDriverLicenseSection(context, user),
            const SizedBox(height: 12),
            _buildDriverLicenseInfoBox(user),
          ],
        ),
      ),
    );
  }

  /// Build user info container decoration
  BoxDecoration _buildUserInfoDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: GeneralConstants.borderRadius,
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context) {
    return AppText.heading('Personal Information', color: context.onSurface);
  }

  /// Build read-only fields from Google
  Widget _buildReadOnlyFields(dynamic user) {
    return Column(
      spacing: 16,
      children: [
        ProfileInfoCard(
          icon: Icons.person,
          label: 'Full Name',
          value: user?.userName ?? 'Not specified',
          badgeText: 'Google',
        ),
        ProfileInfoCard(
          icon: Icons.email,
          label: 'Email',
          value: user?.email ?? 'Not specified',
          badgeText: 'Google',
        ),
      ],
    );
  }

  /// Build editable input fields
  Widget _buildEditableFields() {
    return Column(
      spacing: 16,
      children: [_buildPhoneInput(), _buildCompanyNameInput()],
    );
  }

  /// Build phone number input field
  Widget _buildPhoneInput() {
    return AppInput.primary(
      controller: phoneController,
      labelText: 'Phone',
      hintText: 'Enter your phone number',
      keyboardType: TextInputType.phone,
      enabled: isEditing,
      inputFormatters: isEditing ? _buildPhoneInputFormatters() : null,
    );
  }

  /// Build phone input formatters
  List<TextInputFormatter> _buildPhoneInputFormatters() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\(\)\s]'))];
  }

  /// Build company name input field
  Widget _buildCompanyNameInput() {
    return AppInput.primary(
      controller: companyNameController,
      labelText: 'Company Name',
      hintText: 'Enter your company name',
      enabled: isEditing,
    );
  }

  /// Build driver license section
  Widget _buildDriverLicenseSection(BuildContext context, user) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final currentUser = appState.currentUser;
        return AppInfoCard(
          icon: Icons.drive_eta,
          label: 'Driver License',
          value: _getDriverLicenseStatus(currentUser),
          iconColor: _getDriverLicenseIconColor(context, currentUser),
          valueColor: _getDriverLicenseStatusColor(currentUser),
          onTap: _buildDriverLicenseOnTap(context, currentUser),
        );
      },
    );
  }

  /// Get driver license icon color
  Color _getDriverLicenseIconColor(BuildContext context, user) {
    return _canUploadDriverLicense(user)
        ? context.primary
        : context.onSurface.withValues(alpha: 0.5);
  }

  /// Build driver license onTap handler
  VoidCallback? _buildDriverLicenseOnTap(BuildContext context, user) {
    return _canUploadDriverLicense(user)
        ? () => _navigateToDriverLicenseUpload(context)
        : null;
  }

  /// Navigate to driver license upload
  void _navigateToDriverLicenseUpload(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => DocumentUploadView(
              purpose: DocumentUploadPurpose.driverLicense,
            ),
      ),
    );
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

  /// Build bottom spacing for better layout
  Widget _buildBottomSpacing() {
    return const SizedBox(height: 100);
  }
}
