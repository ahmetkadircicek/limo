import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/module/car_management/view/car_management_view.dart';
import 'package:limo/module/car_registration/view/car_registration_view.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/module/document_upload/view/document_upload_view.dart';
import 'package:limo/module/login/view/login_view.dart';
import 'package:limo/module/navigation/view/navigation_view.dart';
import 'package:limo/module/profile/view/profile_view.dart';
import 'package:limo/module/profile_update/view/profile_edit_view.dart';
import 'package:limo/module/splash/view/splash_view.dart';

GoRouter createAppRouter({String initialLocation = RoutePaths.splash}) {
  return GoRouter(
    initialLocation: initialLocation,
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) {
      LoggerService.warning('Route not found: ${state.uri}', tag: 'Router');
      return const MaterialPage(child: _NotFoundView());
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const NavigationView(),
        routes: [
          GoRoute(
            path: RoutePaths.profile,
            name: RouteNames.profile,
            builder: (context, state) => const ProfileView(),
          ),
          GoRoute(
            path: RoutePaths.profileEdit,
            name: RouteNames.profileEdit,
            builder: (context, state) => const ProfileEditView(),
          ),
          GoRoute(
            path: RoutePaths.carManagement,
            name: RouteNames.carManagement,
            builder: (context, state) => const CarManagementView(),
          ),
          GoRoute(
            path: RoutePaths.carRegistration,
            name: RouteNames.carRegistration,
            builder: (context, state) => const CarRegistrationView(),
          ),
          GoRoute(
            path: RoutePaths.documentUpload,
            name: RouteNames.documentUpload,
            builder: (context, state) {
              final purpose = state.extra as DocumentUploadPurpose;
              return DocumentUploadView(purpose: purpose);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // Placeholder for auth/permission guards; must be side-effect free.
      // Example: if not authenticated and not on login, redirect to login.
      return null;
    },
  );
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Page not found')));
  }
}
