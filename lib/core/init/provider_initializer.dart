import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/oauth_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/feature/document_upload/viewmodel/document_upload_view_model.dart';
import 'package:limo/feature/fleet_management/view_model/fleet_management_view_model.dart';
import 'package:limo/feature/fleet_vehicle_registration/view_model/fleet_vehicle_registration_view_model.dart';
import 'package:limo/feature/login/view_model/login_view_model.dart';
import 'package:limo/feature/navigation/viewmodel/navigation_view_model.dart'
    show NavigationViewModel;
import 'package:limo/feature/profile/view_model/profile_view_model.dart';
import 'package:limo/feature/profile_update/viewmodel/profile_update_view_model.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderInitializer {
  static ProviderInitializer? _instance;
  static ProviderInitializer get instance {
    _instance ??= ProviderInitializer._init();
    return _instance!;
  }

  ProviderInitializer._init();

  // Only real providers (ChangeNotifier for state management)
  List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (context) => OAuthProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => BrandProvider()),
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => ModelProvider()),
  ];

  // ViewModels for features
  List<SingleChildWidget> get viewModels => [
    ChangeNotifierProvider(create: (context) => SplashViewModel()),
    ChangeNotifierProvider(create: (context) => LoginViewModel()),
    ChangeNotifierProvider(create: (context) => NavigationViewModel()),
    ChangeNotifierProvider(create: (context) => ProfileViewModel()),
    ChangeNotifierProvider(create: (context) => ProfileUpdateViewModel()),
    ChangeNotifierProvider(create: (context) => FleetManagementViewModel()),
    ChangeNotifierProvider(
      create: (context) => FleetVehicleRegistrationViewModel(),
    ),
    ChangeNotifierProvider(create: (context) => DocumentUploadViewModel()),
  ];

  // Combined getter for all providers
  List<SingleChildWidget> get allProviders => [...providers, ...viewModels];
}
