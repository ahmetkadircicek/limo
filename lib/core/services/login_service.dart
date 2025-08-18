import 'dart:convert';

import 'package:http/http.dart' as http;

import 'logger_service.dart';

/// Login Service for provider-based authentication
class LoginService {
  static LoginService? _instance;
  static LoginService get instance => _instance ??= LoginService._();

  LoginService._();

  // API endpoint
  static const String _loginEndpoint = 'https://api.sevkiyatvar.com/login';

  /// Format date time to MM-DD-YYYY HH24:MI:SS format
  static String _formatDateTime(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    return '$month-$day-$year $hour:$minute:$second';
  }

  /// Login with Google provider credentials
  ///
  /// [providerUserId] - User ID from Google
  /// [email] - User's email address from Google
  /// [userName] - User's display name from Google
  static Future<LoginResponse> loginWithGoogle({
    required String providerUserId,
    required String email,
    required String userName,
  }) async {
    return await loginWithProvider(
      provider: 'google',
      providerUserId: providerUserId,
      email: email,
      userName: userName,
    );
  }

  /// Login with Apple provider credentials
  ///
  /// [providerUserId] - User ID from Apple
  /// [email] - User's email address from Apple
  /// [userName] - User's display name from Apple
  static Future<LoginResponse> loginWithApple({
    required String providerUserId,
    required String email,
    required String userName,
  }) async {
    return await loginWithProvider(
      provider: 'apple',
      providerUserId: providerUserId,
      email: email,
      userName: userName,
    );
  }

  /// Login with provider credentials
  ///
  /// [provider] - 'google' or 'apple'
  /// [providerUserId] - User ID from the provider
  /// [email] - User's email address
  /// [userName] - User's display name
  static Future<LoginResponse> loginWithProvider({
    required String provider,
    required String providerUserId,
    required String email,
    required String userName,
  }) async {
    try {
      LoggerService.info(
        'Attempting login with $provider',
        tag: 'LOGIN_SERVICE',
      );
      LoggerService.debug('Email: $email', tag: 'LOGIN_SERVICE');
      LoggerService.debug('User ID: $providerUserId', tag: 'LOGIN_SERVICE');
      LoggerService.debug('User Name: $userName', tag: 'LOGIN_SERVICE');

      // Prepare request payload
      final payload = {
        'provider': provider,
        'provider_user_id': providerUserId,
        'email': email,
        'user_name': userName,
        'is_active': true,
        'last_login': _formatDateTime(DateTime.now()),
      };

      LoggerService.info(
        'Sending request to: $_loginEndpoint',
        tag: 'LOGIN_SERVICE',
      );
      LoggerService.debug(
        'Request payload: ${json.encode(payload)}',
        tag: 'LOGIN_SERVICE',
      );

      // Make API call with timing
      final requestStartTime = DateTime.now();
      LoggerService.info('Starting HTTP request...', tag: 'LOGIN_SERVICE');

      final response = await http
          .post(
            Uri.parse(_loginEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(payload),
          )
          .timeout(
            const Duration(seconds: 15), // Reduced from 30 to 15 seconds
            onTimeout: () {
              throw LoginException(
                'Request timeout',
                0,
                'Request timed out after 15 seconds',
              );
            },
          );

      final requestDuration = DateTime.now().difference(requestStartTime);
      LoggerService.info(
        'HTTP request completed in ${requestDuration.inMilliseconds}ms',
        tag: 'LOGIN_SERVICE',
      );

      LoggerService.info(
        'Response received - Status: ${response.statusCode}',
        tag: 'LOGIN_SERVICE',
      );

      // Log response headers
      LoggerService.debug(
        'Response headers: ${response.headers}',
        tag: 'LOGIN_SERVICE',
      );

      // Log response body
      if (response.body.isNotEmpty) {
        try {
          final responseData = json.decode(response.body);
          LoggerService.debug(
            'Response body (parsed): ${json.encode(responseData)}',
            tag: 'LOGIN_SERVICE',
          );
        } catch (parseError) {
          LoggerService.warning(
            'Could not parse response body as JSON: ${response.body}',
            tag: 'LOGIN_SERVICE',
          );
          LoggerService.debug(
            'Raw response body: ${response.body}',
            tag: 'LOGIN_SERVICE',
          );
        }
      } else {
        LoggerService.warning('Response body is empty', tag: 'LOGIN_SERVICE');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);

        if (loginResponse.success) {
          LoggerService.success(
            'Login successful with $provider (Status: ${response.statusCode})',
            tag: 'LOGIN_SERVICE',
          );

          // Log successful response details
          if (loginResponse.token != null) {
            final tokenPreview =
                loginResponse.token!.length > 10
                    ? '${loginResponse.token!.substring(0, 10)}...'
                    : loginResponse.token!;
            LoggerService.info(
              'Authentication token received: $tokenPreview',
              tag: 'LOGIN_SERVICE',
            );
          }

          if (loginResponse.message != null) {
            LoggerService.info(
              'Server message: ${loginResponse.message}',
              tag: 'LOGIN_SERVICE',
            );
          }

          if (loginResponse.userData != null) {
            LoggerService.debug(
              'User data from server: ${json.encode(loginResponse.userData)}',
              tag: 'LOGIN_SERVICE',
            );
          }
        } else {
          LoggerService.error(
            'Login failed with $provider (Status: ${response.statusCode})',
            tag: 'LOGIN_SERVICE',
          );
          LoggerService.warning(
            'Server error message: ${loginResponse.message ?? 'No error message'}',
            tag: 'LOGIN_SERVICE',
          );
        }

        return loginResponse;
      } else {
        LoggerService.error(
          'Login failed with status ${response.statusCode}',
          tag: 'LOGIN_SERVICE',
        );
        LoggerService.error(
          'Error response body: ${response.body}',
          tag: 'LOGIN_SERVICE',
        );

        throw LoginException(
          'Login failed with status ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      LoggerService.error(
        'Error during login with $provider',
        error: e,
        tag: 'LOGIN_SERVICE',
      );

      if (e is LoginException) rethrow;

      if (e.toString().contains('SocketException')) {
        LoggerService.error(
          'No internet connection detected',
          tag: 'LOGIN_SERVICE',
        );
        throw LoginException('No internet connection', 0, 'Network error');
      } else if (e.toString().contains('TimeoutException')) {
        LoggerService.error('Request timeout occurred', tag: 'LOGIN_SERVICE');
        throw LoginException('Request timeout', 0, 'Request timed out');
      } else {
        LoggerService.error('Unknown network error: $e', tag: 'LOGIN_SERVICE');
        throw LoginException('Network error: $e', 0, '');
      }
    }
  }
}

/// Login response model
class LoginResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? userData;

  LoginResponse({
    required this.success,
    this.message,
    this.token,
    this.userData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      userData: json['user_data'],
    );
  }
}

/// Login exception class
class LoginException implements Exception {
  final String message;
  final int statusCode;
  final String responseBody;

  LoginException(this.message, this.statusCode, this.responseBody);

  @override
  String toString() {
    return 'LoginException: $message (Status: $statusCode)';
  }
}
