// lib/core/services/google_places_service.dart
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:limo/core/services/logger_service.dart';

class GoogleApiKeys {
  static const String placesWebService =
      'YOUR_GOOGLE_MAPS_API_KEY';
}

class GooglePlacesService {
  GooglePlacesService()
      : _places = Dio(
          BaseOptions(
            baseUrl: 'https://maps.googleapis.com/maps/api/place/',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            // Optional: validateStatus ile 200 dışını da loglamak için
            validateStatus: (code) => code != null && code < 500,
          ),
        );

  final Dio _places; // /place/*

  String get _apiKey => GoogleApiKeys.placesWebService;

  /// Basit session token (autocomplete→details akışı için)
  String newSessionToken() {
    final r = Random();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }

  /// Adres Autocomplete
  ///
  /// [components] ile ülke kısıtlaması yapabilirsin: 'country:tr'
  /// [locationBias] + [radiusMeters] ile aramayı bir bölgeye “bias” edebilirsin.
  Future<List<Map<String, dynamic>>> autocomplete({
    required String input,
    required String sessionToken,
    String language = 'en',
    String types = 'geocode',
    String? components,
    String? locationBias, // "lat,lng"
    int? radiusMeters, // 1..50000
  }) async {
    try {
      final qp = <String, dynamic>{
        'input': input,
        'key': _apiKey,
        'language': language,
        'types': types,
        'sessiontoken': sessionToken,
      };
      if (components != null) qp['components'] = components;
      if (locationBias != null && radiusMeters != null) {
        qp['location'] = locationBias; // "41.0,29.0"
        qp['radius'] = radiusMeters; // 1..50000
      }

      final res = await _places.get('autocomplete/json', queryParameters: qp);
      final data = (res.data as Map?)?.cast<String, dynamic>() ?? const {};

      final status = data['status'] as String? ?? 'UNKNOWN';
      if (status == 'OK') {
        final preds =
            (data['predictions'] as List?)?.cast<Map<String, dynamic>>() ??
            const [];
        return preds;
      }

      // Log
      LoggerService.warning(
        '[PLACES][AUTOCOMPLETE] status=$status code=${res.statusCode} err=${data['error_message']}',
        tag: 'GooglePlaces',
      );
      return const [];
    } on DioException catch (e) {
      LoggerService.error(
        '[PLACES][AUTOCOMPLETE][HTTP] ${e.response?.statusCode} ${e.response?.data}',
        error: e,
        tag: 'GooglePlaces',
      );
      return const [];
    } catch (e) {
      LoggerService.error(
        '[PLACES][AUTOCOMPLETE][ERR] $e',
        tag: 'GooglePlaces',
      );
      return const [];
    }
  }

  /// Place Details (adres, lat/lng, place_id)
  Future<({String address, double lat, double lng, String placeId})?>
  placeDetails({
    required String placeId,
    required String sessionToken,
    String language = 'en',
  }) async {
    try {
      final res = await _places.get(
        'details/json',
        queryParameters: {
          'place_id': placeId,
          'key': _apiKey,
          'language': language,
          'sessiontoken': sessionToken,
          'fields': 'formatted_address,geometry/location,place_id',
        },
      );
      final data = (res.data as Map?)?.cast<String, dynamic>() ?? const {};
      final status = data['status'] as String? ?? 'UNKNOWN';

      if (status == 'OK') {
        final r = (data['result'] as Map?)?.cast<String, dynamic>() ?? const {};
        final loc = (r['geometry'] as Map?)?['location'] as Map?;
        final lat = (loc?['lat'] as num?)?.toDouble() ?? 0.0;
        final lng = (loc?['lng'] as num?)?.toDouble() ?? 0.0;
        final address = (r['formatted_address'] as String?) ?? '';
        final pid = (r['place_id'] as String?) ?? placeId;
        return (address: address, lat: lat, lng: lng, placeId: pid);
      }

      LoggerService.warning(
        '[PLACES][DETAILS] status=$status code=${res.statusCode} err=${data['error_message']}',
        tag: 'GooglePlaces',
      );
      return null;
    } on DioException catch (e) {
      LoggerService.error(
        '[PLACES][DETAILS][HTTP] ${e.response?.statusCode} ${e.response?.data}',
        error: e,
        tag: 'GooglePlaces',
      );
      return null;
    } catch (e) {
      LoggerService.error('[PLACES][DETAILS][ERR] $e', tag: 'GooglePlaces');
      return null;
    }
  }
}
