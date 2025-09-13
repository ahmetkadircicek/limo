import 'package:flutter/foundation.dart';
import 'package:limo/core/services/brand_service.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/shared/models/brand_model.dart';

class BrandProvider extends ChangeNotifier {
  static const String _tag = 'BRAND_PROVIDER';

  List<BrandModel> _brands = [];
  bool _isLoading = false;
  String? _error;

  List<BrandModel> get brands => _brands;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasBrands => _brands.isNotEmpty;

  /// Fetch brands from API
  Future<void> fetchBrands({
    required String userId,
    required String accessToken,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final brands = await BrandService.getBrands(
        userId: userId,
        accessToken: accessToken,
      );

      _setBrands(brands);

      LoggerService.success(
        'Brands loaded to provider: ${brands.length} brands',
        tag: _tag,
      );
    } catch (e) {
      _setError(e.toString());
      LoggerService.error('Failed to load brands to provider: $e', tag: _tag);
    } finally {
      _setLoading(false);
    }
  }

  /// Clear brands and reset state
  void clearBrands() {
    _brands = [];
    _error = null;
    notifyListeners();
  }

  void _setBrands(List<BrandModel> brands) {
    _brands = brands;
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
