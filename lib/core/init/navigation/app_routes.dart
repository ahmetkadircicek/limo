import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:limo/core/services/logger_service.dart';
import 'package:limo/feature/home/view/home_view.dart';
import 'package:limo/feature/job_list/model/job_model.dart';
import 'package:limo/feature/job_list/view/job_details_page.dart';
import 'package:limo/feature/job_list/view/job_list_view.dart';
import 'package:limo/feature/job_tracking/view/job_tracking_view.dart'
    as tracking;
import 'package:limo/feature/listing_job/view/listing_job_view.dart';
import 'package:limo/feature/listing_job/view/vehicle_requirement_page.dart';
import 'package:limo/feature/login/view/login_view.dart';
import 'package:limo/feature/map/view/location_picker_page.dart';
import 'package:limo/feature/profile/view/profile_view.dart';
import 'package:limo/feature/splash/view/splash_view.dart';
import 'package:limo/feature/vehicle_registration/model/vehicle_model.dart';
import 'package:limo/feature/vehicle_registration/view/document_upload_view.dart';
import 'package:limo/feature/vehicle_registration/view/vehicle_registration_view.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_text.dart';

/// Centralized route definitions using GoRouter
class AppRoutes {
  // Route names - consistent naming convention
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String vehicleRegistration = '/vehicle-registration';
  static const String vehicleManagement = '/vehicle-management';
  static const String jobList = '/job-list';
  static const String listingJob = '/listing-job';
  static const String profile = '/profile';
  static const String locationPicker = '/location-picker';
  static const String dashboard = '/dashboard';
  static const String jobTracking = '/job-tracking';
  static const String jobDetails = '/job-details';
  static const String vehicleRequirements = '/vehicle-requirements';
  static const String documentUpload = '/document-upload';

