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

  Widget _buildTermsText(BuildContext context) {
    return AppText.caption(
      'Devam ederek Kullanım Şartları ve Gizlilik Politikası\'nı kabul etmiş olursunuz.',
      color: Colors.white.withValues(alpha: 0.7),
      textAlign: TextAlign.center,
      maxLines: 3,
    );
  }

  Widget _buildTermsButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTermsButton(context),
        _buildDivider(),
        _buildPrivacyButton(context),
      ],
    );
  }

  Widget _buildTermsButton(BuildContext context) {
    return TextButton(
      onPressed: () => _showTermsDialog(context),
      child: AppText.caption(
        'Kullanım Şartları',
        color: Colors.white,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 12,
      color: Colors.white.withValues(alpha: 0.18),
    );
  }

  Widget _buildPrivacyButton(BuildContext context) {
    return TextButton(
      onPressed: () => _showPrivacyDialog(context),
      child: AppText.caption(
        'Gizlilik Politikası',
        color: Colors.white,
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: AppText.title('Kullanım Şartları', color: Colors.white),
        content: AppText.body(
          'Kullanım şartları burada gösterilecek...',
          color: Colors.white,
        ),
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
        content: AppText.body(
          'Gizlilik politikası burada gösterilecek...',
          color: Colors.white,
        ),
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
