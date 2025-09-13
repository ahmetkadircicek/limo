import 'package:flutter/material.dart';
import 'package:limo/feature/navigation/widgets/drawer_item_widget.dart';
import 'package:limo/shared/constants/image_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

/// Main drawer widget for the application navigation
class DrawerWidget extends StatelessWidget {
  final VoidCallback? onLogoutTap;
  final VoidCallback? onDebugTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onHelpSupportTap;
  final VoidCallback? onFAQTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTermsConditionsTap;
  final VoidCallback? onNotificationsTap;

  const DrawerWidget({
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
            crossAxisAlignment: CrossAxisAlignment.start,
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

  /// Header with logo
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: PaddingConstants.all20,
      color: context.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            child: Image.asset(
              ImageConstants.logo,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            'Fast and secure work.',
            style: context.body.copyWith(color: context.onSurface),
          ),
        ],
      ),
    );
  }

  /// Navigation items grouped with section titles
  Widget _buildNavigationSection(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerItemTitleWidget(title: 'General'),
          DrawerItemWidget(
            icon: Icons.settings,
            title: 'Settings',
            onTap: onSettingsTap,
          ),
          DrawerItemWidget(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: onNotificationsTap,
          ),
          DrawerItemTitleWidget(title: 'Support'),
          DrawerItemWidget(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: onHelpSupportTap,
          ),
          DrawerItemWidget(
            icon: Icons.question_answer,
            title: 'FAQ',
            onTap: onFAQTap,
          ),
          DrawerItemTitleWidget(title: 'Legal'),
          DrawerItemWidget(
            icon: Icons.info_outline,
            title: 'About',
            onTap: onAboutTap,
          ),
          DrawerItemWidget(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: onPrivacyPolicyTap,
          ),
          DrawerItemWidget(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            onTap: onTermsConditionsTap,
          ),
          DrawerItemTitleWidget(title: 'Development'),
          DrawerItemWidget(
            icon: Icons.bug_report,
            title: 'Debug Components',
            onTap: onDebugTap,
          ),
        ],
      ),
    );
  }

  /// Logout item
  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: PaddingConstants.horizontal20,
      child: ListTile(
        leading: Icon(Icons.logout, color: context.onSurface),
        title: Text(
          'Logout',
          style: context.body.copyWith(color: context.onSurface),
        ),
        onTap: onLogoutTap,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class DrawerItemTitleWidget extends StatelessWidget {
  final String title;
  const DrawerItemTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          PaddingConstants.top12 +
          PaddingConstants.bottom4 +
          PaddingConstants.horizontal20,
      child: Text(
        title,
        style: context.caption1.copyWith(
          color: context.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
