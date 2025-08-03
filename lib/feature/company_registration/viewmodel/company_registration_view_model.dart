import 'package:flutter/material.dart';
import 'package:soforvarcom/core/enums/field_error_enum.dart';
import 'package:soforvarcom/core/enums/success_message_enum.dart';
import 'package:soforvarcom/shared/general_dialog.dart';

import '../model/company_model.dart';

class CompanyRegistrationViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  late TextEditingController companyNameController;
  late TextEditingController authorizedPersonController;
  late TextEditingController companyPhoneController;
  late TextEditingController companyEmailController;
  late TextEditingController taxNumberController;
  late TextEditingController companyAddressController;

  CompanyRegistrationViewModel(BuildContext context) {
    debugPrint('CompanyRegistrationViewModel created');
    companyNameController = TextEditingController();
    authorizedPersonController = TextEditingController();
    companyPhoneController = TextEditingController();
    companyEmailController = TextEditingController();
    taxNumberController = TextEditingController();
    companyAddressController = TextEditingController();
  }

  /// Validates company name field
  String? validateCompanyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerCompany method
    }
    if (value.trim().length < 2) {
      return 'Company name must be at least 2 characters';
    }
    return null;
  }

  /// Validates authorized person field
  String? validateAuthorizedPerson(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerCompany method
    }
    if (value.trim().length < 2) {
      return 'Authorized person must be at least 2 characters';
    }
    return null;
  }

  /// Validates company phone field
  String? validateCompanyPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerCompany method
    }
    // Simple phone validation - should contain only digits, spaces, +, -, (, )
    final RegExp phoneRegex = RegExp(r'^[\d\s\+\-\(\)]{7,20}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates company email field
  String? validateCompanyEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerCompany method
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates tax number field
  String? validateTaxNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerCompany method
    }
    // Tax number should be numeric and at least 8 digits
    final RegExp taxRegex = RegExp(r'^\d{8,20}$');
    if (!taxRegex.hasMatch(value.trim())) {
      return 'Please enter a valid tax number (8-20 digits)';
    }
    return null;
  }

  /// Validates company address field
  String? validateCompanyAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Will be handled in registerCompany method
    }
    if (value.trim().length < 5) {
      return 'Company address must be at least 5 characters';
    }
    return null;
  }

  /// Registers the company with professional dialog validation
  Future<bool> registerCompany(BuildContext context) async {
    // Get values
    String companyName = companyNameController.text.trim();
    String authorizedPerson = authorizedPersonController.text.trim();
    String companyPhone = companyPhoneController.text.trim();
    String companyEmail = companyEmailController.text.trim();
    String taxNumber = taxNumberController.text.trim();
    String companyAddress = companyAddressController.text.trim();

    // Manual validation with proper error messages
    FieldError? validationError;

    if (companyName.isEmpty) {
      validationError = FieldError.emptyCompanyName;
    } else if (companyName.length < 2) {
      validationError = FieldError.invalidCompanyName;
    } else if (authorizedPerson.isEmpty) {
      validationError = FieldError.emptyAuthorizedPerson;
    } else if (authorizedPerson.length < 2) {
      validationError = FieldError.invalidAuthorizedPerson;
    } else if (companyPhone.isEmpty) {
      validationError = FieldError.emptyCompanyPhone;
    } else if (!RegExp(r'^[\d\s\+\-\(\)]{7,20}$').hasMatch(companyPhone)) {
      validationError = FieldError.invalidCompanyPhone;
    } else if (companyEmail.isEmpty) {
      validationError = FieldError.emptyCompanyEmail;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(companyEmail)) {
      validationError = FieldError.invalidCompanyEmail;
    } else if (taxNumber.isEmpty) {
      validationError = FieldError.emptyTaxNumber;
    } else if (!RegExp(r'^\d{8,20}$').hasMatch(taxNumber)) {
      validationError = FieldError.invalidTaxNumber;
    } else if (companyAddress.isEmpty) {
      validationError = FieldError.emptyCompanyAddress;
    } else if (companyAddress.length < 5) {
      validationError = FieldError.invalidCompanyAddress;
    }

    if (validationError != null) {
      // Show error dialog
      context.showErrorDialog(message: validationError.message);
      return false;
    }

    // Create company model
    final company = CompanyModel(
      companyName: companyName,
      authorizedPerson: authorizedPerson,
      companyPhone: companyPhone,
      companyEmail: companyEmail,
      taxNumber: taxNumber,
      companyAddress: companyAddress,
    );

    // Debug print company data
    debugPrint('Company Registration Data:');
    debugPrint('Company Name: ${company.companyName}');
    debugPrint('Authorized Person: ${company.authorizedPerson}');
    debugPrint('Company Phone: ${company.companyPhone}');
    debugPrint('Company Email: ${company.companyEmail}');
    debugPrint('Tax Number: ${company.taxNumber}');
    debugPrint('Company Address: ${company.companyAddress}');

    // TODO: Implement actual company registration logic here
    // await registerCompanyToServer(context, company);

    // Show success dialog
    context.showSuccessDialog(
      message: SuccessMessageEnum.companyRegisterSuccess.successMessage,
    );

    return true;
  }

  @override
  void dispose() {
    debugPrint('CompanyRegistrationViewModel disposed');
    companyNameController.dispose();
    authorizedPersonController.dispose();
    companyPhoneController.dispose();
    companyEmailController.dispose();
    taxNumberController.dispose();
    companyAddressController.dispose();
    super.dispose();
  }
}
