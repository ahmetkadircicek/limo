import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';

import '../viewmodel/company_registration_view_model.dart';

final class CompanyRegistrationView extends StatelessWidget {
  const CompanyRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompanyRegistrationViewModel(context),
      child: Scaffold(
        body: _buildFullScreenContent(),
      ),
    );
  }
}

// Builds the full screen content
Widget _buildFullScreenContent() {
  return Consumer<CompanyRegistrationViewModel>(
    builder: (context, viewModel, child) {
      return SafeArea(
        child: Padding(
          padding: PaddingConstants.allMedium,
          child: Column(
            children: [
              _buildTitle(),
              context.spacerHeight(1),
              _buildSubtitle(),
              context.spacerHeight(3),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        _buildCompanyForm(viewModel),
                        context.spacerHeight(3),
                        _buildActionButtons(context, viewModel),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Builds the title
Widget _buildTitle() {
  return GeneralText(
    text: 'Company Registration',
    fontSize: GeneralConstants.fontSizeLarge,
    fontWeight: GeneralConstants.fontWeightBold,
  );
}

// Builds the subtitle
Widget _buildSubtitle() {
  return Builder(
    builder: (context) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Fill your company information. ',
              style: TextStyle(
                color: context.secondary,
                fontSize: GeneralConstants.fontSizeSmall,
                fontWeight: GeneralConstants.fontWeightLight,
              ),
            ),
            TextSpan(
              text: 'Continue if you dont have company.',
              style: TextStyle(
                color: context.primary,
                fontSize: GeneralConstants.fontSizeSmall,
                fontWeight: GeneralConstants.fontWeightLight,
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Builds the company registration form
Widget _buildCompanyForm(CompanyRegistrationViewModel viewModel) {
  return Column(
    children: [
      // Company Name
      GeneralTextField(
        controller: viewModel.companyNameController,
        hintText: 'Company Name',
        prefixIcon: const Icon(Icons.business),
        validator: viewModel.validateCompanyName,
      ),
      const SizedBox(height: 16),

      // Authorized Person
      GeneralTextField(
        controller: viewModel.authorizedPersonController,
        hintText: 'Authorized Person',
        prefixIcon: const Icon(Icons.person),
        validator: viewModel.validateAuthorizedPerson,
      ),
      const SizedBox(height: 16),

      // Company Phone
      GeneralTextField(
        controller: viewModel.companyPhoneController,
        hintText: 'Company Phone',
        prefixIcon: const Icon(Icons.phone),
        keyboardType: TextInputType.phone,
        validator: viewModel.validateCompanyPhone,
      ),
      const SizedBox(height: 16),

      // Company Email
      GeneralTextField(
        controller: viewModel.companyEmailController,
        hintText: 'Company Email',
        prefixIcon: const Icon(Icons.email),
        keyboardType: TextInputType.emailAddress,
        validator: viewModel.validateCompanyEmail,
      ),
      const SizedBox(height: 16),

      // Tax Number
      GeneralTextField(
        controller: viewModel.taxNumberController,
        hintText: 'Tax Number',
        prefixIcon: const Icon(Icons.receipt),
        keyboardType: TextInputType.number,
        validator: viewModel.validateTaxNumber,
      ),
      const SizedBox(height: 16),

      // Company Address
      GeneralTextField(
        controller: viewModel.companyAddressController,
        hintText: 'Company Address',
        prefixIcon: const Icon(Icons.location_on),
        validator: viewModel.validateCompanyAddress,
      ),
    ],
  );
}

// Builds the action buttons
Widget _buildActionButtons(
    BuildContext context, CompanyRegistrationViewModel viewModel) {
  return Column(
    children: [
      _buildDoneButton(context, viewModel),
      _buildCancelButton(context),
    ],
  );
}

// Builds the "Done" button
Widget _buildDoneButton(
    BuildContext context, CompanyRegistrationViewModel viewModel) {
  return SizedBox(
    width: double.infinity,
    height: GeneralConstants.heightMedium,
    child: GeneralButton(
      fontSize: GeneralConstants.fontSizeMedium,
      color: context.primary,
      text: 'Done',
      onPressed: () async {
        bool success = await viewModel.registerCompany(context);
        if (success) {
          // TODO: Navigate to home page or main app
          debugPrint(
              'Company registration successful, should navigate to main app');
        }
      },
    ),
  );
}

// Builds the "Cancel" button
Widget _buildCancelButton(BuildContext context) {
  return GeneralButton(
    fontSize: GeneralConstants.fontSizeSmall,
    color: context.surface,
    fontColor: context.secondary,
    text: 'Cancel',
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
