import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/app_text.dart';
import 'package:provider/provider.dart';

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
        color: Colors.white,
        child: Column(
          children: [
            // Header with user info
            _buildHeader(context),

            // Navigation items
            Expanded(
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

            // Logout section
            _buildLogoutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // User avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: userProvider.isLoggedIn &&
                          userProvider.userPhotoUrl != null
                      ? Colors.transparent
                      : context.primary,
                ),
                child:
                    userProvider.isLoggedIn && userProvider.userPhotoUrl != null
                        ? ClipOval(
                            child: Image.network(
                              userProvider.userPhotoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 36,
                                  color: Colors.white,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.white,
                          ),
              ),

              const SizedBox(height: 20),

              // User name
              AppText.heading(
                userProvider.userDisplayName ?? 'Kullanıcı',
                color: Colors.black,
              ),

              const SizedBox(height: 8),

              // User email with dropdown indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.caption(
                    userProvider.userEmail ?? 'email@example.com',
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      child: ListTile(
        tileColor: context.surfaceContainer,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: AppText.body(
          title,
          color: Colors.black,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        tileColor: context.surfaceContainer,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          ),
          child: Icon(
            Icons.logout,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: AppText.body(
          'Çıkış Yap',
          color: context.error,
        ),
        onTap: onLogoutTap,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
      ),
    );
  }
}
