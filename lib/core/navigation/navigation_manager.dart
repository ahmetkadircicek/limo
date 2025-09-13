import 'package:go_router/go_router.dart';
import 'package:limo/feature/document_upload/enums/document_upload_purpose_enum.dart';
import 'package:limo/feature/document_upload/view/document_upload_view.dart';
import 'package:limo/feature/fleet_management/view/fleet_management_view.dart';
import 'package:limo/feature/fleet_vehicle_registration/view/fleet_vehicle_registration_view.dart';
import 'package:limo/feature/login/view/login_view.dart';
import 'package:limo/feature/navigation/view/navigation_view.dart';
import 'package:limo/feature/profile/view/profile_view.dart';
import 'package:limo/feature/profile_update/view/profile_edit_view.dart';
import 'package:limo/feature/splash/view/splash_view.dart';

class NavigationManager {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = 'profile';
  static const String profileEdit = 'profile/edit';
  static const String fleetManagement = 'fleet';
  static const String fleetVehicleRegistration = 'fleet/vehicle/register';
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
            path: fleetManagement,
            name: 'fleetManagement',
            builder: (context, state) => const FleetManagementView(),
          ),
          GoRoute(
            path: fleetVehicleRegistration,
            name: 'fleetVehicleRegistration',
            builder: (context, state) => const FleetVehicleRegistrationView(),
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
