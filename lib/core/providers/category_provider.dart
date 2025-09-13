import 'package:flutter/foundation.dart';
import 'package:limo/core/services/category_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/shared/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  static const String _tag = 'CATEGORY_PROVIDER';

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCategories => _categories.isNotEmpty;

  /// Fetch categories from API
  Future<void> fetchCategories({
    required String userId,
    required String accessToken,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final categories = await CategoryService.getCategories(
        userId: userId,
        accessToken: accessToken,
      );

      _setCategories(categories);

      LoggerService.success(
        'Categories loaded to provider: ${categories.length} categories',
        tag: _tag,
      );
    } catch (e) {
      _setError(e.toString());
      LoggerService.error(
        'Failed to load categories to provider: $e',
        tag: _tag,
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Clear categories and reset state
  void clearCategories() {
    _categories = [];
    _error = null;
    notifyListeners();
  }

  void _setCategories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
