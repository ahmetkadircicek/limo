import 'package:flutter/material.dart';
import 'package:limo/core/navigation/navigation_service.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/car_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';
import 'package:provider/provider.dart';

class CarManagementViewModel extends ChangeNotifier {
  Future<void> addCarPressed(BuildContext context) async {
    final user = context.read<UserProvider>().user;
    if (user == null) {
      AppSnackbar.warning(message: 'Please sign in to add a car.');
      return;
    }

    await Future.wait([
      context.read<CategoryProvider>().fetchCategories(
        userId: user.userId,
        accessToken: user.accessToken!,
      ),
      context.read<BrandProvider>().fetchBrands(
        userId: user.userId,
        accessToken: user.accessToken!,
      ),
    ]);

    final result = await NavigationService.push<bool>(
      RoutePaths.carRegistration,
    );

    if (result == true && context.mounted) {
      await context.read<CarProvider>().loadCars(context);
    }
  }
}
