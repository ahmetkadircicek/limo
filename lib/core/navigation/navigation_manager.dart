import 'package:go_router/go_router.dart';
import 'package:limo/module/car_management/view/car_management_view.dart';
import 'package:limo/module/car_registration/view/car_registration_view.dart';
import 'package:limo/module/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/module/document_upload/view/document_upload_view.dart';
import 'package:limo/module/login/view/login_view.dart';
import 'package:limo/module/navigation/view/navigation_view.dart';
import 'package:limo/module/profile/view/profile_view.dart';
import 'package:limo/module/profile_update/view/profile_edit_view.dart';
import 'package:limo/module/splash/view/splash_view.dart';

class NavigationManager {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = 'profile';
  static const String profileEdit = 'profile/edit';
  static const String carManagement = 'cars';
  static const String carRegistration = 'cars/register';
  static const String documentUpload = 'document/upload';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const NavigationView(),
        routes: [
          GoRoute(
            path: profile,
            name: 'profile',
            builder: (context, state) => const ProfileView(),
          ),
          GoRoute(
            path: profileEdit,
            name: 'profileEdit',
            builder: (context, state) => const ProfileEditView(),
          ),
          GoRoute(
            path: carManagement,
            name: 'carManagement',
            builder: (context, state) => const CarManagementView(),
          ),
          GoRoute(
            path: carRegistration,
            name: 'carRegistration',
            builder: (context, state) => const CarRegistrationView(),
          ),
          GoRoute(
            path: documentUpload,
            name: 'documentUpload',
            builder: (context, state) {
              final purpose = state.extra as DocumentUploadPurpose;
              return DocumentUploadView(purpose: purpose);
            },
          ),
        ],
      ),
    ],
  );
}
