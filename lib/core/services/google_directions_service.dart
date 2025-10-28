import 'package:dio/dio.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/core/services/google_places_service.dart';

class GoogleDirectionsService {
  GoogleDirectionsService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://maps.googleapis.com/maps/api/directions/',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            validateStatus: (code) => code != null && code < 500,
          ),
        );

  final Dio _dio;

  String get _apiKey => GoogleApiKeys.placesWebService;

  /// Returns distance in meters and duration in seconds if available, else null.
  Future<({int meters, int seconds})?> routeDistanceDuration({
    String? originAddress,
    double? originLat,
    double? originLng,
    String? destinationAddress,
    double? destinationLat,
    double? destinationLng,
  }) async {
    try {
      final origin = _formatLocation(originAddress, originLat, originLng);
      final destination = _formatLocation(destinationAddress, destinationLat, destinationLng);
      if (origin == null || destination == null) return null;

      final res = await _dio.get('json', queryParameters: {
        'origin': origin,
        'destination': destination,
        'key': _apiKey,
        'units': 'imperial', // US
      });

      final data = (res.data as Map?)?.cast<String, dynamic>() ?? const {};
      final status = data['status'] as String? ?? 'UNKNOWN';
      if (status != 'OK') {
        LoggerService.warning('[DIRECTIONS] status=$status code=${res.statusCode} err=${data['error_message']}', tag: 'GoogleDirections');
        return null;
      }

      final routes = (data['routes'] as List?) ?? const [];
      if (routes.isEmpty) return null;
      final legs = ((routes.first as Map)['legs'] as List?) ?? const [];
      if (legs.isEmpty) return null;
      final leg = (legs.first as Map).cast<String, dynamic>();
      final distance = (leg['distance'] as Map?)?['value'] as int?; // meters
      final duration = (leg['duration'] as Map?)?['value'] as int?; // seconds
      if (distance == null || duration == null) return null;
      return (meters: distance, seconds: duration);
    } on DioException catch (e) {
      LoggerService.error('[DIRECTIONS][HTTP] ${e.response?.statusCode} ${e.response?.data}', error: e, tag: 'GoogleDirections');
      return null;
    } catch (e) {
      LoggerService.error('[DIRECTIONS][ERR] $e', tag: 'GoogleDirections');
      return null;
    }
  }

  String? _formatLocation(String? address, double? lat, double? lng) {
    if (lat != null && lng != null) {
      return '$lat,$lng';
    }
    final a = address?.trim();
    if (a == null || a.isEmpty) return null;
    return a;
  }
}

