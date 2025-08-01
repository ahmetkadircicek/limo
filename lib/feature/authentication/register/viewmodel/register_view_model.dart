import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:soforvarcom/core/enums/field_error_enum.dart';
import 'package:soforvarcom/core/enums/success_message_enum.dart';
import 'package:soforvarcom/shared/general_dialog.dart';

class RegisterViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController emailConfirmController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;

  String selectedCountryCode = '+90'; // Default to Turkey
  bool acceptTerms = false;

  RegisterViewModel(BuildContext context) {
    print('RegisterViewModel created');
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    emailConfirmController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  /// Updates the selected country code when user selects a different country
  void onCountryCodeChanged(CountryCode countryCode) {
    selectedCountryCode = countryCode.dialCode ?? '+90';
    notifyListeners();
  }

  /// Updates the accept terms checkbox
  void onAcceptTermsChanged(bool? value) {
    acceptTerms = value ?? false;
    notifyListeners();
  }

  /// Returns the full phone number with country code
  String get fullPhoneNumber {
    String phoneDigits =
        phoneNumberController.text.replaceAll(RegExp(r'\D'), '');
    return '$selectedCountryCode$phoneDigits';
  }

  /// Validates if email and email confirmation match (no error message displayed)
  String? validateEmailConfirmation(String? value) {
    // Validation logic remains but no error message is shown
    if (value == null || value.isEmpty) {
      debugPrint('Validation: Email confirmation is empty');
      return null; // Don't show error message
    }
    if (value != emailController.text) {
      debugPrint('Validation: Emails do not match');
      return null; // Don't show error message
    }
    return null;
  }

  /// Validates if password and password confirmation match (no error message displayed)
  String? validatePasswordConfirmation(String? value) {
    // Validation logic remains but no error message is shown
    if (value == null || value.isEmpty) {
      debugPrint('Validation: Password confirmation is empty');
      return null; // Don't show error message
    }
    if (value != passwordController.text) {
      debugPrint('Validation: Passwords do not match');
      return null; // Don't show error message
    }
    return null;
  }

  /// Validates email format (no error message displayed)
  String? validateEmail(String? value) {
    // Validation logic remains but no error message is shown
    if (value == null || value.isEmpty) {
      debugPrint('Validation: Email is empty');
      return null; // Don't show error message
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      debugPrint('Validation: Invalid email format');
      return null; // Don't show error message
    }
    return null;
  }

  /// Validates full name (no error message displayed)
  String? validateFullName(String? value) {
    // Validation logic remains but no error message is shown
    if (value == null || value.isEmpty) {
      debugPrint('Validation: Full name is empty');
      return null; // Don't show error message
    }
    if (value.trim().length < 2) {
      debugPrint('Validation: Full name too short');
      return null; // Don't show error message
    }
    return null;
  }

  /// Validates password strength (no error message displayed)
  String? validatePassword(String? value) {
    // Validation logic remains but no error message is shown
    if (value == null || value.isEmpty) {
      debugPrint('Validation: Password is empty');
      return null; // Don't show error message
    }
    if (value.length < 8) {
      debugPrint('Validation: Password too short');
      return null; // Don't show error message
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      debugPrint('Validation: Password doesn\'t meet strength requirements');
      return null; // Don't show error message
    }
    return null;
  }

  /// Validates if terms are accepted
  String? validateTermsAcceptance() {
    if (!acceptTerms) {
      return 'You must accept the terms and conditions';
    }
    return null;
  }

  /// Registers the user with professional dialog validation
  Future<bool> registerUser(BuildContext context) async {
    // Manual validation without showing error messages
    String fullName = fullNameController.text.trim();
    String fullPhoneNumber = this.fullPhoneNumber;
    String email = emailController.text.trim();
    String emailConfirm = emailConfirmController.text.trim();
    String password = passwordController.text;
    String passwordConfirm = passwordConfirmController.text;

    // Validate all fields manually with proper enum messages
    FieldError? validationError;

    if (fullName.isEmpty || fullName.length < 2) {
      validationError = FieldError.emptyFullName;
    } else if (fullPhoneNumber.length < 10) {
      validationError = FieldError.emptyPhoneNumber;
    } else if (email.isEmpty) {
      validationError = FieldError.emptyEmail;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      validationError = FieldError.invalidEmail;
    } else if (emailConfirm.isEmpty) {
      validationError = FieldError.emptyEmailConfirm;
    } else if (emailConfirm != email) {
      validationError = FieldError.emailsNotMatch;
    } else if (password.isEmpty) {
      validationError = FieldError.emptyPassword;
    } else if (password.length < 8 ||
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      validationError = FieldError.invalidPassword;
    } else if (passwordConfirm.isEmpty) {
      validationError = FieldError.emptyRepassword;
    } else if (passwordConfirm != password) {
      validationError = FieldError.passwordsNotMatch;
    } else if (!acceptTerms) {
      validationError = FieldError.termsNotAccepted;
    }

    if (validationError != null) {
      // Show error dialog with predefined styling
      context.showErrorDialog(message: validationError.message);
      return false;
    }

    // Debug print to show the registration data
    debugPrint('Registration Data:');
    debugPrint('Full Name: $fullName');
    debugPrint('Full Phone Number: $fullPhoneNumber');
    debugPrint('Email: $email');
    debugPrint('Password: $password');
    debugPrint('Accept Terms: $acceptTerms');

    // TODO: Implement actual registration logic here
    // await registerUserToServer(context, fullName, fullPhoneNumber, email, password);

    // Show success dialog with predefined styling
    context.showSuccessDialog(
      message: SuccessMessageEnum.registerSuccess.successMessage,
    );

    return true;
  }

  @override
  void dispose() {
    print('RegisterViewModel disposed');
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    emailConfirmController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }
}
