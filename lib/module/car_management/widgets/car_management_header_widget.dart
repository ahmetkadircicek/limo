import 'package:flutter/material.dart';
import 'package:limo/module/car_management/view_model/car_management_view_model.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_chip_button.dart';
import 'package:provider/provider.dart';

class CarManagementHeaderWidget extends StatelessWidget {
  const CarManagementHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.bottom20,
      child: SharedCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Car Management', style: context.headline),
                Text(
                  '0 cars registered',
                  style: context.subhead.copyWith(
                    color: context.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            // Use Consumer to access the ViewModel for button logic
            Consumer<CarManagementViewModel>(
              builder: (context, viewModel, _) {
                return SharedChipButton(
                  text: 'Add Car',
                  icon: Icons.directions_car_filled,
                  onPressed: () => viewModel.addCarPressed(context),
                  backgroundColor: context.primary,
                  foregroundColor: context.onPrimary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
