import 'package:limo/core/providers/brand_provider.dart';
import 'package:limo/core/providers/car_provider.dart';
import 'package:limo/core/providers/category_provider.dart';
import 'package:limo/core/providers/job_provider.dart';
import 'package:limo/core/providers/job_type_provider.dart';
import 'package:limo/core/providers/model_provider.dart';
import 'package:limo/core/providers/oauth_provider.dart';
import 'package:limo/core/providers/user_provider.dart';
import 'package:limo/module/car_management/view_model/car_management_view_model.dart';
import 'package:limo/module/car_registration/view_model/car_registration_view_model.dart';
import 'package:limo/module/document_upload/view_model/document_upload_view_model.dart';
import 'package:limo/module/login/view_model/login_view_model.dart';
import 'package:limo/module/navigation/view_model/navigation_view_model.dart'
    show NavigationViewModel;
import 'package:limo/module/profile/view_model/profile_view_model.dart';
import 'package:limo/module/profile_update/view_model/profile_update_view_model.dart';
import 'package:limo/module/splash/view_model/splash_view_model.dart';
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
    ChangeNotifierProvider(create: (context) => CarProvider()),
    ChangeNotifierProvider(create: (context) => JobTypeProvider()),
    ChangeNotifierProvider(create: (context) => JobProvider()),
  ];

  // ViewModels for features
  List<SingleChildWidget> get viewModels => [
    ChangeNotifierProvider(create: (context) => SplashViewModel()),
    ChangeNotifierProvider(create: (context) => LoginViewModel()),
    ChangeNotifierProvider(create: (context) => NavigationViewModel()),
    ChangeNotifierProvider(create: (context) => ProfileViewModel()),
    ChangeNotifierProvider(create: (context) => ProfileUpdateViewModel()),
    ChangeNotifierProvider(create: (context) => CarManagementViewModel()),
    ChangeNotifierProvider(create: (context) => CarRegistrationViewModel()),
    ChangeNotifierProvider(create: (context) => DocumentUploadViewModel()),
  ];

  // Combined getter for all providers
  List<SingleChildWidget> get allProviders => [...providers, ...viewModels];
}
