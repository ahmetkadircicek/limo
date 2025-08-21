import 'package:limo/core/services/environment_service.dart';

class Constants {
  static const String appName = 'Limo';

  // Google Maps API Key - Now loaded from environment
  static String get googleMapsApiKey => EnvironmentService.googleMapsApiKey;
}
