import 'package:flutter/material.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/google_auth_service.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/job_list/view/job_list_view.dart';
import 'package:limo/feature/job_tracking/view/job_tracking_view.dart';
import 'package:limo/feature/listing_job/view/listing_job_view.dart';
import 'package:limo/feature/profile/view/profile_view.dart';
import 'package:limo/shared/app_components.dart';
import 'package:limo/shared/app_drawer.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homePageViewModel, child) {
          return Scaffold(
            key: homePageViewModel.scaffoldKey,
            drawer: AppDrawer(
              onProfileTap: () {
                homePageViewModel.onItemTapped(3); // Navigate to profile page
                Navigator.pop(context); // Close drawer
              },
              onSettingsTap: () {
                // TODO: Navigate to settings
                Navigator.pop(context);
              },
              onLogoutTap: () async {
                // Handle logout
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);

                // Clear user data
                userProvider.clearUser();

                // Sign out from Google
                await GoogleAuthService.signOut();

                // Navigate to login
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }

                Navigator.pop(context); // Close drawer
              },
              onJobHistoryTap: () {
                // TODO: Navigate to job history
                Navigator.pop(context);
              },
              onVehicleManagementTap: () {
                // TODO: Navigate to vehicle management
                Navigator.pop(context);
              },
            ),
            appBar: AppTopBar(
              onMenuTap: () {
                homePageViewModel.scaffoldKey.currentState?.openDrawer();
              },
            ),
            // Use a Stack to extend the navigation bar below the page content
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: _buildBody(homePageViewModel),
                    ),
                    // BottomNavigationBar'ı overflow hatalarına karşı SingleChildScrollView ile sarmalıyoruz
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                        ),
                        child: _buildBottomNavigationBar(
                            context, homePageViewModel),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Remove the default bottomNavigationBar property
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeViewModel homePageViewModel) {
    return SafeArea(
      // SafeArea ile üst ve alt çakışmaları önle
      top: false, // AppBar zaten var
      left: false,
      right: false,
      bottom: false,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: homePageViewModel.pageController,
        onPageChanged: homePageViewModel.onPageChanged,
        children: [
          const JobListView(), // Jobs
          const ListingJobView(), // Post job
          const JobTrackingView(), // Job tracking
          const ProfileView(), // Profile
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, HomeViewModel viewModel) {
    // Uber-style bottom navigation
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Container(
        height: 72, // Increased height for better touch
        margin: PaddingConstants.allM,
        decoration: BoxDecoration(
          color: context.primary, // Black like Uber
          borderRadius: BorderRadius.circular(24), // More rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _CustomNavBarItem(
                icon: Icons.work_outline,
                text: 'JOBS',
                index: 0,
                selectedIndex: viewModel.selectedIndex,
                onTap: viewModel.onItemTapped,
              ),
            ),
            Expanded(
              child: _CustomNavBarItem(
                icon: Icons.add_circle_outline,
                text: 'POST',
                index: 1,
                selectedIndex: viewModel.selectedIndex,
                isHighlighted: true,
                onTap: viewModel.onItemTapped,
              ),
            ),
            Expanded(
              child: _CustomNavBarItem(
                icon: Icons.location_on_outlined,
                text: 'TRACK',
                index: 2,
                selectedIndex: viewModel.selectedIndex,
                onTap: viewModel.onItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomNavBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isHighlighted;

  const _CustomNavBarItem({
    required this.icon,
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;
    final Color iconColor = isSelected
        ? context.secondary // Uber green for selected
        : context.surface
            .withValues(alpha: 0.6); // White with opacity for unselected

    // Text'in taşmasını önlemek için Flexible ve overflow ayarı ekliyoruz
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          Text(
            text,
            style: TextStyle(
              color: iconColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
