import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/image_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/authentication/register/view/register_view.dart';
import 'package:soforvarcom/shared/elevated_container.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_text.dart';
import 'package:soforvarcom/shared/general_text_field.dart';
import 'package:soforvarcom/shared/prefix_text_field.dart';

import '../viewmodel/login_view_model.dart';

final class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the LoginViewModel to the widget tree
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(context),
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(context),
            _buildBottomCard(),
          ],
        ),
      ),
    );
  }
}

// Builds the bottom card containing the login form and buttons
Widget _buildBottomCard() {
  return Consumer<LoginViewModel>(
    builder: (context, loginViewModel, child) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedContainer(
          child: SingleChildScrollView(
            child: Padding(
              padding: PaddingConstants.allMedium,
              child: Column(
                children: [
                  _buildTitle(),
                  context.spacerHeight(2),
                  _buildLoginForm(),
                  context.spacerHeight(4),
                  _buildButtons(),
                  context.spacerHeight(4),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// Builds the buttons for login and navigation
Widget _buildButtons() {
  return Builder(
    builder: (context) {
      final loginViewModel = context.read<LoginViewModel>();
      return Column(
        children: [
          _buildForgotPasswordButton(context, loginViewModel),
          context.spacerHeight(1),
          _buildSignInButton(context, loginViewModel),
          _buildSignUpButton(context),
        ],
      );
    },
  );
}

// Builds the "Forgot Password?" button
Widget _buildForgotPasswordButton(
    BuildContext context, LoginViewModel loginViewModel) {
  return Row(
    children: [
      Expanded(
        child: Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
            ),
            GeneralText(
              text: 'Remember me',
              fontSize: GeneralConstants.fontSizeSmall,
              fontWeight: GeneralConstants.fontWeightLight,
            ),
          ],
        ),
      ),
      Expanded(
        child: GeneralButton(
          fontSize: GeneralConstants.fontSizeSmall,
          onPressed: () {
            loginViewModel.showForgetPasswordDialog(context);
          },
          color: context.surface,
          fontColor: context.primary,
          text: 'Forgot Password?',
        ),
      ),
    ],
  );
}

// Builds the "Sign in" button
Widget _buildSignInButton(BuildContext context, LoginViewModel loginViewModel) {
  return SizedBox(
    width: double.infinity,
    height: GeneralConstants.heightMedium,
    child: GeneralButton(
      fontSize: GeneralConstants.fontSizeMedium,
      color: context.primary,
      text: 'Sign in',
      onPressed: () async {
        // Use the new professional dialog-based validation
        bool success = await loginViewModel.loginUser(context);
        if (success) {
          // TODO: Navigate to home page or handle successful login
          debugPrint('Login successful, should navigate now');
        }
      },
    ),
  );
}

// Builds the "Don't have an account? Sign up" button
Widget _buildSignUpButton(BuildContext context) {
  return GeneralButton(
    fontSize: GeneralConstants.fontSizeSmall,
    color: context.surface,
    fontColor: context.secondary,
    text: 'Don\'t have an account? Sign up',
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterView(),
        ),
      );
    },
  );
}

// Builds the login form with input fields
Widget _buildLoginForm() {
  return Builder(
    builder: (context) {
      final loginViewModel = context.read<LoginViewModel>();
      return Form(
        key: loginViewModel.formKey,
        child: Column(
          children: [
            GeneralTextField(
              hintText: 'Enter your email address',
              prefixIcon: const Icon(Icons.email),
              controller: loginViewModel.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            context.spacerHeight(1),
            PrefixedTextField(
              hintText: 'Enter Password',
              prefixIcon: const Icon(Icons.lock),
              controller: loginViewModel.passwordController,
            ),
          ],
        ),
      );
    },
  );
}

// Builds the title section of the login view
Widget _buildTitle() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Expanded(
        flex: 8,
        child: Column(
          children: [
            GeneralText(
              text: 'Welcome',
              fontSize: GeneralConstants.fontSizeLarge,
              fontWeight: GeneralConstants.fontWeightRegular,
            ),
            GeneralText(
              text: 'Sign in to proceed.',
              fontSize: GeneralConstants.fontSizeSmall,
              fontWeight: GeneralConstants.fontWeightLight,
            ),
          ],
        ),
      ),
    ],
  );
}

// Builds the background of the login view
Widget _buildBackground(BuildContext context) {
  return SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(
            width: context.width * 0.8,
            child: Image.asset(
              ImageConstants.imageSoforvarcom,
              fit: BoxFit.cover,
            ),
          ),
          context.spacerHeight(2),
          SizedBox(
            child: Image.asset(
              width: context.width * 0.7,
              ImageConstants.imageOnboard,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    ),
  );
}
