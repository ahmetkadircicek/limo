import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:limo/feature/company_registration/view/company_registration_view.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/home/widgets/bottom_navigation_bar.dart';
import 'package:limo/feature/job_list/view/job_list_view.dart';
import 'package:limo/feature/job_tracking/view/job_tracking_view.dart';
import 'package:limo/feature/listing_job/view/listing_job_view.dart';
import 'package:limo/feature/profile/view/profile_view.dart';
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
    _initializeUserProvider();
    _handleInitialPageNavigation();
  }

  /// Initialize UserProvider with current user data if available
  void _initializeUserProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Check if user is already in provider
      if (!userProvider.isLoggedIn) {
        // Try to get user from Google Auth Service
        final userModel = await GoogleAuthService.getUserModel();
        if (userModel != null) {
          userProvider.setUser(userModel);
          debugPrint('UserProvider initialized with: ${userModel.displayName}');
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
      onCompanyManagementTap: () {
        context.pop(); // Close drawer
        debugPrint("Navigation to Company Registration from Home Drawer");
        homePageViewModel.navigateToCompanyRegistration();
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
            Positioned.fill(
              child: _buildPageContent(homePageViewModel),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
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
        const CompanyRegistrationView(), // Company Registration - Index 4

        const ProfileView(), // Profile - Index 5
      ],
    );
  }

  /// Handle user logout and navigation to login
  Future<void> _handleLogout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Clear user data
    userProvider.clearUser();

    // Sign out from Google
    await GoogleAuthService.signOut();

    // Navigate to login
    if (mounted) {
      debugPrint("Navigation to Login from Home (Logout)");
      context.go('/login');
    }
  }
}
