import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/module/car_management/view/car_management_view.dart';
import 'package:limo/module/job_create/view/job_create_view.dart';
import 'package:limo/module/jobs/view/jobs_view.dart';
import 'package:limo/module/navigation/view_model/navigation_view_model.dart';
import 'package:limo/module/navigation/widgets/drawer_widget.dart';
import 'package:limo/module/navigation/widgets/navigation_app_bar.dart';
import 'package:limo/module/navigation/widgets/navigation_bar_widget.dart';
import 'package:limo/module/profile/services/logout_service.dart';
import 'package:limo/module/profile/view/profile_view.dart';
import 'package:provider/provider.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          key: viewModel.scaffoldKey,
          appBar: _buildAppBar(viewModel),
          drawer: _buildAppDrawer(context, viewModel),
          body: _buildScaffoldBody(viewModel),
        );
      },
    );
  }

  DrawerWidget _buildAppDrawer(
    BuildContext context,
    NavigationViewModel viewModel,
  ) {
    return DrawerWidget(
      onLogoutTap: () async {
        await _handleLogout(context);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      onDebugTap: () => _navigateDrawerPage(context, viewModel, 5),
      onSettingsTap: () => _navigateDrawerPage(context, viewModel, 6),
      onHelpSupportTap: () => _navigateDrawerPage(context, viewModel, 7),
      onFAQTap: () => _navigateDrawerPage(context, viewModel, 8),
      onAboutTap: () => _navigateDrawerPage(context, viewModel, 9),
      onPrivacyPolicyTap: () => _navigateDrawerPage(context, viewModel, 10),
      onTermsConditionsTap: () => _navigateDrawerPage(context, viewModel, 11),
      onNotificationsTap: () => _navigateDrawerPage(context, viewModel, 12),
    );
  }

  PreferredSizeWidget _buildAppBar(NavigationViewModel viewModel) {
    return NavigationAppBar(title: 'Limo');
  }

  Widget _buildScaffoldBody(NavigationViewModel viewModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(
              bottom: 46,
              child: _buildPageContent(viewModel, context),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NavigationBarWidget(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageContent(
    NavigationViewModel viewModel,
    BuildContext context,
  ) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: viewModel.pageController,
          children: const [
            JobsView(),
            JobCreateView(),
            Placeholder(),
            CarManagementView(),
            ProfileView(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Close drawer first
      Navigator.of(context).pop();

      // Perform logout
      await LogoutService.logout(context);

      if (!context.mounted) return;

      // Navigate to splash screen and clear all navigation history
      context.go(RoutePaths.splash);
    } catch (e) {
      if (!context.mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateDrawerPage(
    BuildContext context,
    NavigationViewModel viewModel,
    int index,
  ) {
    Navigator.of(context).pop();
    viewModel.navigateToDrawerPage(index);
  }
}
