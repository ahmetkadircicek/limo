import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging service for the entire application
/// Uses the logger package for beautiful and structured logging
class LoggerService {
  static final Logger _logger = Logger(
    filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
    printer: SimplePrinter(colors: false),
    output: ConsoleOutput(),
  );

  /// Debug log - sadece debug build'de
  static void debug(String message, {String? tag}) {
    _logger.d(_formatMessage(message, tag));
  }

  /// Bilgi log'u
  static void info(String message, {String? tag}) {
    _logger.i(_formatMessage(message, tag));
  }

  /// Uyarı log'u
  static void warning(String message, {String? tag}) {
    _logger.w(_formatMessage(message, tag));
  }

  /// Hata log'u
  static void error(String message, {Object? error, String? tag}) {
    if (error != null) {
      _logger.e(_formatMessage(message, tag), error: error);
    } else {
      _logger.e(_formatMessage(message, tag));
    }
  }

  /// Başarı log'u
  static void success(String message, {String? tag}) {
    _logger.i('✅ ${_formatMessage(message, tag)}');
  }

  /// Network log'u - sade
  static void network(String method, String url, {String? tag}) {
    _logger.i('🌐 $method ${_extractEndpoint(url)}');
  }

  /// Auth log'u
  static void auth(String message, {String? tag}) {
    _logger.i('🔐 ${_formatMessage(message, tag)}');
  }

  /// Database log'u
  static void database(String operation, {String? tag}) {
    _logger.i('💾 ${_formatMessage(operation, tag)}');
  }

  /// Log with custom level
  static void log(Level level, String message, {String? tag}) {
    final prefix = tag != null ? '[$tag] ' : '';
    _logger.log(level, '$prefix$message');
  }

  /// Get the underlying logger instance for advanced usage
  static Logger get logger => _logger;

  /// Navigation log - only in debug mode
  static void navigation(String message, {String? tag}) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      _logger.i('🧭 $prefix$message');
    }
  }

  // ===== RENKLİ LOG METODLARI =====

  /// Sade network log
  static void networkColor(String method, String url, {String? tag}) {
    final emoji = _getNetworkEmoji(method);
    final endpoint = _extractEndpoint(url);
    _logger.i('$emoji $method $endpoint');
  }

  /// Sade auth log
  static void authColor(String message, {String? tag}) {
    _logger.i('🔐 ${_formatMessage(message, tag)}');
  }

  /// Sade database log
  static void databaseColor(String operation, {String? tag}) {
    _logger.i('💾 ${_formatMessage(operation, tag)}');
  }

  /// Sade success log
  static void successColor(String message, {String? tag}) {
    _logger.i('✅ ${_formatMessage(message, tag)}');
  }

  /// Sade warning log
  static void warningColor(String message, {String? tag}) {
    _logger.w('⚠️ ${_formatMessage(message, tag)}');
  }

  /// Sade error log
  static void errorColor(String message, {Object? error, String? tag}) {
    if (error != null) {
      _logger.e('❌ ${_formatMessage(message, tag)}', error: error);
    } else {
      _logger.e('❌ ${_formatMessage(message, tag)}');
    }
  }

  // ===== PRIVATE HELPER METODLARI =====

  /// Tag ile mesajı formatla
  static String _formatMessage(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }

  /// URL'den sadece endpoint'i çıkar (sade log için)
  static String _extractEndpoint(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.path.isEmpty ? '/' : uri.path;
    } catch (e) {
      return url;
    }
  }

  /// Network method için emoji döndür
  static String _getNetworkEmoji(String method) {
    switch (method.toUpperCase()) {
      case 'POST':
      case 'POST_RESPONSE':
        return '📤';
      case 'GET':
      case 'GET_RESPONSE':
        return '📥';
      case 'PUT':
        return '📝';
      case 'DELETE':
      case 'DELETE_RESPONSE':
        return '🗑️';
      case 'PATCH':
        return '🔧';
      default:
        return '🌐';
    }
  }
}
