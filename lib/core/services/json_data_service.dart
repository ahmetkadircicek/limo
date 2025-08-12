import 'package:flutter/foundation.dart';
import 'package:limo/feature/job_list/model/job_model.dart';

/// Service for loading data - mock data completely disabled
/// This service will be replaced with API calls in production
class JsonDataService {
  /// Load profile data - mock data disabled
  static Future<Map<String, dynamic>> loadProfileData() async {
    debugPrint('JsonDataService: Mock data loading disabled');
    return {};
  }

  /// Load jobs data - mock data completely disabled
  static Future<List<Map<String, dynamic>>> loadJobsData() async {
    debugPrint('JsonDataService: Mock data loading completely disabled');
    return [];
  }

  /// Get all jobs as JobModel objects - mock data disabled
  static Future<List<JobModel>> getAllJobs() async {
    debugPrint('JsonDataService: Mock data loading completely disabled');
    return [];
  }

  /// Load vehicle data - mock data completely disabled
  static Future<Map<String, dynamic>> loadVehicleData() async {
    debugPrint('JsonDataService: Mock data loading completely disabled');
    return {'availableVehicles': []};
  }

  /// Load user data - mock data completely disabled
  static Future<Map<String, dynamic>> loadUserData() async {
    debugPrint('JsonDataService: Mock data loading completely disabled');
    return {};
  }

  /// Load language data - mock data completely disabled
  static Future<Map<String, dynamic>> loadLanguageData() async {
    debugPrint('JsonDataService: Mock data loading completely disabled');
    return {};
  }

  /// Load vehicle options data - mock data completely disabled
  static Future<Map<String, dynamic>> loadVehicleOptionsData() async {
    debugPrint('JsonDataService: Mock data loading completely disabled');
    return {};
  }

  /// Load vehicle requirements data - mock data completely disabled
  static Future<Map<String, dynamic>> loadVehicleRequirementsData() async {
    debugPrint('JsonDataService: Mock data loading completely disabled');
    return {};
  }

  /// Save jobs data to local file - mock data disabled
  static Future<bool> saveJobsData(List<Map<String, dynamic>> jobs) async {
    debugPrint('JsonDataService: Mock data saving disabled');
    return false;
  }

  /// Save job data to local file - mock data disabled
  static Future<bool> saveJobData(Map<String, dynamic> jobData) async {
    debugPrint('JsonDataService: Mock data saving disabled');
    return false;
  }

  /// Delete job data from local file - mock data disabled
  static Future<bool> deleteJobData(String jobId) async {
    debugPrint('JsonDataService: Mock data deletion disabled');
    return false;
  }

  /// Update job data in local file - mock data disabled
  static Future<bool> updateJobData(
      String jobId, Map<String, dynamic> updatedData) async {
    debugPrint('JsonDataService: Mock data updating disabled');
    return false;
  }

  /// Get jobs as assets JSON - mock data disabled
  static Future<String> getAllJobsAsAssetsJson() async {
    debugPrint('JsonDataService: Mock data export disabled');
    return '{"jobs": []}';
  }

  /// Check if mock data is enabled - always returns false
  static bool get isMockDataEnabled => false;

  /// Enable mock data - no-op (always disabled)
  static void enableMockData() {
    debugPrint(
        'JsonDataService: Mock data cannot be enabled - completely disabled');
  }

  /// Disable mock data - no-op (always disabled)
  static void disableMockData() {
    debugPrint('JsonDataService: Mock data is already completely disabled');
  }
}
