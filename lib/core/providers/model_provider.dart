import 'package:flutter/foundation.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/core/services/model_service.dart';
import 'package:limo/shared/models/model_model.dart';
import 'package:limo/shared/state/async_status.dart';

class ModelProvider extends ChangeNotifier {
  static const String _tag = 'MODEL_PROVIDER';

  List<ModelModel> _models = [];
  AsyncStatus _status = AsyncStatus.idle;
  String? _errorMessage;
  int? _currentBrandId;

  List<ModelModel> get models => _models;
  AsyncStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasModels => _models.isNotEmpty;
  int? get currentBrandId => _currentBrandId;

  /// Fetch models from API by brand_id
  Future<void> fetchModels({
    required String userId,
    required String accessToken,
    required int brandId,
  }) async {
    try {
      _setStatus(AsyncStatus.loading);
      _errorMessage = null;

      final result = await ModelService.getModels(
        userId: userId,
        accessToken: accessToken,
        brandId: brandId,
      );

      if (result.isError) {
        _models = [];
        _errorMessage = result.message;
        _currentBrandId = brandId;
        _setStatus(AsyncStatus.error);
        LoggerService.error(
          'Failed to load models to provider: ${result.message}',
          tag: _tag,
        );
        return;
      }

      final models = result.data ?? const [];

      _setModels(models, brandId);

      LoggerService.success(
        'Models loaded to provider: ${models.length} models for brand $brandId',
        tag: _tag,
      );
      _setStatus(models.isEmpty ? AsyncStatus.empty : AsyncStatus.success);
    } catch (e) {
      _models = [];
      _errorMessage = e.toString();
      _currentBrandId = brandId;
      _setStatus(AsyncStatus.error);
      LoggerService.error('Failed to load models to provider: $e', tag: _tag);
    } finally {
      if (_status == AsyncStatus.loading) {
        _setStatus(AsyncStatus.idle);
      }
    }
  }

  /// Clear models and reset state
  void clearModels() {
    _models = [];
    _errorMessage = null;
    _currentBrandId = null;
    _setStatus(AsyncStatus.idle);
  }

  void _setModels(List<ModelModel> models, int brandId) {
    _models = models;
    _currentBrandId = brandId;
    notifyListeners();
  }

  void _setStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
