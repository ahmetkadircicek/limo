import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onJobHistoryTap;
  final VoidCallback? onVehicleManagementTap;

  const AppDrawer({
    super.key,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogoutTap,
    this.onJobHistoryTap,
    this.onVehicleManagementTap,
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
                    icon: Icons.work_outline,
                    title: 'İşlerim',
                    isSelected: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    context: context,
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: 'İş Geçmişi',
                    onTap: onJobHistoryTap,
                    context: context,
                  ),
                  _buildDrawerItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Araç Yönetimi',
                    onTap: onVehicleManagementTap,
                    context: context,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'Profil',
                    onTap: onProfileTap,
                    context: context,
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Ayarlar',
                    onTap: onSettingsTap,
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
                color: Colors.grey.withOpacity(0.1),
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
              Text(
                userProvider.userDisplayName ?? 'Kullanıcı',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 18,
                    ),
              ),

              const SizedBox(height: 8),

              // User email with dropdown indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userProvider.userEmail ?? 'email@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 16,
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
    bool isSelected = false,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.logout,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Çıkış Yap',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: context.error,
          ),
        ),
        onTap: onLogoutTap,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
