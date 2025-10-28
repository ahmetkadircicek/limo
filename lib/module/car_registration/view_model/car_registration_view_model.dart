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

  int _modelYear = DateTime.now().year;
  int _capacityValue = 3;

  int get modelYear => _modelYear;
  int get maxModelYear => DateTime.now().year;
  int get minModelYear => DateTime.now().year - 8;
  bool get canIncrementModelYear => _modelYear < maxModelYear;
  bool get canDecrementModelYear => _modelYear > minModelYear;

  int get capacityValue => _capacityValue;
  int get minCapacity => 3;
  int get maxCapacity => 12;
  bool get canIncrementCapacity => _capacityValue < maxCapacity;
  bool get canDecrementCapacity => _capacityValue > minCapacity;

  void incrementModelYear() {
    if (!canIncrementModelYear) return;
    _modelYear++;
    notifyListeners();
  }

  void decrementModelYear() {
    if (!canDecrementModelYear) return;
    _modelYear--;
    notifyListeners();
  }

  void incrementCapacity() {
    if (!canIncrementCapacity) return;
    _capacityValue++;
    notifyListeners();
  }

  void decrementCapacity() {
    if (!canDecrementCapacity) return;
    _capacityValue--;
    notifyListeners();
  }

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
    'modelYear': _modelYear,
    'capacity': _capacityValue,
  };

  Future<bool> submit(BuildContext context) async {
    if (selectedBrandId == null ||
        selectedModelId == null ||
        selectedCategoryId == null) {
      return false;
    }

    _submitting = true;
    notifyListeners();

    final result = await CarService.addCar(
      context,
      plateNumber: plateNumberController.text.trim(),
      brandId: selectedBrandId!,
      modelId: selectedModelId!,
      categoryId: selectedCategoryId!,
      modelYear: _modelYear,
      capacity: _capacityValue,
    );

    _submitting = false;
    notifyListeners();

    if (result.isSuccess) {
      clearForm();
      return true;
    }

    return false;
  }

  void clearForm() {
    plateNumberController.clear();
    _modelYear = maxModelYear;
    _capacityValue = minCapacity;
    _brand = null;
    _model = null;
    _category = null;
    notifyListeners();
  }

  @override
  void dispose() {
    plateNumberController.dispose();
    super.dispose();
  }
}
