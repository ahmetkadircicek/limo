import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/app_text.dart';
import 'package:provider/provider.dart';

/// Main drawer widget for the application navigation
class AppDrawer extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onVehicleManagementTap;
  final VoidCallback? onCompanyManagementTap;

  const AppDrawer({
    super.key,
    this.onProfileTap,
    this.onLogoutTap,
    this.onVehicleManagementTap,
    this.onCompanyManagementTap,
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
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
              _buildUserAvatar(context, userProvider),
              SizedBox(height: context.spacingS),
              _buildUserName(context, userProvider),
              SizedBox(height: context.spacingXs),
              _buildUserEmail(context, userProvider),
            ],
          ),
        );
      },
    );
  }

  /// Builds the user avatar with fallback icon
  Widget _buildUserAvatar(BuildContext context, UserProvider userProvider) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: userProvider.isLoggedIn && userProvider.userPhotoUrl != null
            ? Colors.transparent
            : context.primary,
      ),
      child: userProvider.isLoggedIn && userProvider.userPhotoUrl != null
          ? ClipOval(
              child: Image.network(
                userProvider.userPhotoUrl!,
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
          : Icon(
              Icons.person,
              size: 36,
              color: context.onPrimary,
            ),
    );
  }

  /// Builds the user display name text
  Widget _buildUserName(BuildContext context, UserProvider userProvider) {
    return AppText.heading(
      userProvider.userDisplayName ?? 'Kullanıcı',
      color: context.onSurface,
    );
  }

  /// Builds the user email text
  Widget _buildUserEmail(BuildContext context, UserProvider userProvider) {
    return AppText.caption(
      userProvider.userEmail ?? 'email@example.com',
      color: context.textSecondary,
    );
  }

  /// Builds the main navigation section with menu items
  Widget _buildNavigationSection(BuildContext context) {
    return Expanded(
      child: Container(
        color: context.surfaceContainer,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              icon: Icons.person_outline,
              title: 'Profil',
              onTap: onProfileTap,
              context: context,
            ),
            _buildDrawerItem(
              icon: Icons.local_shipping_outlined,
              title: 'Araç Yönetimi',
              onTap: onVehicleManagementTap,
              context: context,
            ),
            _buildDrawerItem(
              icon: Icons.business,
              title: 'Şirket Yönetimi',
              onTap: onCompanyManagementTap,
              context: context,
            ),
          ],
        ),
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
      margin: PaddingConstants.horizontalS,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: context.radiusMedium,
      ),
      child: ListTile(
        tileColor: context.surfaceContainer,
        leading: _buildItemIcon(icon, context),
        title: AppText.body(
          title,
          color: context.onSurface,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
            horizontal: context.spacingL, vertical: context.spacingS),
        shape: RoundedRectangleBorder(
          borderRadius: context.radiusMedium,
        ),
      ),
    );
  }

  /// Builds the icon container for navigation items
  Widget _buildItemIcon(IconData icon, BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.onSurface,
        borderRadius: context.radiusMedium,
      ),
      child: Icon(
        icon,
        size: 20,
        color: context.surface,
      ),
    );
  }

  /// Builds the logout section at the bottom of the drawer
  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: context.horizontalXl + context.verticalS,
      decoration: BoxDecoration(
        color: context.surface,
        border: Border(
          top: BorderSide(
            color: context.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        tileColor: context.surfaceContainer,
        leading: _buildItemIcon(Icons.logout, context),
        title: AppText.body(
          'Çıkış Yap',
          color: context.error,
        ),
        onTap: onLogoutTap,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: context.radiusMedium,
        ),
      ),
    );
  }
}
