import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/core/init/navigation/navigation_service.dart';
import 'package:soforvarcom/feature/authentication/register/viewmodel/register_view_model.dart';
import 'package:soforvarcom/feature/vehicle_registration/view/vehicle_registration_view.dart';
import 'package:soforvarcom/shared/elevated_container.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';
import 'package:soforvarcom/shared/phone_number_field.dart';
import 'package:soforvarcom/shared/prefix_text_field.dart';

import '../viewmodel/sliding_form_viewmodel.dart';

class SlidingRegisterForm extends StatefulWidget {
  const SlidingRegisterForm({super.key});

  @override
  State<SlidingRegisterForm> createState() => _SlidingRegisterFormState();
}

class _SlidingRegisterFormState extends State<SlidingRegisterForm>
    with WidgetsBindingObserver {
  SlidingFormViewModel? _slidingViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    // Detect keyboard visibility changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final mediaQuery = MediaQuery.of(context);
        final bottomInset = mediaQuery.viewInsets.bottom;
        final isKeyboardVisible = bottomInset > 100; // Threshold for keyboard

        _slidingViewModel?.onKeyboardVisibilityChanged(isKeyboardVisible);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SlidingFormViewModel()),
      ],
      child: Consumer2<RegisterViewModel, SlidingFormViewModel>(
        builder: (context, registerViewModel, slidingViewModel, child) {
          // Store reference for keyboard detection
          _slidingViewModel = slidingViewModel;
          return GestureDetector(
            onTap: () => slidingViewModel.onOutsideTap(),
            onPanUpdate: (details) {
              // Smart gesture detection - respects keyboard state
              if (details.delta.dy < -5) {
                // Swiping UP - force expand (ignore keyboard)
                slidingViewModel.forceExpand();
              } else if (details.delta.dy > 5) {
                // Swiping DOWN - force collapse (ignore keyboard)
                slidingViewModel.forceCollapse();
              }
            },
            child: AnimatedAlign(
              duration: slidingViewModel.animationDuration,
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: slidingViewModel.animationDuration,
                height: context.height * slidingViewModel.formHeightRatio,
                width: double.infinity,
                child: ElevatedContainer(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: PaddingConstants.allMedium,
                      child: Column(
                        children: [
                          _buildTitle(),
                          context.spacerHeight(2),
                          _buildSignupForm(
                              context, registerViewModel, slidingViewModel),
                          context.spacerHeight(3),
                          _buildButtons(
                              context, registerViewModel, slidingViewModel),
                          context.spacerHeight(4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              GeneralText(
                text: 'Create Account',
                fontSize: GeneralConstants.fontSizeLarge,
                fontWeight: GeneralConstants.fontWeightRegular,
              ),
              GeneralText(
                text: 'Sign up to get started.',
                fontSize: GeneralConstants.fontSizeSmall,
                fontWeight: GeneralConstants.fontWeightLight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(
      BuildContext context,
      RegisterViewModel registerViewModel,
      SlidingFormViewModel slidingViewModel) {
    return Form(
      key: registerViewModel.formKey,
      child: Column(
        children: [
          // Full Name field
          _buildFocusableField(
            slidingViewModel,
            GeneralTextField(
              hintText: 'Enter Full Name',
              prefixIcon: const Icon(Icons.person),
              controller: registerViewModel.fullNameController,
              validator: registerViewModel.validateFullName,
            ),
          ),
          context.spacerHeight(1),

          // Phone Number field
          _buildFocusableField(
            slidingViewModel,
            PhoneNumberField(
              hintText: '(555) 123-4567',
              controller: registerViewModel.phoneNumberController,
              onCountryChanged: registerViewModel.onCountryCodeChanged,
              initialCountryCode: 'TR',
            ),
          ),
          context.spacerHeight(1),

          // Email field
          _buildFocusableField(
            slidingViewModel,
            GeneralTextField(
              hintText: 'Enter Email',
              prefixIcon: const Icon(Icons.email),
              controller: registerViewModel.emailController,
              validator: registerViewModel.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          context.spacerHeight(1),

          // Email confirmation field
          _buildFocusableField(
            slidingViewModel,
            GeneralTextField(
              hintText: 'Confirm Email',
              prefixIcon: const Icon(Icons.email_outlined),
              controller: registerViewModel.emailConfirmController,
              validator: registerViewModel.validateEmailConfirmation,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          context.spacerHeight(1),

          // Password field
          _buildFocusableField(
            slidingViewModel,
            PrefixedTextField(
              hintText: 'Enter Password',
              prefixIcon: const Icon(Icons.lock),
              controller: registerViewModel.passwordController,
              validator: registerViewModel.validatePassword,
            ),
          ),
          context.spacerHeight(1),

          // Password confirmation field
          _buildFocusableField(
            slidingViewModel,
            PrefixedTextField(
              hintText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              controller: registerViewModel.passwordConfirmController,
              validator: registerViewModel.validatePasswordConfirmation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusableField(
      SlidingFormViewModel slidingViewModel, Widget field) {
    return Focus(
      onFocusChange: (hasFocus) {
        // Smart focus handling with improved timing
        if (hasFocus) {
          // Delay focus handling to let keyboard events settle
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              slidingViewModel.onFieldFocused();
            }
          });
        } else {
          slidingViewModel.onFieldUnfocused();
        }
      },
      child: field,
    );
  }

  Widget _buildButtons(
      BuildContext context,
      RegisterViewModel registerViewModel,
      SlidingFormViewModel slidingViewModel) {
    return Column(
      children: [
        _buildAcceptTermsButton(registerViewModel),
        context.spacerHeight(1),
        _buildSignUpButton(registerViewModel, slidingViewModel),
        _buildSignInButton(),
      ],
    );
  }

  Widget _buildAcceptTermsButton(RegisterViewModel registerViewModel) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Checkbox(
                value: registerViewModel.acceptTerms,
                onChanged: registerViewModel.onAcceptTermsChanged,
              ),
              Expanded(
                child: GeneralText(
                  text: 'Accept the terms and conditions',
                  fontSize: GeneralConstants.fontSizeSmall,
                  fontWeight: GeneralConstants.fontWeightLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(RegisterViewModel registerViewModel,
      SlidingFormViewModel slidingViewModel) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: GeneralConstants.heightMedium,
          child: GeneralButton(
            fontSize: GeneralConstants.fontSizeMedium,
            color: context.primary,
            text: 'Sign up',
            onPressed: () async {
              bool success = await registerViewModel.registerUser(context);
              if (success) {
                slidingViewModel.onFormSubmitted();
                // Navigate to vehicle registration after successful register
                NavigationService.instance.replaceScreen(
                  const VehicleRegistrationView(),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSignInButton() {
    return Builder(
      builder: (context) {
        return GeneralButton(
          fontSize: GeneralConstants.fontSizeSmall,
          color: context.surface,
          fontColor: context.secondary,
          text: 'Already have an account? Sign in',
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
