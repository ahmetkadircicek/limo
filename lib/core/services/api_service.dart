import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/core/services/encryption_service.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/shared/constants/app_constants.dart';
import 'package:limo/shared/models/oauth_model.dart';
import 'package:limo/shared/models/user_model.dart';
import 'package:provider/provider.dart';

class ApiService {
  static const String _tag = 'API_SERVICE';
  static const String _contentType = 'application/json';

  /// Generic POST request - returns dynamic (List or Map)
  static Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> data,
    Duration? timeout,
    String? accessToken,
  }) async {
    try {
      final url = Uri.parse(AppConstants.apiBaseUrl + endpoint);

      // Log endpoint and token info
      LoggerService.info('[POST] $endpoint', tag: _tag);

      // Request data'yı logla
      LoggerService.info('Request data: $data', tag: _tag);

      if (accessToken != null && accessToken.isNotEmpty) {
        LoggerService.info(
          'Token: ${accessToken.substring(0, 10)}...',
          tag: _tag,
        );
      }

      final payload = jsonEncode({
        'encryptedData': EncryptionService.encryptJson(data),
      });

      // Encrypted payload'ı da logla
      LoggerService.info(
        'Encrypted payload length: ${payload.length}',
        tag: _tag,
      );

      final request = await HttpClient().postUrl(url);
      request.headers.contentType = ContentType.parse(_contentType);
      request.headers.set('Accept', _contentType);

      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers.set('Authorization', 'Bearer $accessToken');
      }

      request.write(payload);

      final response = await request.close().timeout(
        timeout ?? Duration(milliseconds: 10000),
      );

      final body = await response.transform(utf8.decoder).join();
      LoggerService.info('Response (${response.statusCode})', tag: _tag);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Response body'yi parse et
        final responseData = jsonDecode(body);

        // Eğer encrypted JSON ise, decrypt et
        if (responseData is Map<String, dynamic>) {
          final encryptedData = responseData['encryptedData'] as String?;
          if (encryptedData != null) {
            final decrypted = EncryptionService.decrypt(encryptedData);
            final decryptedData = jsonDecode(decrypted);

            // Decrypted data format'ını logla
            LoggerService.info('=== DECRYPTED DATA FORMAT ===', tag: _tag);
            LoggerService.info('Type: ${decryptedData.runtimeType}', tag: _tag);
            LoggerService.info('Content: $decryptedData', tag: _tag);
            if (decryptedData is List) {
              LoggerService.info(
                'List length: ${decryptedData.length}',
                tag: _tag,
              );
            } else if (decryptedData is Map) {
              LoggerService.info(
                'Map keys: ${decryptedData.keys.toList()}',
                tag: _tag,
              );
            }

            // Decrypted data'yı olduğu gibi döndür (List veya Map)
            return decryptedData;
          }
        }

        // Direkt response'u döndür (List veya Map)
        LoggerService.info(
          'Direct response format: ${responseData.runtimeType}',
          tag: _tag,
        );
        return responseData;
      } else {
        throw Exception('HTTP ${response.statusCode}: $body');
      }
    } catch (e, st) {
      LoggerService.error('API error: $e', error: e, tag: _tag);
      LoggerService.error('StackTrace: $st', tag: _tag);
      rethrow;
    }
  }

  /// Send OAuth data to backend and update UserProvider
  static Future<UserModel?> sendOAuthData({
    required OAuthModel oauthUser,
    required BuildContext context,
  }) async {
    try {
      final data = oauthUser.toJson();

      final response = await post('/login', data: data);

      // Response Map olmalı (UserModel için)
      if (response is! Map<String, dynamic>) {
        throw Exception(
          'Expected Map response for login, got: ${response.runtimeType}',
        );
      }

      final user = UserModel.fromJson(response);

      if (!context.mounted) return null;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(user);

      LoggerService.success(
        'UserProvider updated from OAuth response',
        tag: _tag,
      );

      return user;
    } catch (e) {
      LoggerService.error('Failed to send OAuth data: $e', tag: _tag);
      return null;
    }
  }
}
