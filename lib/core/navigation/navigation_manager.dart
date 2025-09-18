import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/app_router.dart';
import 'package:limo/core/navigation/route_paths.dart';

class NavigationManager {
  static GoRouter router = createAppRouter(initialLocation: RoutePaths.splash);
}
