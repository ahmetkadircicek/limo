import 'package:limo/core/services/api_client.dart';
import 'package:limo/core/utils/logger_service.dart';
import 'package:limo/feature/login/models/login_request_model.dart';

/// Login Service for provider-based authentication
class LoginService {
  static LoginService? _instance;
  static LoginService get instance => _instance ??= LoginService._();
  LoginService._();

  static const String _loginEndpoint = '/login';

  /// Login with Google provider
  static Future<LoginResponse> loginWithGoogle({
    required String providerUserId,
    required String email,
    required String userName,
  }) async {
    final loginRequest = LoginRequestModel(
      provider: 'google',
      providerUserId: providerUserId,
      email: email,
      userName: userName,
    );

    return await _performLogin(loginRequest);
  }

  /// Authenticate with Google using persisted data (for splash screen)
  static Future<LoginResponse?> authenticateWithGoogle({
    required String providerUserId,
    String? email,
    String? userName,
  }) async {
    try {
      LoggerService.info(
        'Authenticating with Google using persisted data for user: $providerUserId',
        tag: 'LOGIN_SERVICE',
      );

      final loginRequest = LoginRequestModel(
        provider: 'google',
        providerUserId: providerUserId,
        email: email ?? 'no-email@google.com',
        userName: userName ?? 'Google User',
      );

      final response = await _performLogin(loginRequest);

      if (response.success) {
        LoggerService.success(
          'Successfully authenticated with Google using persisted data',
          tag: 'LOGIN_SERVICE',
        );
      } else {
        LoggerService.warning(
          'Failed to authenticate with Google using persisted data: ${response.message}',
          tag: 'LOGIN_SERVICE',
        );
      }

      return response;
    } catch (e) {
      LoggerService.error(
        'Error during Google authentication with persisted data: $e',
        tag: 'LOGIN_SERVICE',
      );
      return null;
    }
  }

  /// Login with Apple provider
  static Future<LoginResponse> loginWithApple({
    required String providerUserId,
    String? email,
    String? userName,
  }) async {
    final loginRequest = LoginRequestModel(
      provider: 'apple',
      providerUserId: providerUserId,
      email: email ?? 'no-email@apple.com',
      userName: userName ?? 'Apple User',
    );

    return await _performLogin(loginRequest);
  }

