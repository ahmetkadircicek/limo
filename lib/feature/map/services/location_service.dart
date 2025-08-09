import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:soforvarcom/core/constants/constants.dart';
import 'package:soforvarcom/feature/map/models/location_model.dart';

class LocationService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';

  /// Get current location of the device
  static Future<LocationModel?> getCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

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

        return LocationModel(
          placeName: place.locality ?? 'Current Location',
          address: address,
          latitude: position.latitude,
          longitude: position.longitude,
          placeId: '',
        );
      }

      return LocationModel(
        placeName: 'Current Location',
        address: 'Unknown Address',
        latitude: position.latitude,
        longitude: position.longitude,
        placeId: '',
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Search places using Google Places API
  static Future<List<LocationModel>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      final String url =
          '$_baseUrl/place/textsearch/json?query=$query&key=${Constants.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'] ?? [];

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

      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  /// Get place details by place ID
  static Future<LocationModel?> getPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return null;

    try {
      final String url =
          '$_baseUrl/place/details/json?place_id=$placeId&key=${Constants.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];

        if (result != null) {
          final geometry = result['geometry']?['location'];
          return LocationModel(
            placeName: result['name'] ?? '',
            address: result['formatted_address'] ?? '',
            latitude: geometry?['lat']?.toDouble() ?? 0.0,
            longitude: geometry?['lng']?.toDouble() ?? 0.0,
            placeId: placeId,
          );
        }
      }

      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }

  /// Get address from coordinates
  static Future<LocationModel?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            '${place.street ?? ''} ${place.subLocality ?? ''} ${place.locality ?? ''} ${place.country ?? ''}'
                .trim();

        return LocationModel(
          placeName: place.locality ?? 'Selected Location',
          address: address,
          latitude: latitude,
          longitude: longitude,
          placeId: '',
        );
      }

      return LocationModel(
        placeName: 'Selected Location',
        address: 'Unknown Address',
        latitude: latitude,
        longitude: longitude,
        placeId: '',
      );
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return null;
    }
  }
}
