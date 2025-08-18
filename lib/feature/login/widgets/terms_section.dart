import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_components.dart';

/// Terms and privacy section widget for login view
class TermsSection extends StatelessWidget {
  const TermsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalL,
      child: Column(
        children: [
          _buildTermsText(context),
          SizedBox(height: context.spacingM),
          _buildTermsButtons(context),
        ],
      ),
    );
  }

  /// Builds the terms acceptance text
  Widget _buildTermsText(BuildContext context) {
    return AppText.caption(
      'By continuing, you accept the Terms of Service and Privacy Policy.',
      color: context.onPrimary.withValues(alpha: 0.7),
      textAlign: TextAlign.center,
      maxLines: 3,
    );
  }

  /// Builds the terms and privacy policy buttons
  Widget _buildTermsButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTermsButton(context),
        _buildDivider(context),
        _buildPrivacyButton(context),
      ],
    );
  }

  /// Builds the Terms of Service button
  Widget _buildTermsButton(BuildContext context) {
    return TextButton(
      onPressed: () => _showTermsSnackbar(context),
      child: AppText.caption('Terms of Service', color: context.onPrimary),
    );
  }

  /// Builds the visual divider between buttons
  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 12,
      color: context.onPrimary.withValues(alpha: 0.3),
    );
  }

  /// Builds the Privacy Policy button
  Widget _buildPrivacyButton(BuildContext context) {
    return TextButton(
      onPressed: () => _showPrivacySnackbar(context),
      child: AppText.caption('Privacy Policy', color: context.onPrimary),
    );
  }

  /// Shows Terms of Service information via snackbar
  void _showTermsSnackbar(BuildContext context) {
    AppSnackbar.showInfo(
      context,
      message: 'Terms of Service will be available soon.',
    );
  }

  /// Shows Privacy Policy information via snackbar
  void _showPrivacySnackbar(BuildContext context) {
    AppSnackbar.showInfo(
      context,
      message: 'Privacy Policy will be available soon.',
    );
  }
}