  /// Perform the actual login request (encrypted)
  static Future<LoginResponse> _performLogin(
    LoginRequestModel loginRequest,
  ) async {
    try {
      LoggerService.info(
        'Attempting encrypted login with ${loginRequest.provider}',
        tag: 'LOGIN_SERVICE',
      );

      // Use encrypted API call
      final responseData = await ApiClient.post(
        _loginEndpoint,
        data: loginRequest.toJson(),
        timeout: const Duration(seconds: 15),
      );

      // Debug: Log raw response
      LoggerService.info(
        'Raw response data: $responseData',
        tag: 'LOGIN_SERVICE',
      );

      // Validate response structure
      if (!responseData.containsKey('success')) {
        LoggerService.warning(
          'Response missing "success" field',
          tag: 'LOGIN_SERVICE',
        );
      }

      // Check for token fields in multiple locations
      final tokenInfo = _extractTokenFromResponse(responseData);

      if (tokenInfo.hasToken) {
        LoggerService.info(
          'Token found: ${tokenInfo.source}',
          tag: 'LOGIN_SERVICE',
        );
      } else {
        LoggerService.warning(
          'Response missing access_token in all expected locations',
          tag: 'LOGIN_SERVICE',
        );
        LoggerService.debug(
          'Available fields: ${responseData.keys.toList()}',
          tag: 'LOGIN_SERVICE',
        );
      }

      final loginResponse = LoginResponse.fromJson(responseData);

      // Debug: Log parsed response with detailed token info
      LoggerService.info(
        'Parsed response - success: ${loginResponse.success}, message: ${loginResponse.message}, token: ${loginResponse.token != null ? 'present (${loginResponse.token!.length} chars)' : 'missing'}',
        tag: 'LOGIN_SERVICE',
      );

      // Check if we have a valid token (this is our success condition)
      final hasValidToken =
          (loginResponse.token != null && loginResponse.token!.isNotEmpty) ||
          (loginResponse.accessToken != null &&
              loginResponse.accessToken!.isNotEmpty);

      // HTTP 200/201 + valid token means success, override JSON success field if needed
      final actualSuccess = hasValidToken;

      if (actualSuccess) {
        LoggerService.success(
          'Encrypted login successful for ${loginRequest.provider} (HTTP 200/201)',
          tag: 'LOGIN_SERVICE',
        );

        // Return successful response even if JSON success field was false
        return LoginResponse(
          success: true, // Force success based on HTTP status + token presence
          message: loginResponse.message ?? 'Login successful',
          token: loginResponse.token,
          accessToken: loginResponse.accessToken,
          user: loginResponse.user,
        );
      } else {
        LoggerService.error(
          'Encrypted login failed for ${loginRequest.provider}: Backend response missing access_token',
          tag: 'LOGIN_SERVICE',
        );
      }

      return loginResponse;
    } catch (e) {
      LoggerService.error(
        'Encrypted login request error: $e',
        error: e,
        tag: 'LOGIN_SERVICE',
      );

      String errorMessage = 'Login request failed';
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'No internet connection. Please check your connection.';
      } else if (e.toString().contains('Encryption') ||
          e.toString().contains('Decryption')) {
        errorMessage = 'Data encryption error. Please try again.';
      }

      return LoginResponse(
        success: false,
        message: errorMessage,
        token: null,
        accessToken: null,
        user: null,
      );
    }
  }

  /// Extract token from response data, checking multiple possible locations
  static TokenInfo _extractTokenFromResponse(
    Map<String, dynamic> responseData,
  ) {
    // Priority 1: Check root level access_token
    if (responseData.containsKey('access_token') &&
        responseData['access_token'] != null &&
        responseData['access_token'].toString().isNotEmpty) {
      return TokenInfo(
        token: responseData['access_token'],
        source: 'root.access_token',
        hasToken: true,
      );
    }

    // Priority 2: Check root level token
    if (responseData.containsKey('token') &&
        responseData['token'] != null &&
        responseData['token'].toString().isNotEmpty) {
      return TokenInfo(
        token: responseData['token'],
        source: 'root.token',
        hasToken: true,
      );
    }

    // Priority 3: Check decryptedData.access_token
    if (responseData.containsKey('decryptedData') &&
        responseData['decryptedData'] is Map<String, dynamic>) {
      final decryptedData =
          responseData['decryptedData'] as Map<String, dynamic>;

      if (decryptedData.containsKey('access_token') &&
          decryptedData['access_token'] != null &&
          decryptedData['access_token'].toString().isNotEmpty) {
        return TokenInfo(
          token: decryptedData['access_token'],
          source: 'decryptedData.access_token',
          hasToken: true,
        );
      }

      // Priority 4: Check decryptedData.token
      if (decryptedData.containsKey('token') &&
          decryptedData['token'] != null &&
          decryptedData['token'].toString().isNotEmpty) {
        return TokenInfo(
          token: decryptedData['token'],
          source: 'decryptedData.token',
          hasToken: true,
        );
      }
    }

    // No token found
    return TokenInfo(token: null, source: 'none', hasToken: false);
  }

  /// Test method for response parsing scenarios
  static void testResponseParsing() {
    LoggerService.info(
      'Testing response parsing scenarios',
      tag: 'LOGIN_SERVICE_TEST',
    );

    // Test Case 1: Backend response with decryptedData.access_token
    final testResponse1 = {
      'decryptedData': {
        'access_token': 'test_token_123',
        'user': {'id': '123', 'email': 'test@example.com'},
      },
    };

    final tokenInfo1 = _extractTokenFromResponse(testResponse1);
    LoggerService.info(
      'Test 1 - decryptedData.access_token: ${tokenInfo1.hasToken ? 'PASS' : 'FAIL'} (${tokenInfo1.source})',
      tag: 'LOGIN_SERVICE_TEST',
    );

    // Test Case 2: Backend response without access_token
    final testResponse2 = {'message': 'Login failed', 'user': null};

    final tokenInfo2 = _extractTokenFromResponse(testResponse2);
    LoggerService.info(
      'Test 2 - No access_token: ${!tokenInfo2.hasToken ? 'PASS' : 'FAIL'} (${tokenInfo2.source})',
      tag: 'LOGIN_SERVICE_TEST',
    );

    // Test Case 3: Response without success field
    final testResponse3 = {
      'access_token': 'test_token_456',
      'user': {'id': '456', 'email': 'test2@example.com'},
    };

    final tokenInfo3 = _extractTokenFromResponse(testResponse3);
    LoggerService.info(
      'Test 3 - No success field: ${tokenInfo3.hasToken ? 'PASS' : 'FAIL'} (${tokenInfo3.source})',
      tag: 'LOGIN_SERVICE_TEST',
    );

    LoggerService.info(
      'Response parsing tests completed',
      tag: 'LOGIN_SERVICE_TEST',
    );
  }
}

/// Token information extracted from response
class TokenInfo {
  final String? token;
  final String source;
  final bool hasToken;

  const TokenInfo({this.token, required this.source, required this.hasToken});

  @override
  String toString() {
    return 'TokenInfo(token: ${token != null ? '***' : 'null'}, source: $source, hasToken: $hasToken)';
  }
}

/// Response model for login requests
class LoginResponse {
  final bool success;
  final String? message;
  final String? token;
  final String? accessToken; // New field for access_token
  final Map<String, dynamic>? user;

  const LoginResponse({
    required this.success,
    this.message,
    this.token,
    this.accessToken,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Extract token using the new helper method
    final tokenInfo = LoginService._extractTokenFromResponse(json);

    if (tokenInfo.hasToken) {
      LoggerService.debug(
        'Token found in ${tokenInfo.source}',
        tag: 'LOGIN_SERVICE',
      );
    } else {
      LoggerService.warning(
        'No access_token found in response using new extraction logic',
        tag: 'LOGIN_SERVICE',
      );
    }

    // Extract user data from response
    Map<String, dynamic>? userData;
    if (json.containsKey('user_id')) {
      // Direct user data in response
      userData = {
        'user_id': json['user_id'],
        'provider': json['provider'],
        'provider_user_id': json['provider_user_id'],
        'email': json['email'],
        'phone': json['phone'],
        'user_name': json['user_name'],
        'company_name': json['company_name'],
        'created_at': json['created_at'],
        'last_login': json['last_login'],
        'access_token': json['access_token'],
        'is_active': json['is_active'],
        'driver_lisans': json['driver_lisans'],
        'approved': json['approved'],
        'user_photo': json['user_photo'],
      };
    } else if (json.containsKey('user')) {
      // User data nested in 'user' field
      userData = json['user'];
    }

    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: tokenInfo.token, // Use extracted token
      accessToken: tokenInfo.token, // Use extracted token for both fields
      user: userData,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(success: $success, message: $message)';
  }
}
