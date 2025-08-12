import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:limo/core/constants/constants.dart';
import 'package:limo/feature/map/models/location_model.dart';

class LocationService {
  static const String _tag = 'LocationService';

  // Google Places API endpoint'leri
  static const String _placesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';
  static const String _geocodingBaseUrl =
      'https://maps.googleapis.com/maps/api/geocode';

  /// Get current location of the device
  static Future<LocationModel?> getCurrentLocation() async {
    try {
      developer.log('📍 Getting current location...', name: _tag);

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        developer.log('🔒 Requesting location permission...', name: _tag);
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          developer.log('❌ Location permission denied', name: _tag);
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        developer.log('❌ Location permission permanently denied', name: _tag);
        return null;
      }

      // Get current position
      developer.log('📡 Getting GPS position...', name: _tag);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      developer.log(
          '✅ GPS position obtained: ${position.latitude}, ${position.longitude}',
          name: _tag);

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            '${place.street ?? ''} ${place.subLocality ?? ''} ${place.locality ?? ''} ${place.country ?? ''}'
                .trim();

        final location = LocationModel(
          placeName: place.locality ?? 'Current Location',
          address: address,
          latitude: position.latitude,
          longitude: position.longitude,
          placeId: 'current_${position.latitude}_${position.longitude}',
        );

        developer.log('📍 Address found: ${location.placeName}', name: _tag);
        return location;
      }

      final location = LocationModel(
        placeName: 'Current Location',
        address: 'Unknown Address',
        latitude: position.latitude,
        longitude: position.longitude,
        placeId: 'current_${position.latitude}_${position.longitude}',
      );

