import 'package:flutter/material.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';
import 'package:limo/shared/widgets/app_snackbar.dart';

/// Terms and privacy section widget for login view
class TermsSection extends StatelessWidget {
  const TermsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.horizontal20,
      child: Column(
        spacing: PaddingConstants.p8,
        children: [_buildTermsText(context), _buildTermsButtons(context)],
      ),
    );
  }

  /// Builds the terms acceptance text
  Widget _buildTermsText(BuildContext context) {
    return Text(
      'By continuing, you accept the Terms of Service and Privacy Policy.',
      style: context.subhead.copyWith(color: context.onSurface),
      textAlign: TextAlign.center,
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
      child: Text(
        'Terms of Service',
        style: context.footnote.copyWith(color: context.onSurface),
      ),
    );
  }

  /// Builds the visual divider between buttons
  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      color: context.onPrimary.withValues(alpha: 0.3),
    );
  }

  /// Builds the Privacy Policy button
  Widget _buildPrivacyButton(BuildContext context) {
    return TextButton(
      onPressed: () => _showPrivacySnackbar(context),
      child: Text(
        'Privacy Policy',
        style: context.footnote.copyWith(color: context.onSurface),
      ),
    );
  }

  /// Shows Terms of Service information via snackbar
  void _showTermsSnackbar(BuildContext context) {
    AppSnackbar.info(message: 'Terms of Service will be available soon.');
  }

  /// Shows Privacy Policy information via snackbar
  void _showPrivacySnackbar(BuildContext context) {
    AppSnackbar.info(message: 'Privacy Policy will be available soon.');
  }
}
