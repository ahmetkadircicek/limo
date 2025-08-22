import 'package:flutter/material.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/shared_preferences_service.dart';
import 'package:limo/feature/debug/debug_view.dart';
import 'package:limo/feature/empty/view/empty_view.dart';
import 'package:limo/feature/fleet_management/view/fleet_management_view.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/home/widgets/bottom_navigation_bar.dart';
import 'package:limo/feature/job_list/view/job_list_view.dart';
import 'package:limo/feature/job_listing/view/job_listing_view.dart';
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
          drawer: _buildAppDrawer(homePageViewModel, context),
          appBar: _buildAppBar(homePageViewModel),
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
        homePageViewModel.pageController.jumpToPage(
          5,
        ); // Debug Components page index
      },
      onSettingsTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.pageController.jumpToPage(6); // Settings page index
      },
      onHelpSupportTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.pageController.jumpToPage(
          7,
        ); // Help & Support page index
      },
      onFAQTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.pageController.jumpToPage(8); // FAQ page index
      },
      onAboutTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.pageController.jumpToPage(9); // About page index
      },
      onPrivacyPolicyTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.pageController.jumpToPage(
          10,
        ); // Privacy Policy page index
      },
      onTermsConditionsTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.pageController.jumpToPage(
          11,
        ); // Terms & Conditions page index
      },
      onNotificationsTap: () {
        Navigator.of(context).pop(); // Close drawer
        homePageViewModel.pageController.jumpToPage(
          12,
        ); // Notifications page index
      },
    );
  }

  /// Build the app bar with menu button
  PreferredSizeWidget _buildAppBar(HomeViewModel homePageViewModel) {
    return AppTopBar(
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
            Positioned.fill(child: _buildPageContent(homePageViewModel)),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: HomeBottomNavigationBar(
                  viewModel: homePageViewModel,
                  constraints: constraints,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build the main page content with PageView
  Widget _buildPageContent(HomeViewModel homePageViewModel) {
    return PageView(
      physics: const PageScrollPhysics(),
      controller: homePageViewModel.pageController,
      onPageChanged: homePageViewModel.onPageChanged,
      children: [
        JobListView(), // Jobs - Index 0
        const JobListingView(), // Post job - Index 1
        const JobTrackingView(), // Job tracking - Index 2
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
