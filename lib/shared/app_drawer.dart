import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/shared/app_text.dart';
import 'package:provider/provider.dart';

/// Main drawer widget for the application navigation
class AppDrawer extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onVehicleManagementTap;
  final VoidCallback? onDebugTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onHelpSupportTap;
  final VoidCallback? onFAQTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTermsConditionsTap;
  final VoidCallback? onNotificationsTap;

  const AppDrawer({
    super.key,
    this.onProfileTap,
    this.onLogoutTap,
    this.onVehicleManagementTap,
    this.onDebugTap,
    this.onSettingsTap,
    this.onHelpSupportTap,
    this.onFAQTap,
    this.onAboutTap,
    this.onPrivacyPolicyTap,
    this.onTermsConditionsTap,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: context.surface,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildNavigationSection(context),
              _buildLogoutSection(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the user profile header section with avatar and user info
  Widget _buildHeader(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Container(
          padding: context.paddingXl,
          decoration: BoxDecoration(
            color: context.surface,
            border: Border(
              bottom: BorderSide(
                color: context.onSurface.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              _buildUserAvatar(context, appState),
              SizedBox(height: context.spacingS),
              _buildUserName(context, appState),
              SizedBox(height: context.spacingXs),
              _buildUserEmail(context, appState),
            ],
          ),
        );
      },
    );
  }

  /// Builds the user avatar with fallback icon
  Widget _buildUserAvatar(BuildContext context, AppStateProvider appState) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            appState.isAuthenticated && appState.currentUser?.photoUrl != null
                ? Colors.transparent
                : context.primary,
      ),
      child:
          appState.isAuthenticated && appState.currentUser?.photoUrl != null
              ? ClipOval(
                child: Image.network(
                  appState.currentUser!.photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 36,
                      color: context.onPrimary,
                    );
                  },
                ),
              )
              : Icon(Icons.person, size: 36, color: context.onPrimary),
    );
  }

  /// Builds the user display name text
  Widget _buildUserName(BuildContext context, AppStateProvider appState) {
    return AppText.heading(
      appState.currentUser?.displayName ?? 'Not specified',
      color: context.onSurface,
    );
  }

  /// Builds the user email text
  Widget _buildUserEmail(BuildContext context, AppStateProvider appState) {
    return AppText.caption(
      appState.currentUser?.email ?? 'Not specified',
      color: context.textSecondary,
    );
  }

  /// Builds the main navigation section with menu items
  Widget _buildNavigationSection(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Main Navigation Group
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: onProfileTap,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.local_shipping_outlined,
            title: 'Vehicle Management',
            onTap: onVehicleManagementTap,
            context: context,
          ),

          // Settings & Notifications Group
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: onSettingsTap,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: onNotificationsTap,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: onHelpSupportTap,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.question_answer,
            title: 'FAQ',
            onTap: onFAQTap,
            context: context,
          ),

          // Divider
          _buildDivider(context),

          // Information Group
          _buildDrawerItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: onAboutTap,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: onPrivacyPolicyTap,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: onTermsConditionsTap,
            context: context,
          ),

          // Divider
          _buildDivider(context),

          // Debug Group
          _buildDrawerItem(
            icon: Icons.bug_report,
            title: 'Debug Components',
            onTap: onDebugTap,
            context: context,
          ),
        ],
      ),
    );
  }

  /// Builds individual navigation menu items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: PaddingConstants.spacingS),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: context.radiusMedium,
        border: Border(
          top: BorderSide(
            color: context.onSurface.withValues(alpha: 0.05),
            width: 0.5,
          ),
          bottom: BorderSide(
            color: context.onSurface.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: _buildItemIcon(icon, context),
        title: AppText.bodySmall(title, color: context.onSurface),
        onTap: onTap,
        contentPadding: PaddingConstants.horizontalL,
        shape: RoundedRectangleBorder(borderRadius: context.radiusMedium),
      ),
    );
  }

  /// Builds a divider for the drawer items
  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: context.onSurface.withValues(alpha: 0.1),
      height: 1,
      thickness: 1,
    );
  }

  /// Builds the icon container for navigation items
  Widget _buildItemIcon(IconData icon, BuildContext context) {
    return Container(
      padding: context.paddingS,
      child: Icon(icon, size: 24, color: context.onSurface),
    );
  }

  /// Builds the logout section at the bottom of the drawer
  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: context.horizontalL,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: _buildItemIcon(Icons.logout, context),
        title: AppText.bodySmall('Logout', color: context.onSurface),
        onTap: onLogoutTap,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
