import 'package:flutter/foundation.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/module/car_management/services/model_service.dart';
import 'package:limo/shared/models/model_model.dart';

class ModelProvider extends ChangeNotifier {
  static const String _tag = 'MODEL_PROVIDER';

  List<ModelModel> _models = [];
  bool _isLoading = false;
  String? _error;
  int? _currentBrandId;

  List<ModelModel> get models => _models;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasModels => _models.isNotEmpty;
  int? get currentBrandId => _currentBrandId;

  /// Fetch models from API by brand_id
  Future<void> fetchModels({
    required String userId,
    required String accessToken,
    required int brandId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final models = await ModelService.getModels(
        userId: userId,
        accessToken: accessToken,
        brandId: brandId,
      );

      _setModels(models, brandId);

      LoggerService.success(
        'Models loaded to provider: ${models.length} models for brand $brandId',
        tag: _tag,
      );
    } catch (e) {
      _setError(e.toString());
      LoggerService.error('Failed to load models to provider: $e', tag: _tag);
    } finally {
      _setLoading(false);
    }
  }

  /// Clear models and reset state
  void clearModels() {
    _models = [];
    _error = null;
    _currentBrandId = null;
    notifyListeners();
  }

  void _setModels(List<ModelModel> models, int brandId) {
    _models = models;
    _currentBrandId = brandId;
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
