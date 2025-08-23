import 'package:limo/core/providers/app_state_provider.dart';
import 'package:limo/feature/document_upload/viewmodel/document_upload_view_model.dart';
import 'package:limo/feature/fleet_management/viewmodel/fleet_management_view_model.dart';
import 'package:limo/feature/fleet_vehicle_registration/viewmodel/fleet_vehicle_registration_view_model.dart';
import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:limo/feature/job_details/viewmodel/job_details_view_model.dart';
import 'package:limo/feature/job_list/viewmodel/job_list_view_model.dart';
import 'package:limo/feature/job_vehicle_registration/viewmodel/job_vehicle_registration_view_model.dart';
import 'package:limo/feature/login/viewmodel/login_view_model.dart';
import 'package:limo/feature/profile/viewmodel/profile_view_model.dart';
import 'package:limo/feature/profile_update/viewmodel/profile_update_view_model.dart';
import 'package:limo/feature/splash/viewmodel/splash_view_model.dart';
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
    Provider(create: (context) => JobListViewModel()),
    Provider(create: (context) => JobDetailsViewModel()),
    ChangeNotifierProvider(
      create: (context) => JobVehicleRegistrationViewModel(),
    ),
    ChangeNotifierProvider(create: (context) => FleetManagementViewModel()),
    ChangeNotifierProvider(
      create: (context) => FleetVehicleRegistrationViewModel(),
    ),
    Provider(create: (context) => ProfileViewModel()),
    ChangeNotifierProvider(create: (context) => ProfileUpdateViewModel()),
    ChangeNotifierProvider(create: (context) => DocumentUploadViewModel()),
  ];
}
