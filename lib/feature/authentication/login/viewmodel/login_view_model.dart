import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:soforvarcom/core/enums/login_error_enum.dart';
import 'package:soforvarcom/core/enums/success_message_enum.dart';
import 'package:soforvarcom/shared/general_dialog.dart';

class LoginViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController forgetPasswordPhoneController;

  String selectedCountryCode = '+90'; // Default to Turkey

  // UserModel? currentUser;
  // LicenceModel? userLicence;

  LoginViewModel(BuildContext context) {
    print('LoginViewModel created');
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    forgetPasswordPhoneController = TextEditingController();
  }

  /// Updates the selected country code when user selects a different country
  void onCountryCodeChanged(CountryCode countryCode) {
    selectedCountryCode = countryCode.dialCode ?? '+90';
    notifyListeners();
  }

  /// Returns the full phone number with country code
  String get fullPhoneNumber {
    String phoneDigits =
        phoneNumberController.text.replaceAll(RegExp(r'\D'), '');
    return '$selectedCountryCode$phoneDigits';
  }

  /// Login user with professional dialog validation
  Future<bool> loginUser(BuildContext context) async {
    String fullPhoneNumber = this.fullPhoneNumber;
    String password = passwordController.text;

    // Validate inputs with proper error handling
    LoginErrorEnum? validationError;

    if (fullPhoneNumber.isEmpty && password.isEmpty) {
      validationError = LoginErrorEnum.invalidData;
    } else if (fullPhoneNumber.isEmpty || fullPhoneNumber.length < 10) {
      validationError = LoginErrorEnum.emptyPhoneNumber;
    } else if (fullPhoneNumber.length < 11) {
      validationError = LoginErrorEnum.invalidPhoneNumber;
    } else if (password.isEmpty) {
      validationError = LoginErrorEnum.emptyPassword;
    } else if (password.length > 16) {
      validationError = LoginErrorEnum.invalidPassword;
    }

    if (validationError != null) {
      // Show error dialog with predefined styling
      context.showErrorDialog(
        title: 'Login Error!',
        message: validationError.errorMessage,
      );
      return false;
    }

    // Debug print to show the login data
    debugPrint('Login Data:');
    debugPrint('Full Phone Number: $fullPhoneNumber');
    debugPrint('Password: $password');

    // TODO: Implement actual login logic here
    // try {
    //   await fetchCurrentUser(context, fullPhoneNumber, password);
    //   // Show success and navigate
    //   context.showGeneralDialog(
    //     title: 'Başarılı!',
    //     message: SuccessMessageEnum.loginSuccess.successMessage,
    //     alertType: AlertType.success,
    //   );
    //   return true;
    // } catch (e) {
    //   context.showGeneralDialog(
    //     title: 'Giriş Hatası!',
    //     message: LoginErrorEnum.userNotFound.errorMessage,
    //     alertType: AlertType.error,
    //   );
    //   return false;
    // }

    // For demo purposes, show success dialog
    context.showSuccessDialog(
      message: SuccessMessageEnum.loginSuccess.successMessage,
    );

    return true;
  }

  // Future<void> fetchCurrentUser(BuildContext context, String type,
  //     String phoneNumber, String password) async {
  //   final obtainedUserList = await SevkiyatvarService.instance
  //       .userLogin(type, phoneNumber, password);
  //   currentUser = obtainedUserList.first;
  //   final appState = Provider.of<AppState>(context, listen: false);
  //   appState.updateCurrentUser(currentUser!);
  // }

  // Future<void> fetchUserLicence(BuildContext context) async {
  //   final obtainedLicenceList =
  //       await SevkiyatvarService.instance.checkLicence(currentUser!);
  //   userLicence = obtainedLicenceList.first;
  //   final appState = Provider.of<AppState>(context, listen: false);
  //   if (currentUser!.userClass == UserTypeEnum.driverTypeName.value) {
  //     appState.updateUserLicence(userLicence!);
  //   }
  // }

  // void showForgetPasswordDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => ForgetPasswordDialog(
  //       title: 'Kayıtlı telefon numaranızı giriniz!',
  //       alertType: AlertType.confirmation,
  //       controller: forgetPasswordPhoneController,
  //       action: 'GÖNDER',
  //       onPressed: () {},
  //     ),
  //   );
  // }

  // void showLoginErrorDialog(BuildContext context, LoginErrorEnum error) {
  //   String errorMessage;

  //   switch (error) {
  //     case LoginErrorEnum.invalidPhoneNumber:
  //       errorMessage = LoginErrorEnum.invalidPhoneNumber.errorMessage;
  //       break;
  //     case LoginErrorEnum.invalidPassword:
  //       errorMessage = LoginErrorEnum.invalidPassword.errorMessage;
  //       break;
  //     case LoginErrorEnum.emptyPassword:
  //       errorMessage = LoginErrorEnum.emptyPassword.errorMessage;
  //       break;
  //     case LoginErrorEnum.emptyPhoneNumber:
  //       errorMessage = LoginErrorEnum.emptyPhoneNumber.errorMessage;
  //       break;
  //     case LoginErrorEnum.invalidData:
  //       errorMessage = LoginErrorEnum.invalidData.errorMessage;
  //       break;
  //     case LoginErrorEnum.userNotFound:
  //       errorMessage = LoginErrorEnum.userNotFound.errorMessage;
  //       break;
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => GeneralDialog(
  //       title: 'Bir hata ile karşılaşıldı!',
  //       message: errorMessage,
  //       alertType: AlertType.error,
  //       action: '',
  //     ),
  //   );
  // }

  /// Show forget password dialog with professional styling
  void showForgetPasswordDialog(BuildContext context) {
    context.showConfirmationDialog(
      title: 'Reset Password',
      message: 'Please enter your registered phone number!',
      actionText: 'SEND',
      onConfirm: () {
        // TODO: Implement forget password logic
        debugPrint(
            'Forget password for: ${forgetPasswordPhoneController.text}');
        context.showInfoDialog(
          message: 'Password reset link has been sent to your phone number.',
        );
      },
    );
  }

  @override
  void dispose() {
    print('LoginViewModel disposed');
    phoneNumberController.dispose();
    passwordController.dispose();
    forgetPasswordPhoneController.dispose();
    super.dispose();
  }
}
