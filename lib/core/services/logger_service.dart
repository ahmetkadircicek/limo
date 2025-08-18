import 'package:flutter/foundation.dart';

class LoggerService {
  /// Static methods for logging
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('🐛 DEBUG$tagPrefix $timestamp: $message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('ℹ️ INFO$tagPrefix $timestamp: $message');
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('⚠️ WARNING$tagPrefix $timestamp: $message');
    }
  }

  static void error(String message, {Object? error, String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      final errorInfo = error != null ? ' - Error: $error' : '';
      print('❌ ERROR$tagPrefix $timestamp: $message$errorInfo');
    }
  }

  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('✅ SUCCESS$tagPrefix $timestamp: $message');
    }
  }
}
