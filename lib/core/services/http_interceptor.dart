import 'package:http/http.dart' as http;
import 'package:limo/core/services/auth_token_manager.dart';

class HttpInterceptor {
  static HttpInterceptor? _instance;
  static HttpInterceptor get instance => _instance ??= HttpInterceptor._();

  HttpInterceptor._();

  static Future<http.Request> interceptRequest(http.Request request) async {
    try {
      final token = await AuthTokenManager.instance.getValidAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      return request;
    } catch (e) {
      return request;
    }
  }

  static Future<http.Request> authenticatedGet(
    String url, {
    Map<String, String>? headers,
  }) async {
    final request = http.Request('GET', Uri.parse(url));
    final interceptedRequest = await interceptRequest(request);
    if (headers != null) {
      interceptedRequest.headers.addAll(headers);
    }
    return interceptedRequest;
  }

  static Future<http.Request> authenticatedPost(
    String url, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final request = http.Request('POST', Uri.parse(url));
    if (body != null) {
      request.body = body.toString();
    }
    final interceptedRequest = await interceptRequest(request);
    if (headers != null) {
      interceptedRequest.headers.addAll(headers);
    }
    return interceptedRequest;
  }

  static Future<http.Request> authenticatedPut(
    String url, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final request = http.Request('PUT', Uri.parse(url));
    if (body != null) {
      request.body = body.toString();
    }
    final interceptedRequest = await interceptRequest(request);
    if (headers != null) {
      interceptedRequest.headers.addAll(headers);
    }
    return interceptedRequest;
  }

  static Future<http.Request> authenticatedDelete(
    String url, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final request = http.Request('DELETE', Uri.parse(url));
    if (body != null) {
      request.body = body.toString();
    }
    final interceptedRequest = await interceptRequest(request);
    if (headers != null) {
      interceptedRequest.headers.addAll(headers);
    }
    return interceptedRequest;
  }

  static bool isAuthenticationError(http.Response response) {
    return response.statusCode == 401 || response.statusCode == 403;
  }

  static Future<void> handleAuthenticationError() async {
    await AuthTokenManager.instance.clearTokens();
  }
}
