import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:limo/core/constants/image_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/login/viewmodel/login_view_model.dart';
import 'package:limo/shared/app_components.dart';
import 'package:provider/provider.dart';

/// Modern OAuth-only Login Screen
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: const _LoginViewBody(),
    );
  }
}

class _LoginViewBody extends StatelessWidget {
  const _LoginViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // koyu arkaplan
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with blur and overlay
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  ImageConstants.imageLogin,
                  fit: BoxFit.cover,
                ),
                // Blur effect (daha az blur)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color:
                          Colors.black.withOpacity(0.45), // daha koyu overlay
                    ),
                  ),
                ),
                // Ekstra koyu overlay
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ),
          // Foreground content with SafeArea and padding
          SafeArea(
            child: Padding(
              padding: context.responsivePadding,
              child: Column(
                children: [
                  // Top spacing
                  SizedBox(height: context.spacingXxxl),

                  // Logo Section
                  const _LogoSection(),

                  // Spacer to center content
                  const Spacer(),

                  // OAuth Buttons Section
                  const _OAuthButtonsSection(),

                  SizedBox(height: context.spacingL),

                  // Terms Section
                  const _TermsSection(),

                  // Bottom spacing with navigation bar padding
                  const SizedBox(
                      height:
                          112), // Added 80px bottom padding for navigation bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo and Welcome Section
class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo
        ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Colors
                .white, // Login sayfasında beyaz arka plan üzerinde beyaz logo
            BlendMode.srcIn,
          ),
          child: Image.asset(
            'assets/png/image/image_logo.png',
            width: context.width * 0.7,
            fit: BoxFit.cover,
          ),
        ),

        SizedBox(height: context.spacingM),

        // Welcome Message
        AppText.body(
          'Hızlı ve güvenli yolculuklar sizi bekliyor.',
          color: Colors.white.withOpacity(0.85),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}

/// OAuth Authentication Buttons
class _OAuthButtonsSection extends StatelessWidget {
  const _OAuthButtonsSection();

  static const Color _googleBrandColor = Color(0xFFEA4335); // Google Red
  static const Color _googleTextColor = Color(0xFFFFFFFF); // Google text
  static const Color _appleBrandColor = Color(0xFFFFFFFF); // Apple Black
  static const Color _appleTextColor = Color(0xFF000000); // Apple White

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            // Section Title
            AppText.subtitle(
              'Hesabınıza giriş yapın',
              color: Colors.white, // beyaz
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.spacingXl),

            // Google Sign In Button
            _OAuthButton(
              icon: FontAwesomeIcons.google,
              text: 'Google ile devam et',
              backgroundColor: _googleBrandColor,
              borderColor: _googleBrandColor,
              textColor: _googleTextColor,
              iconColor: Colors.white,
              isLoading: viewModel.isGoogleLoading,
              onPressed: viewModel.signInWithGoogle,
            ),

            SizedBox(height: context.spacingL),

            // Apple Sign In Button
            _OAuthButton(
              icon: FontAwesomeIcons.apple,
              text: 'Apple ile devam et',
              backgroundColor: _appleBrandColor,
              borderColor: _appleBrandColor,
              textColor: _appleTextColor,
              iconColor: _appleTextColor,
              isLoading: viewModel.isAppleLoading,
              onPressed: viewModel.signInWithApple,
            ),

            SizedBox(height: context.spacingXl),

            // Or Divider
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white.withOpacity(0.15),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: context.horizontalL,
                  child: AppText.bodySmall(
                    'VEYA',
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white.withOpacity(0.15),
                    thickness: 1,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacingXl),

            // Guest Access Button
            _OAuthButton(
              icon: Icons.person_outline_rounded,
              text: 'Misafir olarak devam et',
              backgroundColor: Colors.white.withOpacity(0.08),
              borderColor: Colors.white.withOpacity(0.18),
              textColor: Colors.white,
              iconColor: Colors.white.withOpacity(0.85),
              isLoading: viewModel.isGuestLoading,
              onPressed: viewModel.continueAsGuest,
            ),
          ],
        );
      },
    );
  }
}

/// Custom OAuth Button Widget
class _OAuthButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _OAuthButton({
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.buttonHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.radiusMedium,
          boxShadow: context.elevationLow,
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            disabledBackgroundColor: backgroundColor.withOpacity(0.7),
            padding: context.horizontalL,
            shape: RoundedRectangleBorder(
              borderRadius: context.radiusMedium,
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    width: context.iconLarge,
                    height: context.iconLarge,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(iconColor),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      icon,
                      size: context.iconLarge,
                      color: iconColor,
                    ),
                    SizedBox(width: context.spacingM),
                    AppText.body(
                      text,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Terms and Privacy Section
class _TermsSection extends StatelessWidget {
  const _TermsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalL,
      child: Column(
        children: [
          AppText.caption(
            'Devam ederek Kullanım Şartları ve Gizlilik Politikası\'nı kabul etmiş olursunuz.',
            color: Colors.white.withOpacity(0.7), // beyaz ve okunaklı
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          SizedBox(height: context.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => _showTermsDialog(context),
                child: AppText.caption(
                  'Kullanım Şartları',
                  color: Colors.white, // beyaz
                ),
              ),
              Container(
                width: 1,
                height: 12,
                color: Colors.white.withOpacity(0.18),
              ),
              TextButton(
                onPressed: () => _showPrivacyDialog(context),
                child: AppText.caption(
                  'Gizlilik Politikası',
                  color: Colors.white, // beyaz
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: AppText.title('Kullanım Şartları', color: Colors.white),
        content: AppText.body('Kullanım şartları burada gösterilecek...',
            color: Colors.white),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText.body('Kapat', color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: AppText.title('Gizlilik Politikası', color: Colors.white),
        content: AppText.body('Gizlilik politikası burada gösterilecek...',
            color: Colors.white),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText.body('Kapat', color: Colors.white),
          ),
        ],
      ),
    );
  }
}
