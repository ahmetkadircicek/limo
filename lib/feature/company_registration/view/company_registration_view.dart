import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

import '../viewmodel/company_registration_view_model.dart';

class CompanyRegistrationView extends StatelessWidget {
  const CompanyRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompanyRegistrationViewModel(),
      child: Scaffold(
        backgroundColor: context.surface,
        appBar: AppTopBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 32, 32,
                112), // Added 80px bottom padding for navigation bar
            child: Consumer<CompanyRegistrationViewModel>(
              builder: (context, viewModel, child) {
                return AppCard.primary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppText.title(
                        'Şirket Kaydı',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      AppInput.primary(
                        labelText: 'Şirket Adı',
                        hintText: 'Şirket adınızı girin',
                        controller: viewModel.companyNameController,
                        prefixIcon: Icons.business_outlined,
                      ),
                      const SizedBox(height: 20),
                      AppInput.primary(
                        labelText: 'Vergi Numarası',
                        hintText: 'Vergi numaranızı girin',
                        controller: viewModel.taxNumberController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.receipt_outlined,
                      ),
                      const SizedBox(height: 20),
                      AppInput.primary(
                        labelText: 'Adres',
                        hintText: 'Şirket adresinizi girin',
                        controller: viewModel.addressController,
                        maxLines: 3,
                        prefixIcon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 20),
                      AppInput.primary(
                        labelText: 'Telefon',
                        hintText: 'Şirket telefon numaranızı girin',
                        controller: viewModel.phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 20),
                      AppInput.primary(
                        labelText: 'E-posta',
                        hintText: 'Şirket e-posta adresinizi girin',
                        controller: viewModel.emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),
                      AppInput.primary(
                        labelText: 'Web Sitesi',
                        hintText: 'Şirket web sitenizi girin (opsiyonel)',
                        controller: viewModel.websiteController,
                        keyboardType: TextInputType.url,
                        prefixIcon: Icons.language_outlined,
                      ),
                      const SizedBox(height: 32),
                      AppButton.primary(
                        'Kaydet',
                        isLoading: viewModel.isLoading,
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                await viewModel.registerCompany(context);
                              },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
