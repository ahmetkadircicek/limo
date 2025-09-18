import 'package:flutter/material.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/car_service.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:provider/provider.dart';

class CarRegistrationViewModel extends ChangeNotifier {
  // Controllers
  final plateNumberController = TextEditingController();
  final modelYearController = TextEditingController();
  final capacityController = TextEditingController();

  // Selections
  BrandModel? _brand;
  ModelModel? _model;
  CategoryModel? _category;

  BrandModel? get selectedBrand => _brand;
  ModelModel? get selectedModel => _model;
  CategoryModel? get selectedCategory => _category;

  int? get selectedBrandId => _brand?.brandId;
  int? get selectedModelId => _model?.modelId;
  int? get selectedCategoryId => _category?.categoryId;

  bool _submitting = false;
  bool get isSubmitting => _submitting;

  bool get isFormReady {
    return plateNumberController.text.trim().isNotEmpty &&
        selectedBrandId != null &&
        selectedModelId != null &&
        selectedCategoryId != null &&
        int.tryParse(modelYearController.text.trim()) != null &&
        int.tryParse(capacityController.text.trim()) != null;
  }

  void selectBrand(BuildContext context, BrandModel brand) {
    _brand = brand;
    _model = null; // reset model
    final user = context.read<UserProvider>().user;
    final token = user?.accessToken;
    if (user?.userId != null && token != null && brand.brandId != null) {
      context.read<ModelProvider>().fetchModels(
        userId: user!.userId,
        accessToken: token,
        brandId: brand.brandId!,
      );
    }
    notifyListeners();
  }

  void selectModel(ModelModel? model) {
    _model = model;
    notifyListeners();
  }

  void selectCategory(CategoryModel? category) {
    _category = category;
    notifyListeners();
  }

  Map<String, dynamic> buildPayload() => {
    'plateNumber': plateNumberController.text.trim(),
    'brandId': selectedBrandId,
    'modelId': selectedModelId,
    'categoryId': selectedCategoryId,
    'modelYear': int.tryParse(modelYearController.text.trim()),
    'capacity': int.tryParse(capacityController.text.trim()),
  };

  Future<bool> submit(BuildContext context) async {
    if (!isFormReady) return false;

    _submitting = true;
    notifyListeners();

    final ok = await CarService.addCar(
      context,
      plateNumber: plateNumberController.text.trim(),
      brandId: selectedBrandId!,
      modelId: selectedModelId!,
      categoryId: selectedCategoryId!,
      modelYear: int.parse(modelYearController.text.trim()),
      capacity: int.parse(capacityController.text.trim()),
    );

    _submitting = false;
    notifyListeners();

    if (ok) clearForm();
    return ok;
  }

  void clearForm() {
    plateNumberController.clear();
    modelYearController.clear();
    capacityController.clear();
    _brand = null;
    _model = null;
    _category = null;
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
