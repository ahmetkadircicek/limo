import 'dart:convert';
import 'dart:io';

import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/core/services/encryption_service.dart';
import 'package:limo/core/services/environment_service.dart';
import 'package:limo/core/utils/logger_service.dart';

/// HTTP API client with encryption support
class ApiClient {
  static const String _tag = 'API_CLIENT';
  static const String _contentType = 'application/json';

  /// Make POST request (always encrypted)
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> data,
    Duration? timeout,
    AppStateProvider? appState,
  }) async {
    try {
      // Log both original and encrypted data
      LoggerService.info(
        '[POST] $endpoint\n'
        'Original Payload: ${jsonEncode(data)}\n'
        'Payload Length: ${jsonEncode(data).length} characters',
        tag: _tag,
      );

      // Ensure no double slashes in URL
      final baseUrl =
          EnvironmentService.apiBaseUrl.endsWith('/')
              ? EnvironmentService.apiBaseUrl.substring(
                0,
                EnvironmentService.apiBaseUrl.length - 1,
              )
              : EnvironmentService.apiBaseUrl;
      final cleanEndpoint =
          endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

      final url = Uri.parse('$baseUrl/$cleanEndpoint');
      final encryptedData = EncryptionService.encrypt(jsonEncode(data));

      // Log encrypted data details
      LoggerService.info(
        'Encrypted Data: ${encryptedData.substring(0, 50)}...\n'
        'Encrypted Length: ${encryptedData.length} characters\n'
        'Encryption Ratio: ${(encryptedData.length / jsonEncode(data).length).toStringAsFixed(2)}x',
        tag: _tag,
      );

      // Create the payload format expected by backend
      final backendPayload = {'encryptedData': encryptedData};

      LoggerService.info(
        'Backend Payload: ${jsonEncode(backendPayload)}\n'
        'Backend Payload Length: ${jsonEncode(backendPayload).length} characters',
        tag: _tag,
      );

      final request = await HttpClient().postUrl(url);
      request.headers.contentType = ContentType.parse(_contentType);
      request.headers.set('Accept', _contentType);

      // Add authentication header if available
      if (appState != null && appState.currentUser?.accessToken != null) {
        final token = appState.currentUser!.accessToken!;
        request.headers.set('Authorization', 'Bearer $token');
      }

      request.write(jsonEncode(backendPayload));

      final response = await request.close().timeout(
        timeout ?? Duration(milliseconds: EnvironmentService.apiTimeout),
      );

      final responseBody = await response.transform(utf8.decoder).join();

      // Log response details
      LoggerService.info(
        'Response: $responseBody\n'
        'Status: ${response.statusCode}',
        tag: _tag,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the JSON response to get the encryptedData field
        final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
        final encryptedData = jsonResponse['encryptedData'] as String;

        // Decrypt the encryptedData field
        final decryptedResponse = EncryptionService.decrypt(encryptedData);
        final finalResponse =
            jsonDecode(decryptedResponse) as Map<String, dynamic>;

        LoggerService.success('Request successful', tag: _tag);
        return finalResponse;
      } else {
        LoggerService.error(
          'Request failed with status: ${response.statusCode}',
          tag: _tag,
        );
        throw HttpException('HTTP ${response.statusCode}: $responseBody');
      }
    } catch (e) {
      LoggerService.error(
        'Error making encrypted POST request: $e',
        error: e,
        tag: _tag,
      );
      rethrow;
    }
  }
}
