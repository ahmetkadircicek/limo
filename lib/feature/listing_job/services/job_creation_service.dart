import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:path_provider/path_provider.dart';

class JobCreationService {
  static const String _tag = 'JobCreationService';
  static const String _fileName = 'jobs_data.json';

  // Disable dummy data loading for production
  static const bool _enableDummyData = false;

  /// Create job with validation and service call
  static Future<Map<String, dynamic>> createJob(JobModel job) async {
    try {
      // Job creation request starting
      developer.log('🔄 Job creation request starting...', name: _tag);

      // Convert request to JSON format
      final requestJson = job.toJson();

      // Log request body
      _logJsonData('📤 REQUEST BODY', requestJson);

      // Simulate API endpoint
      final endpoint = '/api/jobs';
      developer.log('🌐 API Endpoint: $endpoint', name: _tag);

      // Simulate HTTP method
      developer.log('📡 HTTP Method: POST', name: _tag);

      // Simulate headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_generateMockToken()}',
        'Accept': 'application/json',
      };
      _logJsonData('📋 REQUEST HEADERS', headers);

      // Simulate response delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Save job to file if dummy data is enabled
      if (_enableDummyData) {
        await _saveJobToFile(job);
      }

      // Simulate successful response
      final responseData = {
        'success': true,
        'message': 'Job created successfully',
        'data': {
          'jobId': job.id,
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
          'estimatedResponseTime': '24-48 hours',
        },
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Log response
      _logJsonData('📥 RESPONSE BODY', responseData);

      // Simulate HTTP status code
      developer.log('✅ HTTP Status: 201 Created', name: _tag);

      // Job creation success message
      developer.log('🎉 Job created successfully!', name: _tag);
      developer.log('🆔 Job ID: ${job.id}', name: _tag);
      developer.log('🏢 Company: ${job.companyName}', name: _tag);
      developer.log('📍 Location: ${job.fromProvince} → ${job.toProvince}',
          name: _tag);
      developer.log(
          '🚛 Vehicle Requirements: ${job.vehicleRequirements.length} items',
          name: _tag);

      return responseData;
    } catch (error, stackTrace) {
      // Simulate error response
      final errorResponse = {
        'success': false,
        'error': {
          'code': 'JOB_CREATION_FAILED',
          'message': 'An error occurred while creating the job',
          'details': error.toString(),
        },
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Log error response
      _logJsonData('❌ ERROR RESPONSE', errorResponse);

      // Log error details
      developer.log('💥 Job creation error: $error', name: _tag);
      developer.log('📚 Stack trace: $stackTrace', name: _tag);

      return errorResponse;
    }
  }

  /// Save job to JSON file for local storage
  static Future<void> _saveJobToFile(JobModel job) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');

      List<Map<String, dynamic>> existingJobs = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          existingJobs = List<Map<String, dynamic>>.from(json.decode(content));
        }
      }

      existingJobs.add(job.toJson());

      await file.writeAsString(json.encode(existingJobs));
      developer.log('💾 Job saved to file: ${file.path}', name: _tag);
    } catch (error) {
      developer.log('❌ Error saving job to file: $error', name: _tag);
    }
  }

  /// Log JSON data in a formatted way
  static void _logJsonData(String title, dynamic data) {
    if (!_enableDummyData) return;

    try {
      final jsonString = json.encode(data);
      developer.log('$title:\n$jsonString', name: _tag);
    } catch (error) {
      developer.log('❌ Error logging JSON data: $error', name: _tag);
    }
  }

  /// Generate mock authentication token
  static String _generateMockToken() {
    if (!_enableDummyData) return 'PRODUCTION_TOKEN';

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 10000;
    return 'mock_token_${timestamp}_$random';
  }

  /// Log debug information about created job
  static void logDebugInfo(JobModel job) {
    if (!_enableDummyData) return;

    developer.log('🔍 Job Debug Info:', name: _tag);
    developer.log('  ID: ${job.id}', name: _tag);
    developer.log('  Company: ${job.companyName}', name: _tag);
    developer.log('  Contact: ${job.contactInfo}', name: _tag);
    developer.log('  From: ${job.fromProvince}', name: _tag);
    developer.log('  To: ${job.toProvince}', name: _tag);
    developer.log('  Type: ${job.jobType}', name: _tag);
    developer.log('  Requirements: ${job.vehicleRequirements.length}',
        name: _tag);

    if (job.description != null) {
      developer.log('  Description: ${job.description}', name: _tag);
    }
  }
}
