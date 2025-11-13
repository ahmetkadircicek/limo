import 'package:flutter/material.dart';
import 'package:limo/core/providers/car_provider.dart';
import 'package:limo/core/services/car_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/models/car_model.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:limo/shared/widgets/shared_card.dart';
import 'package:provider/provider.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key, required this.carModel});

  final CarModel carModel;

  Future<bool> _deleteCar(BuildContext context) async {
    final result = await CarService.deleteCar(context, carsId: carModel.carsId);
    if (!context.mounted) return false;
    LoggerService.info(
      'Delete car id: ${carModel.carsId}, result: ${result.isSuccess}',
    );
    if (result.isSuccess) {
      await context.read<CarProvider>().loadCars(context);
      AppSnackbar.success(message: 'Car deleted');
      return true;
    }
    AppSnackbar.error(message: result.message ?? 'Failed to delete car');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plate = carModel.plateNumber;
    final brand = carModel.brandName ?? '${carModel.brandId ?? '-'}';
    final model = carModel.modelName ?? '${carModel.modelId ?? '-'}';
    final category = carModel.categoryName ?? '${carModel.categoryId ?? '-'}';
    final capacity = carModel.capacity?.toString() ?? '-';
    final year = carModel.modelYear?.toString() ?? '-';

    return Dismissible(
      key: ValueKey(carModel.carsId),
      direction: DismissDirection.endToStart,
      background: _DismissBackground(
        color: context.error,
        iconColor: context.onError,
      ),
      confirmDismiss: (_) => _deleteCar(context),
      child: SharedCard(
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: PaddingConstants.all8,
            child: Row(
              children: [
                _LeadingBadge(plate: plate),
                const SizedBox(width: PaddingConstants.p8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: PaddingConstants.p8,
                    children: [
                      Text(
                        '$brand $model',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$plate • $category • $capacity seats • $year',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: context.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: PaddingConstants.p8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadingBadge extends StatelessWidget {
  const _LeadingBadge({required this.plate});

  final String plate;

  @override
  Widget build(BuildContext context) {
    final initials =
        plate.isNotEmpty
            ? plate.substring(0, plate.length >= 2 ? 2 : 1).toUpperCase()
            : '??';
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: RadiusConstants.standard,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({required this.color, required this.iconColor});

  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: RadiusConstants.standard,
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Icon(Icons.delete_outline, color: iconColor, size: 26),
    );
  }
}
