import 'dart:convert';
import 'package:flutter/services.dart';

/// Service for loading JSON data from assets
/// This service will be replaced with API calls in production
class JsonDataService {
  static const String _basePath = 'assets/json/';

  /// Load profile data from JSON
  static Future<Map<String, dynamic>> loadProfileData() async {
    try {
      final String response = await rootBundle.loadString('${_basePath}profile_data.json');
      return json.decode(response);
    } catch (e) {
      print('Error loading profile data: $e');
      return {};
    }
  }

  /// Load jobs data from JSON
  static Future<Map<String, dynamic>> loadJobsData() async {
    try {
      final String response = await rootBundle.loadString('${_basePath}jobs_data.json');
      return json.decode(response);
    } catch (e) {
      print('Error loading jobs data: $e');
      return {};
    }
  }

  /// Load vehicle data from JSON
  static Future<Map<String, dynamic>> loadVehicleData() async {
    try {
      final String response = await rootBundle.loadString('${_basePath}vehicle_data.json');
      return json.decode(response);
    } catch (e) {
      print('Error loading vehicle data: $e');
      return {};
    }
  }

  /// Load vehicle options from JSON
  static Future<Map<String, dynamic>> loadVehicleOptions() async {
    try {
      final String response = await rootBundle.loadString('${_basePath}vehicle_options.json');
      return json.decode(response);
    } catch (e) {
      print('Error loading vehicle options: $e');
      return {};
    }
  }

  /// Load vehicle requirements data from JSON
  static Future<Map<String, dynamic>> loadVehicleRequirementsData() async {
    try {
      final String response = await rootBundle.loadString('${_basePath}vehicle_requirements_data.json');
      return json.decode(response);
    } catch (e) {
      print('Error loading vehicle requirements data: $e');
      return {};
    }
  }

  /// Load language data from JSON
  static Future<Map<String, dynamic>> loadLanguageData() async {
    try {
      final String response = await rootBundle.loadString('${_basePath}language_data.json');
      return json.decode(response);
    } catch (e) {
      print('Error loading language data: $e');
      return {};
    }
  }

  /// Generic method to load any JSON file
  static Future<Map<String, dynamic>> loadJsonData(String fileName) async {
    try {
      final String response = await rootBundle.loadString('$_basePath$fileName');
      return json.decode(response);
    } catch (e) {
      print('Error loading $fileName: $e');
      return {};
    }
  }
}
