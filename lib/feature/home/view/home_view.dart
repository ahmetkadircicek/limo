import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/feature/debug/debug_view.dart';
import 'package:limo/feature/empty/view/empty_view.dart';
import 'package:limo/feature/fleet_management/view/fleet_management_view.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/home/widgets/bottom_navigation_bar.dart';
import 'package:limo/feature/job_list/view/job_list_view.dart';
import 'package:limo/feature/job_tracking/view/job_tracking_view.dart';
import 'package:limo/feature/login/view/login_view.dart';
import 'package:limo/feature/profile/view/profile_view.dart';
import 'package:limo/shared/app_components.dart';
import 'package:limo/shared/app_drawer.dart';
import 'package:provider/provider.dart';

/// Main home view that displays jobs, posting, tracking, and profile sections
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homePageViewModel, child) {
        return Scaffold(
          key: homePageViewModel.scaffoldKey,
          appBar: _buildAppBar(homePageViewModel),
          drawer: _buildAppDrawer(homePageViewModel, context),
          body: _buildScaffoldBody(homePageViewModel),
        );
      },
    );
  }

  /// Build the app drawer with navigation options
  Widget _buildAppDrawer(
    HomeViewModel homePageViewModel,
    BuildContext context,
  ) {
    return AppDrawer(
      onLogoutTap: () async {
        await _handleLogout(context);
        if (context.mounted) {
          Navigator.of(context).pop(); // Close drawer
        }
      },
      onDebugTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(5);
      },
      onSettingsTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(6);
      },
      onHelpSupportTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(7);
      },
      onFAQTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(8);
      },
      onAboutTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(9);
      },
      onPrivacyPolicyTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(10);
      },
      onTermsConditionsTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(11);
      },
      onNotificationsTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.navigateToDrawerPage(12);
      },
    );
  }

  /// Build the app bar with menu button
  PreferredSizeWidget _buildAppBar(HomeViewModel homePageViewModel) {
    return AppAppBar.home(
      onMenuTap: () {
        homePageViewModel.scaffoldKey.currentState?.openDrawer();
      },
    );
  }

  /// Build the main scaffold body with page content and navigation
  Widget _buildScaffoldBody(HomeViewModel homePageViewModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(
              bottom: 60,
              child: _buildPageContent(homePageViewModel, context),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: HomeBottomNavigationBar(viewModel: homePageViewModel),
            ),
          ],
        );
      },
    );
  }

  /// Build the main page content with PageView
  Widget _buildPageContent(
    HomeViewModel homePageViewModel,
    BuildContext context,
  ) {
    return Container(
      color: context.surfaceContainer,
      child: SafeArea(
        child: PageView(
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe navigation
          controller: homePageViewModel.pageController,
          children: [
            JobListView(), // Jobs - Index 0
            const EmptyView(featureName: 'Post Job'), // Post Job - Index 1
            const JobTrackingView(), // Dashboard - Index 2
            const FleetManagementView(), // Fleet Management - Index 3
            const ProfileView(), // Profile - Index 4
            // Drawer pages - accessible only from drawer
            const DebugView(), // Debug Components - Index 5
            const EmptyView(featureName: 'Settings'), // Settings - Index 6
            const EmptyView(
              featureName: 'Help & Support',
            ), // Help & Support - Index 7
            const EmptyView(featureName: 'FAQ'), // FAQ - Index 8
            const EmptyView(featureName: 'About'), // About - Index 9
            const EmptyView(
              featureName: 'Privacy Policy',
            ), // Privacy Policy - Index 10
            const EmptyView(
              featureName: 'Terms & Conditions',
            ), // Terms & Conditions - Index 11
            const EmptyView(
              featureName: 'Notifications',
            ), // Notifications - Index 12
          ],
        ),
      ),
    );
  }

  /// Handle user logout and navigation to login
  Future<void> _handleLogout(BuildContext context) async {
    // Get the AppStateProvider and sign out
    final appStateProvider = Provider.of<AppStateProvider>(
      context,
      listen: false,
    );

    // Sign out from Google and clear local state
    await appStateProvider.signOut();

    // SharedPreferences'tan OAuth data'yı temizle
    await SharedPreferencesService.clearOAuthData();

    // Drawer'ı kapat
    if (context.mounted) {
      Navigator.of(context).pop();
      // Mevcut sayfayı login sayfası ile replace et
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginView()));
    }
  }
}
