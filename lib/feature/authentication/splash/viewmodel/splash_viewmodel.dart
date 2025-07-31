import 'package:flutter/material.dart';
import 'package:soforvarcom/feature/authentication/login/view/login_view.dart';

import '../../../../core/init/navigation/navigation_service.dart';

class SplashViewModel with ChangeNotifier {
  // bool? validation;
  // UserModel? currentUser;
  // LicenceModel? userLicence;

  SplashViewModel(BuildContext context) {
    debugPrint('SplashViewModel created');
  }

  Future<void> getValidation(context) async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    // final String? phoneNumber = sharedPreferences.getString('phoneNumber');
    // final String? password = sharedPreferences.getString('password');
    // final String? type = sharedPreferences.getString('type');
    // if (phoneNumber != null && password != null && type != null) {
    //   await fetchCurrentUser(context, type, phoneNumber, password);
    //   await fetchUserLicence(context, type);
    //   NavigationService.instance.replaceScreen(
    //     HomePageView(
    //       currentUser: currentUser!,
    //     ),
    //   );
    //   dispose();
    // } else {
    NavigationService.instance.replaceScreen(const LoginView());
    // dispose();
    // }
  }

  // Future<void> fetchCurrentUser(BuildContext context, String type,
  //     String phoneNumber, String password) async {
  //   final obtainedUserList = await SevkiyatvarService.instance
  //       .userLogin(type, phoneNumber, password);
  //   currentUser = obtainedUserList.first;
  //   final appState = Provider.of<AppState>(context, listen: false);
  //   appState.updateCurrentUser(currentUser!);
  // }

  // Future<void> fetchUserLicence(BuildContext context, String type) async {
  //   if (type == UserTypeEnum.driverType.value) {
  //     final obtainedLicenceList =
  //         await SevkiyatvarService.instance.checkLicence(currentUser!);
  //     userLicence = obtainedLicenceList.first;
  //     final appState = Provider.of<AppState>(context, listen: false);
  //     appState.updateUserLicence(userLicence!);
  //   }
  // }

  // @override
  // void dispose() {
  //   debugPrint('SplashViewModel disposed');
  //   super.dispose();
  // }
}
