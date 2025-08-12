import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
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
      margin: PaddingConstants.allM,
      decoration: BoxDecoration(
        color: context.primary,
        borderRadius: GeneralConstants.borderRadiusRound,
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
            child: CustomNavBarItem(
              icon: Icons.work_outline,
              text: 'JOBS',
              index: 0,
              selectedIndex: viewModel.selectedIndex,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: CustomNavBarItem(
              icon: Icons.add_circle_outline,
              text: 'POST',
              index: 1,
              selectedIndex: viewModel.selectedIndex,
              isHighlighted: true,
              onTap: viewModel.onItemTapped,
            ),
          ),
          Expanded(
            child: CustomNavBarItem(
              icon: Icons.location_on_outlined,
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
