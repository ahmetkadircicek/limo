import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/login/viewmodel/login_view_model.dart';
import 'package:limo/feature/profile/viewmodel/profile_view_model.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
import 'package:limo/feature/vehicle_registration/viewmodel/vehicle_registration_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderManager {
  static ProviderManager? _instance;
  static ProviderManager get instance {
    _instance ??= ProviderManager._init();
    return _instance!;
  }

  ProviderManager._init();

  List<SingleChildWidget> get providers => [
        // Core providers
        ChangeNotifierProvider(create: (context) => AppStateProvider()),

        // Feature ViewModels
        ChangeNotifierProvider(create: (context) => SplashViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(
            create: (context) => VehicleRegistrationViewModel(context)),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
      ];
}
