import 'package:flutter/material.dart';
import 'package:limo/core/navigation/navigation_service.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CarManagementViewModel extends ChangeNotifier {
  void addCarPressed(BuildContext context) {
    final user = context.read<UserProvider>().user;
    if (user == null) {
      return;
    }
    context.read<CategoryProvider>().fetchCategories(
      userId: user.userId,
      accessToken: user.accessToken!,
    );
    context.read<BrandProvider>().fetchBrands(
      userId: user.userId,
      accessToken: user.accessToken!,
    );
    NavigationService.push(RoutePaths.carRegistration);
  }
}
