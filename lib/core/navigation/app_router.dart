import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/navigation/route_paths.dart';
import 'package:limo/module/car_management/view/car_management_view.dart';
import 'package:limo/module/car_registration/view/car_registration_view.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/module/document_upload/view/document_upload_view.dart';
import 'package:limo/module/job_create/view/job_create_view.dart';
import 'package:limo/module/login/view/login_view.dart';
import 'package:limo/module/navigation/view/navigation_view.dart';
import 'package:limo/module/profile/view/profile_view.dart';
import 'package:limo/module/splash/view/splash_view.dart';

// core/navigation/app_router.dart
GoRouter createAppRouter({
  String initialLocation = RoutePaths.splash,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: false,
    errorPageBuilder:
        (context, state) => const MaterialPage(child: Placeholder()),
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (_, _) => const SplashView(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (_, _) => const LoginView(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (_, _) => const NavigationView(),
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (_, _) => const ProfileView(),
      ),
      GoRoute(
        path: RoutePaths.carManagement,
        name: RouteNames.carManagement,
        builder: (_, _) => const CarManagementView(),
      ),
      GoRoute(
        path: RoutePaths.carRegistration,
        name: RouteNames.carRegistration,
        builder: (_, _) => const CarRegistrationView(),
      ),
      GoRoute(
        path: RoutePaths.documentUpload,
        name: RouteNames.documentUpload,
        builder:
            (_, state) => DocumentUploadView(
              purpose: state.extra as DocumentUploadPurpose,
            ),
      ),
      GoRoute(
        path: RoutePaths.jobCreate,
        name: RouteNames.jobCreate,
        builder: (_, _) => const JobCreateView(),
      ),
    ],
  );
}
