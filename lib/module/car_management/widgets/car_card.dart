import 'package:flutter/material.dart';
import 'package:limo/core/providers/car_provider.dart';
import 'package:limo/core/services/car_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/models/car_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:limo/shared/widgets/shared_chip_button.dart';
import 'package:provider/provider.dart';

class CarCard extends StatelessWidget {
  final CarModel carModel;
  const CarCard({super.key, required this.carModel});

  Future<void> _deleteCar(BuildContext context) async {
    final ok = await CarService.deleteCar(context, carsId: carModel.carsId);
    LoggerService.info('Delete car id: ${carModel.carsId}, result: $ok');
    if (ok) {
      context.read<CarProvider>().loadCars(context);
      AppSnackbar.success(message: 'Car deleted');
    } else {
      AppSnackbar.error(message: 'Failed to delete car');
    }
  }

  @override
  Widget build(BuildContext context) {
    final plate = carModel.plateNumber;
    final year = carModel.modelYear?.toString() ?? '-';
    final brand = carModel.brandName ?? '${carModel.brandId ?? '-'}';
    final model = carModel.modelName ?? '${carModel.modelId ?? '-'}';
    final category = carModel.categoryName ?? '${carModel.categoryId ?? '-'}';
    final capacity = carModel.capacity?.toString() ?? '-';

    return SharedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: PaddingConstants.p12,
        children: [
          // Brand • Model
          Text(
            '$brand • $model',
            style: context.body.copyWith(color: context.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Wrap(
            spacing: PaddingConstants.p8,
            children: [
              _MetaPill(text: plate, icon: Icons.directions_car_filled),
              _MetaPill(text: year, icon: Icons.calendar_month_outlined),
              _MetaPill(text: category, icon: Icons.label_rounded),
              _MetaPill(text: capacity, icon: Icons.event_seat),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SharedChipButton(
              text: 'Delete',
              icon: Icons.delete_outline,
              backgroundColor: context.error.withValues(alpha: 0.12),
              foregroundColor: context.error,
              onPressed: () async {
                await _deleteCar(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String text;
  final IconData icon;
  const _MetaPill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PaddingConstants.all4 + PaddingConstants.horizontal8,
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: RadiusConstants.round, // TODO: move to theme
        border: Border.all(color: context.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        spacing: PaddingConstants.p8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.onSurface),
          Text(
            text,
            style: context.caption1.copyWith(color: context.onSurface),
          ),
        ],
      ),
    );
  }
}
