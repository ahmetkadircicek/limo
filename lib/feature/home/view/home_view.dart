import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/home/viewmodel/home_view_model.dart';
import 'package:soforvarcom/feature/job_list/view/job_list_view.dart';
import 'package:soforvarcom/feature/job_tracking/view/job_tracking_view.dart';
import 'package:soforvarcom/feature/listing_job/view/listing_job_view.dart';
import 'package:soforvarcom/feature/profile/view/profile_view.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/unified_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homePageViewModel, child) {
          return Scaffold(
            key: homePageViewModel.scaffoldKey,
            appBar: UnifiedAppBar(
              onProfileTap: () {
                homePageViewModel.onItemTapped(3); // Navigate to profile page
              },
              onLogoTap: () {
                homePageViewModel.onItemTapped(0);
              },
            ),
            body: _buildBody(homePageViewModel),
            bottomNavigationBar: _buildBottomNavigationBar(homePageViewModel),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.surface,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GeneralText(
            text: 'Sofor',
            fontSize: GeneralConstants.fontSizeLarge,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.onSurface,
          ),
          GeneralText(
            text: 'var',
            fontSize: GeneralConstants.fontSizeLarge,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.primary,
          ),
          GeneralText(
            text: '.com',
            fontSize: GeneralConstants.fontSizeLarge,
            fontWeight: GeneralConstants.fontWeightBold,
            color: context.onSurface,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Implement profile navigation
          },
          icon: Icon(
            Icons.person_outline,
            color: context.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(HomeViewModel homePageViewModel) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: homePageViewModel.pageController,
      onPageChanged: homePageViewModel.onPageChanged,
      children: [
        const JobListView(), // Jobs
        const ListingJobView(), // Post job
        const JobTrackingView(), // Job tracking
        const ProfileView(), // Profile
      ],
    );
  }

  Widget _buildBottomNavigationBar(HomeViewModel viewModel) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: context.surface,
        boxShadow: [
          BoxShadow(
            color: context.secondary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _CustomNavBarItem(
              icon: Icons.list_alt,
              text: 'JOBS',
              index: 0,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: _CustomNavBarItem(
              icon: Icons.add_circle_outline,
              text: 'POST JOB',
              index: 1,
              selectedIndex: viewModel.selectedIndex,
              isHighlighted: true,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: _CustomNavBarItem(
              icon: Icons.timeline,
              text: 'TRACKING',
              index: 2,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
        ],
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
    Color backgroundColor = isSelected ? context.secondary : context.primary;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: backgroundColor,
        height: MediaQuery.of(context).size.height * 0.09,
        child: Column(
          children: [
            context.spacerHeight(1),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: context.surface,
                size: 30,
              ),
            ),
            context.spacerHeight(0.1),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              child: GeneralText(
                text: text,
                fontSize: GeneralConstants.fontSizeExtraSmall,
                fontWeight: GeneralConstants.fontWeightRegular,
                color: context.surface,
              ),
            ),
            context.spacerHeight(0.1),
          ],
        ),
      ),
    );
  }
}
