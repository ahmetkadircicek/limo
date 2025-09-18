import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging service for the entire application.
/// Uses the logger package for structured logging.
class LoggerService {
  static final Logger _logger = Logger(
    filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
    printer: SimplePrinter(colors: false),
    output: ConsoleOutput(),
  );

  /// Debug log - only in debug build
  static void debug(String message, {String? tag}) {
    _logger.d(_formatMessage(message, tag));
  }

  /// Info log
  static void info(String message, {String? tag}) {
    _logger.i(_formatMessage(message, tag));
  }

  /// Warning log
  static void warning(String message, {String? tag}) {
    _logger.w(_formatMessage(message, tag));
  }

  /// Error log
  static void error(String message, {Object? error, String? tag}) {
    if (error != null) {
      _logger.e(_formatMessage(message, tag), error: error);
    } else {
      _logger.e(_formatMessage(message, tag));
    }
  }

  /// Success log
  static void success(String message, {String? tag}) {
    _logger.i(_formatMessage(message, tag));
  }

  /// Network log
  static void network(String method, String url, {String? tag}) {
    _logger.i('${method.toUpperCase()} ${_extractEndpoint(url)}');
  }

  /// Auth log
  static void auth(String message, {String? tag}) {
    _logger.i(_formatMessage(message, tag));
  }

  /// Database log
  static void database(String operation, {String? tag}) {
    _logger.i(_formatMessage(operation, tag));
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
      _logger.i('$prefix$message');
    }
  }

  /// Format message with tag
  static String _formatMessage(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }

  /// Extract only endpoint from URL
  static String _extractEndpoint(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.path.isEmpty ? '/' : uri.path;
    } catch (e) {
      return url;
    }
  }
}