  /// Main router configuration
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash screen - initial route
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) {
          LoggerService.info("Navigation to Splash");
          return const SplashView();
        },
      ),

      // Login route
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) {
          LoggerService.info("Navigation to Login");
          return const LoginView();
        },
      ),

      // Home route with nested navigation
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) {
          LoggerService.info("Navigation to Home");
          return const HomeView();
        },
        routes: [
          // Nested routes for home tabs
          GoRoute(
            path: 'profile',
            name: 'home.profile',
            builder: (context, state) {
              LoggerService.info("Navigation to Profile from Home");
              return const ProfileView();
            },
          ),
        ],
      ),

      // Vehicle registration route with parameters
      GoRoute(
        path: vehicleRegistration,
        name: 'vehicle-registration',
        builder: (context, state) {
          LoggerService.info("Navigation to Vehicle Registration");
          final vehicleToEdit = state.extra as VehicleModel?;
          return VehicleRegistrationView(vehicleToEdit: vehicleToEdit);
        },
      ),

      // Vehicle management route - redirects to home with specific page
      GoRoute(
        path: vehicleManagement,
        name: 'vehicle-management',
        builder: (context, state) {
          LoggerService.info("Navigation to Vehicle Management via Home");
          return const HomeView();
        },
      ),

      // Job list route
      GoRoute(
        path: jobList,
        name: 'job-list',
        builder: (context, state) {
          LoggerService.info("Navigation to Job List");
          return const JobListView();
        },
      ),

      // Listing job route
      GoRoute(
        path: listingJob,
        name: 'listing-job',
        builder: (context, state) {
          LoggerService.info("Navigation to Listing Job");
          return const ListingJobView();
        },
      ),

      // Profile route
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) {
          LoggerService.info("Navigation to Profile");
          return const ProfileView();
        },
      ),

      // Location picker route with query parameters
      GoRoute(
        path: locationPicker,
        name: 'location-picker',
        builder: (context, state) {
          LoggerService.info("Navigation to Location Picker");

          // Get title from extra
          String title = 'Select Location';
          if (state.extra is Map<String, dynamic>) {
            final args = state.extra as Map<String, dynamic>;
            title = args['title'] ?? 'Select Location';
          }

          // Create LocationPickerPage that will return the selected location
          return LocationPickerPage(
            title: title,
            onLocationSelected: (location) {
              // Navigate back with the selected location
              Navigator.of(context).pop(location);
            },
          );
        },
      ),

      // Dashboard route
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) {
          LoggerService.info("Navigation to Dashboard");
          return const tracking.JobTrackingView();
        },
      ),

      // Job tracking route
      GoRoute(
        path: jobTracking,
        name: 'job-tracking',
        builder: (context, state) {
          LoggerService.info("Navigation to Job Tracking");
          return const tracking.JobTrackingView();
        },
      ),

      // Job details route with parameters
      GoRoute(
        path: jobDetails,
        name: 'job-details',
        builder: (context, state) {
          LoggerService.info("Navigation to Job Details");
          final job = state.extra as JobModel?;
          if (job != null) {
            return JobDetailsPage(job: job);
          }
          return const Scaffold(
            body: Center(child: AppText.body('Job not found')),
          );
        },
      ),

      // Vehicle requirements route with parameters
      GoRoute(
        path: vehicleRequirements,
        name: 'vehicle-requirements',
        builder: (context, state) {
          LoggerService.info("Navigation to Vehicle Requirements");
          final args = state.extra as Map<String, dynamic>?;
          return VehicleRequirementPage(
            initialRequirement: args?['initialRequirement'],
            onSave: args?['onSave'] ?? (requirement) {},
          );
        },
      ),

      // Document upload route with parameters
      GoRoute(
        path: documentUpload,
        name: 'document-upload',
        builder: (context, state) {
          LoggerService.info("Navigation to Document Upload");
          final args = state.extra as Map<String, dynamic>?;
          if (args != null) {
            final documentType = args['documentType'] as String;
            final licencePlate = args['licencePlate'] as String?;
            return DocumentUploadView(
              documentType: documentType,
              vehiclePlate: licencePlate,
            );
          }
          return const Scaffold(
            body: Center(
              child: AppText.body(
                'Document type or vehicle plate not specified',
              ),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      LoggerService.error("Navigation to Error Page: ${state.error}");
      return _buildErrorPage();
    },
    redirect: (context, state) {
      // Auth guard logic can be implemented here
      // For now, return null to allow all routes
      return null;
    },
  );

  /// Build error page for unknown routes
  static Widget _buildErrorPage() {
    return Scaffold(
      appBar: AppBar(title: const AppText.heading('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const AppText.title('Page Not Found'),
            const SizedBox(height: 8),
            const AppText.body(
              'The requested page could not be found.',
              textAlign: TextAlign.center,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            AppButton.primary('Go Home', onPressed: null),
          ],
        ),
      ),
    );
  }
}

/// Extension methods for easier navigation
extension GoRouterExtension on BuildContext {
  /// Navigate to a named route
  void goNamed(
    String name, {
    Object? extra,
    Map<String, String> queryParameters = const {},
  }) {
    LoggerService.info("Navigation to $name");
    GoRouter.of(
      this,
    ).goNamed(name, extra: extra, queryParameters: queryParameters);
  }

  /// Push a named route
  void pushNamed(
    String name, {
    Object? extra,
    Map<String, String> queryParameters = const {},
  }) {
    LoggerService.info("Navigation to $name");
    GoRouter.of(
      this,
    ).pushNamed(name, extra: extra, queryParameters: queryParameters);
  }

  /// Pop current route
  void pop() {
    GoRouter.of(this).pop();
  }

  /// Go back to home
  void goHome() {
    LoggerService.info("Navigation to Home");
    GoRouter.of(this).go('/home');
  }

  /// Go to login
  void goLogin() {
    LoggerService.info("Navigation to Login");
    GoRouter.of(this).go('/login');
  }
}