      developer.log('📍 Default location created', name: _tag);
      return location;
    } catch (e) {
      developer.log('💥 Error getting current location: $e', name: _tag);
      return null;
    }
  }

  /// Search places using Google Places API
  static Future<List<LocationModel>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    developer.log('🔍 Searching for location: "$query"', name: _tag);

          try {
        // 1. Get user's current location
        final currentLocation = await getCurrentLocation();

              // 2. Try different search strategies
        final List<LocationModel> allResults = <LocationModel>[];
        
        // Strategy 1: Universal Places API search (no region restriction)
        final placesResults =
            await _searchPlacesAPIUniversal(query, currentLocation);
        allResults.addAll(placesResults);
        
        // Strategy 2: Search near user's location
        if (currentLocation != null) {
          final nearbyResults = await _searchNearbyPlaces(query, currentLocation);
          allResults.addAll(nearbyResults);
        }
        
        // Strategy 3: Address search with Geocoding API
        final geocodingResults = await _searchGeocodingAPIUniversal(query);
        allResults.addAll(geocodingResults);
        
        // Strategy 4: Split query into parts (e.g., "2 silver kettle" -> "silver kettle")
        if (query.split(' ').length > 2) {
          final partialResults =
              await _searchPartialQuery(query, currentLocation);
          allResults.addAll(partialResults);
        }
        
        // Strategy 5: Search with keywords only
        final keywordResults = await _searchByKeywords(query, currentLocation);
        allResults.addAll(keywordResults);

      // Duplicate'ları kaldır
      final uniqueResults = <LocationModel>[];
      final seenPlaceIds = <String>{};
      final seenCoordinates = <String>{};

      for (final result in allResults) {
        final placeId = result.placeId;
        final coordinateKey =
            '${result.latitude.toStringAsFixed(4)}_${result.longitude.toStringAsFixed(4)}';

        if (!seenPlaceIds.contains(placeId) &&
            !seenCoordinates.contains(coordinateKey)) {
          seenPlaceIds.add(placeId);
          seenCoordinates.add(coordinateKey);
          uniqueResults.add(result);
        }
      }

      developer.log('✅ Total ${uniqueResults.length} unique results found',
          name: _tag);

      // Sonuçları relevance'e göre sırala
      uniqueResults.sort((a, b) {
        // Query ile tam eşleşenleri önce getir
        final aExactMatch =
            a.placeName.toLowerCase().contains(query.toLowerCase()) ||
                a.address.toLowerCase().contains(query.toLowerCase());
        final bExactMatch =
            b.placeName.toLowerCase().contains(query.toLowerCase()) ||
                b.address.toLowerCase().contains(query.toLowerCase());

        if (aExactMatch && !bExactMatch) return -1;
        if (!aExactMatch && bExactMatch) return 1;

        // Kullanıcının konumuna yakın olanları önce getir
        if (currentLocation != null) {
          final aDistance = _calculateDistance(currentLocation.latitude,
              currentLocation.longitude, a.latitude, a.longitude);
          final bDistance = _calculateDistance(currentLocation.latitude,
              currentLocation.longitude, b.latitude, b.longitude);

          if (aDistance < bDistance) return -1;
          if (aDistance > bDistance) return 1;
        }

        return 0;
      });

      return uniqueResults;
    } catch (e) {
      developer.log('💥 Location search error: $e', name: _tag);
      return [];
    }
  }

  /// Universal Places API arama (region kısıtlaması olmadan)
  static Future<List<LocationModel>> _searchPlacesAPIUniversal(
      String query, LocationModel? currentLocation) async {
    try {
      // Region kısıtlaması olmadan arama yap
      final String url = '$_placesBaseUrl/textsearch/json'
          '?query=${Uri.encodeComponent(query)}'
          '&key=${Constants.googleMapsApiKey}'
          '&language=en' // Universal dil
          '&maxresults=20';

      developer.log('🌐 Universal Places API call: $url', name: _tag);

      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      developer.log(
          '📡 Universal Places API Response Status: ${response.statusCode}',
          name: _tag);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('📊 Universal Places API Response: ${json.encode(data)}',
            name: _tag);

        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          final List results = data['results'] ?? [];
          developer.log(
              '✅ Universal Places API: ${results.length} results found',
              name: _tag);

          return results.map<LocationModel>((place) {
            final geometry = place['geometry']?['location'];
            return LocationModel(
              placeName: place['name'] ?? '',
              address: place['formatted_address'] ?? '',
              latitude: geometry?['lat']?.toDouble() ?? 0.0,
              longitude: geometry?['lng']?.toDouble() ?? 0.0,
              placeId: place['place_id'] ?? '',
            );
          }).toList();
        } else {
          developer.log(
              '⚠️ Universal Places API Status: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}',
              name: _tag);
          return [];
        }
      } else {
        developer.log(
            '❌ Universal Places API HTTP Error: ${response.statusCode}',
            name: _tag);
        return [];
      }
    } catch (e) {
      developer.log('💥 Universal Places API hatası: $e', name: _tag);
      return [];
    }
  }

  /// Kullanıcının konumuna yakın yerlerde arama
  static Future<List<LocationModel>> _searchNearbyPlaces(
      String query, LocationModel currentLocation) async {
    try {
      final String url = '$_placesBaseUrl/nearbysearch/json'
          '?location=${currentLocation.latitude},${currentLocation.longitude}'
          '&radius=50000' // 50km yarıçap
          '&keyword=${Uri.encodeComponent(query)}'
          '&key=${Constants.googleMapsApiKey}'
          '&maxresults=20';

      developer.log('🌐 Nearby Search API çağrısı: $url', name: _tag);

      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('📊 Nearby Search Response: ${json.encode(data)}',
            name: _tag);

        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          final List results = data['results'] ?? [];
          developer.log('✅ Nearby Search: ${results.length} results found',
              name: _tag);

          return results.map<LocationModel>((place) {
            final geometry = place['geometry']?['location'];
            return LocationModel(
              placeName: place['name'] ?? '',
              address: place['formatted_address'] ?? '',
              latitude: geometry?['lat']?.toDouble() ?? 0.0,
              longitude: geometry?['lng']?.toDouble() ?? 0.0,
              placeId: place['place_id'] ?? '',
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      developer.log('💥 Nearby Search hatası: $e', name: _tag);
      return [];
    }
  }

  /// Universal Geocoding API arama
  static Future<List<LocationModel>> _searchGeocodingAPIUniversal(
      String query) async {
    try {
      final String url = '$_geocodingBaseUrl/json'
          '?address=${Uri.encodeComponent(query)}'
          '?key=${Constants.googleMapsApiKey}'
          '&language=en'; // Universal dil

      developer.log('🌐 Universal Geocoding API çağrısı: $url', name: _tag);

      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log(
            '📊 Universal Geocoding API Response: ${json.encode(data)}',
            name: _tag);

        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          final List results = data['results'] ?? [];
          developer.log(
              '✅ Universal Geocoding API: ${results.length} results found',
              name: _tag);

          return results.map<LocationModel>((result) {
            final geometry = result['geometry']?['location'];
            final components = result['address_components'] ?? [];

            String placeName = '';
            for (final component in components) {
              if (component['types']?.contains('locality') == true ||
                  component['types']?.contains('sublocality') == true) {
                placeName = component['long_name'] ?? '';
                break;
              }
            }

            if (placeName.isEmpty) {
              placeName = result['formatted_address'] ?? 'Unknown Location';
            }

            return LocationModel(
              placeName: placeName,
              address: result['formatted_address'] ?? '',
              latitude: geometry?['lat']?.toDouble() ?? 0.0,
              longitude: geometry?['lng']?.toDouble() ?? 0.0,
              placeId: result['place_id'] ?? '',
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      developer.log('💥 Universal Geocoding API hatası: $e', name: _tag);
      return [];
    }
  }

  /// Query'yi parçalara bölerek arama
  static Future<List<LocationModel>> _searchPartialQuery(
      String query, LocationModel? currentLocation) async {
    try {
      final words = query.split(' ').where((word) => word.length > 2).toList();
      if (words.isEmpty) return [];

      // En uzun 2 kelimeyi al
      words.sort((a, b) => b.length.compareTo(a.length));
      final partialQuery = words.take(2).join(' ');

      developer.log('🔍 Partial query search: "$partialQuery"', name: _tag);

      final results =
          await _searchPlacesAPIUniversal(partialQuery, currentLocation);
      developer.log('✅ Partial query: ${results.length} results found',
          name: _tag);

      return results;
    } catch (e) {
      developer.log('💥 Partial query hatası: $e', name: _tag);
      return [];
    }
  }

  /// Sadece anahtar kelimelerle arama
  static Future<List<LocationModel>> _searchByKeywords(
      String query, LocationModel? currentLocation) async {
    try {
      // Sayıları ve kısa kelimeleri çıkar
      final keywords = query
          .split(' ')
          .where((word) => word.length > 3 && !RegExp(r'^\d+$').hasMatch(word))
          .toList();

      if (keywords.isEmpty) return [];

      final keywordQuery = keywords.join(' ');
      developer.log('🔍 Keyword search: "$keywordQuery"', name: _tag);

      final results =
          await _searchPlacesAPIUniversal(keywordQuery, currentLocation);
      developer.log('✅ Keyword search: ${results.length} results found',
          name: _tag);

      return results;
    } catch (e) {
      developer.log('💥 Keyword search error: $e', name: _tag);
      return [];
    }
  }

  /// İki koordinat arasındaki mesafeyi hesapla (km)
  static double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(_toRadians(lat1)) *
            math.sin(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Get place details by place ID
  static Future<LocationModel?> getPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return null;

    try {
      developer.log('🔍 Getting place details: $placeId', name: _tag);

      final String url = '$_placesBaseUrl/details/json'
          '?place_id=$placeId'
          '&key=${Constants.googleMapsApiKey}'
          '&language=en';

      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('📊 Place Details Response: ${json.encode(data)}',
            name: _tag);

        if (data['status'] == 'OK') {
          final result = data['result'];

          if (result != null) {
            final geometry = result['geometry']?['location'];
            final location = LocationModel(
              placeName: result['name'] ?? '',
              address: result['formatted_address'] ?? '',
              latitude: geometry?['lat']?.toDouble() ?? 0.0,
              longitude: geometry?['lng']?.toDouble() ?? 0.0,
              placeId: placeId,
            );

            developer.log('✅ Place details obtained: ${location.placeName}',
                name: _tag);
            return location;
          }
        } else {
          developer.log('⚠️ Place Details API Status: ${data['status']}',
              name: _tag);
        }
      } else {
        developer.log('❌ Place Details HTTP Error: ${response.statusCode}',
            name: _tag);
      }

      return null;
    } catch (e) {
      developer.log('💥 Place details hatası: $e', name: _tag);
      return null;
    }
  }

  /// Get address from coordinates
  static Future<LocationModel?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      developer.log(
          '📍 Getting address from coordinates: $latitude, $longitude',
          name: _tag);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            '${place.street ?? ''} ${place.subLocality ?? ''} ${place.locality ?? ''} ${place.country ?? ''}'
                .trim();

        final location = LocationModel(
          placeName: place.locality ?? 'Selected Location',
          address: address,
          latitude: latitude,
          longitude: longitude,
          placeId: 'coord_${latitude}_$longitude',
        );

        developer.log('✅ Address found: ${location.placeName}', name: _tag);
        return location;
      }

      final location = LocationModel(
        placeName: 'Selected Location',
        address: 'Unknown Address',
        latitude: latitude,
        longitude: longitude,
        placeId: 'coord_${latitude}_$longitude',
      );

      developer.log('📍 Default location created', name: _tag);
      return location;
    } catch (e) {
      developer.log('💥 Error getting address from coordinates: $e',
          name: _tag);
      return null;
    }
  }
}
