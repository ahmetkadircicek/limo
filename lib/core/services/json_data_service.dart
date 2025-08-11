import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service for loading JSON data from assets
/// This service will be replaced with API calls in production
class JsonDataService {
  static const String _basePath = 'assets/json/';

  /// Load profile data from JSON
  static Future<Map<String, dynamic>> loadProfileData() async {
    try {
      final String response =
          await rootBundle.loadString('${_basePath}profile_data.json');
      return json.decode(response);
    } catch (e) {
      debugPrint('Error loading profile data: $e');
      return {};
    }
  }

  /// Load jobs data from JSON
  static Future<List<Map<String, dynamic>>> loadJobsData() async {
    try {
      final String response =
          await rootBundle.loadString('${_basePath}jobs_data.json');
      final decodedData = json.decode(response);

      // Handle both old format (with "jobs" key) and new format (direct array)
      if (decodedData is Map<String, dynamic> &&
          decodedData.containsKey('jobs')) {
        return List<Map<String, dynamic>>.from(decodedData['jobs']);
      } else if (decodedData is List) {
        return List<Map<String, dynamic>>.from(decodedData);
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error loading jobs data: $e');
      return [];
    }
  }

  /// Load vehicle data from JSON
  static Future<Map<String, dynamic>> loadVehicleData() async {
    try {
      // First check if the asset exists in the manifest
      try {
        final manifestContent =
            await rootBundle.loadString('AssetManifest.json');
        final manifest = json.decode(manifestContent) as Map<String, dynamic>;
        final availableAssets =
            manifest.keys.where((key) => key.contains('vehicle_data')).toList();

        if (availableAssets.isEmpty) {
          return _getFallbackVehicleData();
        }
      } catch (manifestError) {
        // Continue with loading attempt
      }

      final String response =
          await rootBundle.loadString('${_basePath}vehicle_data.json');

      // Check if response is empty or whitespace
      if (response.trim().isEmpty) {
        return _getFallbackVehicleData();
      }

      final decodedData = json.decode(response);

      // Validate the decoded data structure
      if (decodedData is! Map<String, dynamic>) {
        return _getFallbackVehicleData();
      }

      if (!decodedData.containsKey('availableVehicles')) {
        return _getFallbackVehicleData();
      }

      return decodedData;
    } catch (e) {
      debugPrint('JsonDataService: Error loading vehicle data: $e');
      debugPrint('JsonDataService: Error type: ${e.runtimeType}');

      // Try to check if file exists
      try {
        final manifestContent =
            await rootBundle.loadString('AssetManifest.json');
        final manifest = json.decode(manifestContent) as Map<String, dynamic>;
        debugPrint(
            'JsonDataService: Available assets: ${manifest.keys.where((key) => key.contains('vehicle_data')).toList()}');
      } catch (manifestError) {
        debugPrint(
            'JsonDataService: Could not load asset manifest: $manifestError');
      }

      debugPrint(
          'JsonDataService: Using fallback vehicle data due to loading error');
      return _getFallbackVehicleData();
    }
  }

  /// Get fallback vehicle data when asset loading fails
  static Map<String, dynamic> _getFallbackVehicleData() {
    debugPrint('JsonDataService: Providing fallback vehicle data');
    return {
      'availableVehicles': [
        {
          'licencePlate': '34 ABC 123',
          'brand': 'Mercedes',
          'model': 'Sprinter',
          'year': 2022,
          'capacity': 10,
          'vehicleType': 'Van',
          'interiorColor': 'Black',
          'exteriorColor': 'White',
          'category': 'standardSuv',
          'hourlyRate': 120.0,
          'pricePerMile': 2.2,
        },
        {
          'licencePlate': '34 DEF 456',
          'brand': 'BMW',
          'model': 'X5',
          'year': 2021,
          'capacity': 7,
          'vehicleType': 'SUV',
          'interiorColor': 'Beige',
          'exteriorColor': 'Blue',
          'category': 'premiumSuv',
          'hourlyRate': 180.0,
          'pricePerMile': 2.8,
        },
      ]
    };
  }

  /// Load vehicle options from JSON
  static Future<Map<String, dynamic>> loadVehicleOptions() async {
    try {
      final String response =
          await rootBundle.loadString('${_basePath}vehicle_options.json');
      return json.decode(response);
    } catch (e) {
      debugPrint('Error loading vehicle options: $e');
      return {};
    }
  }

  /// Load vehicle requirements data from JSON
  static Future<Map<String, dynamic>> loadVehicleRequirementsData() async {
    try {
      final String response = await rootBundle
          .loadString('${_basePath}vehicle_requirements_data.json');
      return json.decode(response);
    } catch (e) {
      debugPrint('Error loading vehicle requirements data: $e');
      return {};
    }
  }

  /// Load language data from JSON
  static Future<Map<String, dynamic>> loadLanguageData() async {
    return await loadJsonData('language_data.json');
  }

  /// Load user data from JSON
  static Future<Map<String, dynamic>> loadUserData() async {
    return await loadJsonData('user_data.json');
  }

  /// Load specific user by email
  static Future<Map<String, dynamic>?> loadUserByEmail(String email) async {
    try {
      final userData = await loadUserData();
      final users = userData['users'] as List<dynamic>;

      for (final user in users) {
        if (user['email'] == email) {
          return user as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error loading user by email: $e');
      return null;
    }
  }

  /// Load all users
  static Future<List<Map<String, dynamic>>> loadAllUsers() async {
    try {
      final userData = await loadUserData();
      final users = userData['users'] as List<dynamic>;
      return users.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error loading all users: $e');
      return [];
    }
  }

  /// Generic method to load any JSON file
  static Future<Map<String, dynamic>> loadJsonData(String fileName) async {
    try {
      final String response =
          await rootBundle.loadString('$_basePath$fileName');
      return json.decode(response);
    } catch (e) {
      debugPrint('Error loading $fileName: $e');
      return {};
    }
  }
}
