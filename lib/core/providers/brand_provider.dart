import 'package:flutter/foundation.dart';
import 'package:limo/core/services/brand_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/models/brand_model.dart';
import 'package:limo/shared/state/async_status.dart';

class BrandProvider extends ChangeNotifier {
  static const String _tag = 'BRAND_PROVIDER';

  List<BrandModel> _brands = [];
  AsyncStatus _status = AsyncStatus.idle;
  String? _errorMessage;

  List<BrandModel> get brands => _brands;
  AsyncStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasBrands => _brands.isNotEmpty;

  /// Fetch brands from API
  Future<void> fetchBrands({
    required String userId,
    required String accessToken,
  }) async {
    try {
      _setStatus(AsyncStatus.loading);
      _errorMessage = null;

      final result = await BrandService.getBrands(
        userId: userId,
        accessToken: accessToken,
      );

      if (result.isError) {
        _brands = [];
        _errorMessage = result.message;
        _setStatus(AsyncStatus.error);
        LoggerService.error(
          'Failed to load brands to provider: ${result.message}',
          tag: _tag,
        );
        return;
      }

      final brands = result.data ?? const [];

      _setBrands(brands);

      LoggerService.success(
        'Brands loaded to provider: ${brands.length} brands',
        tag: _tag,
      );

      _setStatus(brands.isEmpty ? AsyncStatus.empty : AsyncStatus.success);
    } catch (e) {
      _brands = [];
      _errorMessage = e.toString();
      _setStatus(AsyncStatus.error);
      LoggerService.error('Failed to load brands to provider: $e', tag: _tag);
    } finally {
      if (_status == AsyncStatus.loading) {
        _setStatus(AsyncStatus.idle);
      }
    }
  }

  /// Clear brands and reset state
  void clearBrands() {
    _brands = [];
    _errorMessage = null;
    _setStatus(AsyncStatus.idle);
  }

  void _setBrands(List<BrandModel> brands) {
    _brands = brands;
    notifyListeners();
  }

  void _setStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}
