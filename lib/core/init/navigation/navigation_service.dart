import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance {
    _instance ??= NavigationService._init();
    return _instance!;
  }

  NavigationService._init();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Go back to previous route
  dynamic goBack([dynamic popValue]) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      if (popValue != null) {
        context.pop(popValue);
      } else {
        context.pop();
      }
    }
  }

  /// Navigate to a named route
  Future<dynamic> navigateToScreen(Widget page, {dynamic arguments}) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      // For backward compatibility, we'll use push for now
      // In the future, this can be updated to use go_router methods
      return Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => page),
      );
    }
  }

  /// Replace current screen
  Future<dynamic> replaceScreen(Widget page, {dynamic arguments}) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => page),
      );
    }
  }

  /// Pop to first route
  Future<dynamic> popToFirst() async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  /// Navigate to a named route using go_router
  void goNamed(String name, {Object? extra, Map<String, String> queryParameters = const {}}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.goNamed(name, extra: extra, queryParameters: queryParameters);
    }
  }

  /// Push a named route using go_router
  void pushNamed(String name, {Object? extra, Map<String, String> queryParameters = const {}}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.pushNamed(name, extra: extra, queryParameters: queryParameters);
    }
  }

  /// Go to home route
  void goHome() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/home');
    }
  }

  /// Go to login route
  void goLogin() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/login');
    }
  }
}
