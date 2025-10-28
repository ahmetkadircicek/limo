import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/models/car_requirement_model.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/utils/currency_input_formatter.dart';
import 'package:provider/provider.dart';

class AddCarRequirementViewModel extends ChangeNotifier {
  AddCarRequirementViewModel() {
    _mileFeeController.addListener(_handleTextChange);
    _hourlyFeeController.addListener(_handleTextChange);
  }

  final TextEditingController _mileFeeController = TextEditingController();
  final TextEditingController _hourlyFeeController = TextEditingController();

  TextEditingController get mileFeeController => _mileFeeController;
  TextEditingController get hourlyFeeController => _hourlyFeeController;

  int _modelYear = DateTime.now().year;
  int _capacity = 3;

  int get modelYear => _modelYear;
  int get capacity => _capacity;

  int get minModelYear => DateTime.now().year - 8;
  int get maxModelYear => DateTime.now().year;
  bool get canIncrementModelYear => _modelYear < maxModelYear;
  bool get canDecrementModelYear => _modelYear > minModelYear;

  int get minCapacity => 1;
  int get maxCapacity => 12;
  bool get canIncrementCapacity => _capacity < maxCapacity;
  bool get canDecrementCapacity => _capacity > minCapacity;

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
    _capacity++;
    notifyListeners();
  }

  void decrementCapacity() {
    if (!canDecrementCapacity) return;
    _capacity--;
    notifyListeners();
  }

  BrandModel? _selectedBrand;
  ModelModel? _selectedModel;
  CategoryModel? _selectedCategory;

  BrandModel? get selectedBrand => _selectedBrand;
  ModelModel? get selectedModel => _selectedModel;
  CategoryModel? get selectedCategory => _selectedCategory;

  int? get selectedBrandId => _selectedBrand?.brandId;
  int? get selectedModelId => _selectedModel?.modelId;
  int? get selectedCategoryId => _selectedCategory?.categoryId;

  void selectBrand(BuildContext context, BrandModel? brand) {
    if (brand == null || brand.brandId == null) {
      _selectedBrand = null;
      _selectedModel = null;
      notifyListeners();
      return;
    }

    _selectedBrand = brand;
    _selectedModel = null;

    final user = context.read<UserProvider>().user;
    final token = user?.accessToken;
    if (user?.userId != null && token != null) {
      context.read<ModelProvider>().fetchModels(
        userId: user!.userId,
        accessToken: token,
        brandId: brand.brandId!,
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

  bool get canSubmit =>
      selectedBrandId != null &&
      selectedModelId != null &&
      selectedCategoryId != null &&
      parseCurrency(_mileFeeController.text) != null &&
      parseCurrency(_hourlyFeeController.text) != null;

  CarRequirementModel? buildRequirement() {
    final brandId = selectedBrandId;
    final modelId = selectedModelId;
    final categoryId = selectedCategoryId;
    final mileFee = parseCurrency(_mileFeeController.text);
    final hourlyFee = parseCurrency(_hourlyFeeController.text);

    if (brandId == null ||
        modelId == null ||
        categoryId == null ||
        mileFee == null ||
        hourlyFee == null) {
      return null;
    }

    return CarRequirementModel(
      brandId: brandId,
      modelId: modelId,
      modelYear: _modelYear,
      capacity: _capacity,
      categoryId: categoryId,
      mileFee: mileFee,
      hourlyFee: hourlyFee,
    );
  }

  List<TextInputFormatter> get currencyInputFormatters => [
    CurrencyInputFormatter(),
  ];

  void _handleTextChange() => notifyListeners();

  int? parseCurrency(String value) => _parseCurrency(value);

  int? _parseCurrency(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.,]'), '');
    if (cleaned.isEmpty) return null;

    final normalized = _normalize(cleaned);

    final parsed = double.tryParse(normalized);
    if (parsed == null) return null;

    return parsed.round();
  }

  String _normalize(String input) {
    var result = input;

    if (result.contains('.')) {
      return result.replaceAll(',', '');
    }

    if (result.contains(',')) {
      final lastComma = result.lastIndexOf(',');
      final decimalsLength = result.length - lastComma - 1;

      if (decimalsLength > 0 && decimalsLength <= 2) {
        result = result.replaceRange(lastComma, lastComma + 1, '.');
      }

      result = result.replaceAll(',', '');
    }

    return result;
  }

  @override
  void dispose() {
    _mileFeeController.dispose();
    _hourlyFeeController.dispose();
    super.dispose();
  }
}
