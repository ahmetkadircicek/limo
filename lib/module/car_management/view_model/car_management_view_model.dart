import 'package:flutter/material.dart';
import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/car_registration/view/car_registration_view.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CarRegistrationView()),
    );
  }
}
