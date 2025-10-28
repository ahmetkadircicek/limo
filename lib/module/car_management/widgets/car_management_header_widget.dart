import 'package:flutter/material.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_chip_button.dart';

class CarManagementHeaderWidget extends StatelessWidget {
  const CarManagementHeaderWidget({
    super.key,
    required this.carCount,
    required this.onAddCar,
  });

  final int carCount;
  final VoidCallback onAddCar;

  @override
  Widget build(BuildContext context) {
    final countLabel =
        carCount == 0
            ? 'No cars registered'
            : '$carCount ${carCount == 1 ? 'car' : 'cars'} registered';

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
                  countLabel,
                  style: context.subhead.copyWith(
                    color: context.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SharedChipButton(
              text: 'Add Car',
              icon: Icons.directions_car_filled,
              onPressed: onAddCar,
              backgroundColor: context.primary,
              foregroundColor: context.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
