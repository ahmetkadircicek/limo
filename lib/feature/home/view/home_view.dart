import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:limo/feature/about/about_view.dart';
import 'package:limo/feature/debug/debug_view.dart';
import 'package:limo/feature/faq/faq_view.dart';
import 'package:limo/feature/help_support/help_support_view.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/home/widgets/bottom_navigation_bar.dart';
import 'package:limo/feature/job_list/view/job_list_view.dart';
import 'package:limo/feature/job_tracking/view/job_tracking_view.dart';
import 'package:limo/feature/listing_job/view/listing_job_view.dart';
import 'package:limo/feature/notifications/notifications_view.dart';
import 'package:limo/feature/privacy_policy/privacy_policy_view.dart';
import 'package:limo/feature/profile/view/profile_view.dart';
import 'package:limo/feature/settings/settings_view.dart';
import 'package:limo/feature/terms_conditions/terms_conditions_view.dart';
import 'package:limo/feature/vehicle_registration/view/vehicle_management_view.dart';
import 'package:limo/shared/app_components.dart';
import 'package:limo/shared/app_drawer.dart';
import 'package:provider/provider.dart';

/// Main home view that displays jobs, posting, tracking, and profile sections
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _initializeAppState();
    _handleInitialPageNavigation();
  }

  /// Initialize AppStateProvider with current user data if available
  void _initializeAppState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appState = Provider.of<AppStateProvider>(context, listen: false);

      // Check if user is already authenticated
      if (!appState.isAuthenticated) {
        // Try to get user from Google Auth Service
        final userModel = await GoogleAuthService.getUserModel();
        if (userModel != null) {
          // Use the Google ID to authenticate with backend
          final googleId = userModel.id;
          if (googleId.isNotEmpty) {
            final success = await appState.authenticateWithGoogle(googleId);
            if (success) {
              debugPrint(
                'AppStateProvider initialized with: ${userModel.displayName}',
              );
            }
          }
        }
      }
    });
  }

  /// Handle initial page navigation based on query parameters
  void _handleInitialPageNavigation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // For now, we'll handle this through the ViewModel
      // In the future, this can be enhanced with URL parameter handling
      debugPrint("Initial page navigation setup complete");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homePageViewModel, child) {
        return Scaffold(
          key: homePageViewModel.scaffoldKey,
          drawer: _buildAppDrawer(homePageViewModel),
          appBar: _buildAppBar(homePageViewModel),
          body: _buildScaffoldBody(homePageViewModel),
        );
      },
    );
  }

  /// Build the app drawer with navigation options
  Widget _buildAppDrawer(HomeViewModel homePageViewModel) {
    return AppDrawer(
      onProfileTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Profile from Home Drawer");
        homePageViewModel.navigateToProfile();
      },
      onLogoutTap: () async {
        await _handleLogout();
        context.pop(); // Close drawer
      },
      onVehicleManagementTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Vehicle Management from Home Drawer");
        homePageViewModel.navigateToVehicleManagement();
      },
      onDebugTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Debug Components from Home Drawer");
        homePageViewModel.pageController.jumpToPage(
          5,
        ); // Debug Components page index
      },
      onSettingsTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Settings from Home Drawer");
        homePageViewModel.pageController.jumpToPage(6); // Settings page index
      },
      onHelpSupportTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Help & Support from Home Drawer");
        homePageViewModel.pageController.jumpToPage(
          7,
        ); // Help & Support page index
      },
      onFAQTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to FAQ from Home Drawer");
        homePageViewModel.pageController.jumpToPage(8); // FAQ page index
      },
      onAboutTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to About from Home Drawer");
        homePageViewModel.pageController.jumpToPage(9); // About page index
      },
      onPrivacyPolicyTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Privacy Policy from Home Drawer");
        homePageViewModel.pageController.jumpToPage(
          10,
        ); // Privacy Policy page index
      },
      onTermsConditionsTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Terms & Conditions from Home Drawer");
        homePageViewModel.pageController.jumpToPage(
          11,
        ); // Terms & Conditions page index
      },
      onNotificationsTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Notifications from Home Drawer");
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
      physics: const NeverScrollableScrollPhysics(),
      controller: homePageViewModel.pageController,
      onPageChanged: homePageViewModel.onPageChanged,
      children: [
        JobListView(
          onRefresh: () => homePageViewModel.onJobCreated(),
        ), // Jobs - Index 0
        const ListingJobView(), // Post job - Index 1
        const JobTrackingView(), // Job tracking - Index 2
        const VehicleManagementView(), // Vehicle Management - Index 3
        const ProfileView(), // Profile - Index 4
        // Drawer pages - accessible only from drawer
        const DebugView(), // Debug Components - Index 5
        const SettingsView(), // Settings - Index 6
        const HelpSupportView(), // Help & Support - Index 7
        const FAQView(), // FAQ - Index 8
        const AboutView(), // About - Index 9
        const PrivacyPolicyView(), // Privacy Policy - Index 10
        const TermsConditionsView(), // Terms & Conditions - Index 11
        const NotificationsView(), // Notifications - Index 12
      ],
    );
  }

  /// Handle user logout and navigation to login
  Future<void> _handleLogout() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    // Clear user data and tokens
    await appState.logout();

    // Sign out from Google
    await GoogleAuthService.signOut();

    // Navigate to login
    if (mounted) {
      debugPrint("Navigation to Login from Home (Logout)");
      context.go('/login');
    }
  }
}
