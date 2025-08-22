import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/shared/app_profile_image.dart';
import 'package:limo/shared/app_text.dart';
import 'package:provider/provider.dart';

/// Main drawer widget for the application navigation
class AppDrawer extends StatelessWidget {
  final VoidCallback? onLogoutTap;
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
    this.onLogoutTap,
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
          decoration: BoxDecoration(color: context.surface),
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
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return AppProfileImage(
          imageBase64: appState.currentUser?.userPhoto,
          size: 72,
          backgroundColor: context.primary,
        );
      },
    );
  }

  /// Builds the user display name text
  Widget _buildUserName(BuildContext context, AppStateProvider appState) {
    return AppText.heading(
      appState.currentUser?.userName ?? 'Not specified',
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
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.spacingS),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: ListTile(
        leading: _buildItemIcon(icon, context),
        title: AppText.bodySmall(title, color: context.onSurface),
        trailing: Icon(
          Icons.chevron_right,
          color: context.onSurface.withValues(alpha: 0.1),
          size: context.iconMedium,
        ),
        onTap: onTap,
        contentPadding: context.horizontalM,
        shape: RoundedRectangleBorder(borderRadius: context.radiusMedium),
      ),
    );
  }

  /// Builds the icon container for navigation items
  Widget _buildItemIcon(IconData icon, BuildContext context) {
    return Icon(icon, size: context.iconMedium, color: context.onSurface);
  }

  /// Builds the logout section at the bottom of the drawer
  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: context.horizontalXxl,
      child: ListTile(
        leading: _buildItemIcon(Icons.logout, context),
        title: AppText.bodySmall('Logout', color: context.onSurface),
        onTap: onLogoutTap,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
