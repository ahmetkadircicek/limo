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
      height: 72,
      margin: context.paddingL,
      decoration: BoxDecoration(
        color: context.primary,
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
                      ? Icons.location_on
                      : Icons.location_on_outlined,
              text: 'TRACK',
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
