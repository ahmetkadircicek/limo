import 'package:flutter/foundation.dart';
import 'package:limo/core/services/category_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/category_model.dart';
import 'package:limo/shared/state/async_status.dart';

class CategoryProvider extends ChangeNotifier {
  static const String _tag = 'CATEGORY_PROVIDER';

  List<CategoryModel> _categories = [];
  AsyncStatus _status = AsyncStatus.idle;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;
  AsyncStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasCategories => _categories.isNotEmpty;

  /// Fetch categories from API
  Future<void> fetchCategories({
    required String userId,
    required String accessToken,
    bool force = false,
  }) async {
    try {
      if (!force && _categories.isNotEmpty && _status == AsyncStatus.success) {
        return;
      }
      _setStatus(AsyncStatus.loading);
      _errorMessage = null;

      final result = await CategoryService.getCategories(
        userId: userId,
        accessToken: accessToken,
      );

      if (result.isError) {
        _categories = [];
        _errorMessage = result.message;
        _setStatus(AsyncStatus.error);
        LoggerService.error(
          'Failed to load categories to provider: ${result.message}',
          tag: _tag,
        );
        return;
      }

      final categories = result.data ?? const [];

      _setCategories(categories);

      LoggerService.success(
        'Categories loaded to provider: ${categories.length} categories',
        tag: _tag,
      );
      _setStatus(categories.isEmpty ? AsyncStatus.empty : AsyncStatus.success);
    } catch (e) {
      _categories = [];
      _errorMessage = e.toString();
      _setStatus(AsyncStatus.error);
      LoggerService.error(
        'Failed to load categories to provider: $e',
        tag: _tag,
      );
    } finally {
      if (_status == AsyncStatus.loading) {
        _setStatus(AsyncStatus.idle);
      }
    }
  }

  /// Clear categories and reset state
  void clearCategories() {
    _categories = [];
    _errorMessage = null;
    _setStatus(AsyncStatus.idle);
  }

  void _setCategories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  void _setStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
