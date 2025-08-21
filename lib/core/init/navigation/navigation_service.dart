import 'package:flutter/material.dart';

class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance {
    _instance ??= NavigationService._init();
    return _instance!;
  }

  NavigationService._init();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Go back to previous route
  void goBack([dynamic popValue]) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      if (popValue != null) {
        Navigator.of(context).pop(popValue);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  /// Navigate to a screen
  Future<dynamic> navigateToScreen(Widget page) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => page));
    }
  }

  /// Replace current screen
  Future<dynamic> replaceScreen(Widget page) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => page));
    }
  }

  /// Pop to first route
  void popToFirst() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
