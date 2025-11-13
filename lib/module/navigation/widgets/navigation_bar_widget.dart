import 'package:flutter/material.dart';
import 'package:limo/module/navigation/view_model/navigation_view_model.dart';
import 'package:limo/module/navigation/widgets/navigation_bar_item_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:provider/provider.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildNavBar(context);
  }

  // Builds the navigation bar with items
  Widget _buildNavBar(BuildContext context) {
    return Consumer<NavigationViewModel>(
      builder: (context, navVm, child) {
        return Container(
          height: 90,
          padding: PaddingConstants.top8,
          decoration: BoxDecoration(
            color: context.surfaceContainer,
            border: Border(top: BorderSide(color: context.surfaceContainer)),
          ),
          child: Column(children: [_buildNavRow(context, navVm)]),
        );
      },
    );
  }

  Widget _buildNavRow(
    BuildContext context,
    NavigationViewModel navigationViewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        NavigationBarItemWidget(
          icon:
              navigationViewModel.selectedIndex == 0
                  ? Icons.home
                  : Icons.home_outlined,
          isSelected: navigationViewModel.selectedIndex == 0,
          onTap: () => navigationViewModel.onItemTapped(0),
          label: 'Jobs',
        ),
        NavigationBarItemWidget(
          icon:
              navigationViewModel.selectedIndex == 1
                  ? Icons.add_circle
                  : Icons.add_circle_outline,
          isSelected: navigationViewModel.selectedIndex == 1,
          onTap: () => navigationViewModel.onItemTapped(1),
          label: 'Post',
        ),
        NavigationBarItemWidget(
          icon:
              navigationViewModel.selectedIndex == 2
                  ? Icons.timeline
                  : Icons.timeline_outlined,
          isSelected: navigationViewModel.selectedIndex == 2,
          onTap: () => navigationViewModel.onItemTapped(2),
          label: 'Dash',
        ),
        NavigationBarItemWidget(
          icon:
              navigationViewModel.selectedIndex == 3
                  ? Icons.directions_car
                  : Icons.directions_car_outlined,
          isSelected: navigationViewModel.selectedIndex == 3,
          onTap: () => navigationViewModel.onItemTapped(3),
          label: 'Cars',
        ),
        NavigationBarItemWidget(
          icon:
              navigationViewModel.selectedIndex == 4
                  ? Icons.person
                  : Icons.person_outline,
          isSelected: navigationViewModel.selectedIndex == 4,
          onTap: () => navigationViewModel.onItemTapped(4),
          label: 'Profile',
        ),
      ],
    );
  }
}
