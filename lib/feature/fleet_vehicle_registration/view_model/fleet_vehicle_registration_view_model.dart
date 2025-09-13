import 'package:flutter/material.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:provider/provider.dart';

class FleetVehicleRegistrationViewModel extends ChangeNotifier {
  // Controllers
  final plateNumberController = TextEditingController();
  final modelYearController = TextEditingController();
  final capacityController = TextEditingController();

  // Seçimler
  BrandModel? _selectedBrand;
  ModelModel? _selectedModel;
  CategoryModel? _selectedCategory;

  int? get selectedBrandId => _selectedBrand?.brandId;
  int? get selectedModelId => _selectedModel?.modelId;
  int? get selectedCategoryId => _selectedCategory?.categoryId;

  BrandModel? get selectedBrand => _selectedBrand;
  ModelModel? get selectedModel => _selectedModel;
  CategoryModel? get selectedCategory => _selectedCategory;

  void selectBrand(BuildContext context, BrandModel brand) {
    _selectedBrand = brand;
    _selectedModel = null; // reset model

    final user = context.read<UserProvider>().user;
    if (user != null) {
      context.read<ModelProvider>().fetchModels(
        userId: user.userId ?? '',
        accessToken: user.accessToken ?? '',
        brandId: brand.brandId ?? 0,
      );
    }
    notifyListeners();
  }

  void selectModel(ModelModel? model) {
    _selectedModel = model;
    notifyListeners();
  }

  void selectCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Map<String, dynamic> buildPayload() {
    final year = int.tryParse(modelYearController.text.trim());
    final capacity = int.tryParse(capacityController.text.trim());

    return {
      'plateNumber': plateNumberController.text.trim(),
      'brandId': selectedBrandId,
      'modelId': selectedModelId,
      'categoryId': selectedCategoryId,
      'modelYear': year,
      'capacity': capacity,
    };
  }

  String? validate() {
    if (plateNumberController.text.trim().isEmpty) return 'Plate is required';
    if (selectedBrandId == null) return 'Brand is required';
    if (selectedModelId == null) return 'Model is required';
    if (selectedCategoryId == null) return 'Category is required';
    if (int.tryParse(modelYearController.text.trim()) == null)
      return 'Year invalid';
    if (int.tryParse(capacityController.text.trim()) == null)
      return 'Capacity invalid';
    return null;
  }

  void clearForm() {
    plateNumberController.clear();
    modelYearController.clear();
    capacityController.clear();
    _selectedBrand = null;
    _selectedModel = null;
    _selectedCategory = null;
    notifyListeners();
  }

  @override
  void dispose() {
    plateNumberController.dispose();
    modelYearController.dispose();
    capacityController.dispose();
    super.dispose();
  }
}
