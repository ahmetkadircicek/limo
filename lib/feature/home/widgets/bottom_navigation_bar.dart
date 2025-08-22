import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/home/widgets/custom_nav_bar_item.dart';

/// Bottom navigation bar widget for the home view
class HomeBottomNavigationBar extends StatelessWidget {
  final HomeViewModel viewModel;
  final BoxConstraints constraints;

  const HomeBottomNavigationBar({
    super.key,
    required this.viewModel,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: context.paddingL,
      padding: context.horizontalL,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.primary, Color(0xFF333333)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: context.radiusRound,
        boxShadow: context.shadowMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomNavBarItem(
              icon:
                  viewModel.selectedIndex == 0
                      ? Icons.work
                      : Icons.work_outline,
              text: 'JOBS',
              index: 0,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: CustomNavBarItem(
              icon:
                  viewModel.selectedIndex == 1
                      ? Icons.add_circle
                      : Icons.add_circle_outline,
              text: 'POST',
              index: 1,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: CustomNavBarItem(
              icon:
                  viewModel.selectedIndex == 2
                      ? Icons.timeline
                      : Icons.timeline_outlined,
              text: 'TRACK',
              index: 2,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: CustomNavBarItem(
              icon:
                  viewModel.selectedIndex == 3
                      ? Icons.directions_car
                      : Icons.directions_car_outlined,
              text: 'FLEET',
              index: 3,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: CustomNavBarItem(
              icon:
                  viewModel.selectedIndex == 4
                      ? Icons.person
                      : Icons.person_outline,
              text: 'PROFILE',
              index: 4,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
