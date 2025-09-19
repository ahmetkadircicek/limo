import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/app_router.dart';
import 'package:limo/core/navigation/route_paths.dart';

/// Centralized navigator access for the app.
class NavigationService {
  NavigationService._();

  static final NavigationService instance = NavigationService._();

  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter _router = createAppRouter(
    initialLocation: RoutePaths.splash,
    navigatorKey: rootNavigatorKey,
  );

  /// Router used by [MaterialApp.router].
  static GoRouter get router => instance._router;

  /// Root navigator key for widgets needing navigator access.
  static GlobalKey<NavigatorState> get navigatorKey =>
      instance.rootNavigatorKey;

  /// Whether there is a page to pop in either the router or the raw navigator.
  static bool canPop() =>
      router.canPop() || (navigatorKey.currentState?.canPop() ?? false);

  /// Pops the top-most page if possible.
  static bool pop<T extends Object?>([T? result]) {
    if (router.canPop()) {
      router.pop(result);
      return true;
    }

    final navigator = navigatorKey.currentState;
    if (navigator?.canPop() ?? false) {
      navigator!.pop(result);
      return true;
    }

    return false;
  }

  /// Pops when possible; otherwise redirects to [fallbackPath].
  static void popOrGo(String fallbackPath) {
    final didPop = pop();
    if (!didPop) {
      router.go(fallbackPath);
    }
  }

  static void go(String location, {Object? extra}) =>
      router.go(location, extra: extra);

  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) =>
      router.goNamed(
        name,
        pathParameters: pathParameters,
        extra: extra,
      );

  static Future<T?> push<T extends Object?>(
    String location, {
    Object? extra,
  }) =>
      router.push<T>(location, extra: extra);

  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) =>
      router.pushNamed<T>(
        name,
        pathParameters: pathParameters,
        extra: extra,
      );
}
