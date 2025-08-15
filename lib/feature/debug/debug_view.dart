import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_bar.dart';
import 'package:limo/shared/app_button.dart';
import 'package:limo/shared/app_card.dart';
import 'package:limo/shared/app_dialog.dart';
import 'package:limo/shared/app_input.dart';
import 'package:limo/shared/app_snackbar.dart';
import 'package:limo/shared/app_text.dart';

class DebugView extends StatefulWidget {
  const DebugView({super.key});

  @override
  State<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  final TextEditingController _inputController = TextEditingController();
  String _dropdownValue = 'Option 1';
  final List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Debug - App Components',
        showBackButton: true,
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: context.paddingL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Typography - AppText'),
            _buildTypographySection(),

            const SizedBox(height: 32),
            _buildSectionHeader('Buttons - AppButton'),
            _buildButtonSection(),

            const SizedBox(height: 32),
            _buildSectionHeader('Inputs - AppInput'),
            _buildInputSection(),

            const SizedBox(height: 32),
            _buildSectionHeader('Cards - AppCard'),
            _buildCardSection(),

            const SizedBox(height: 32),
            _buildSectionHeader('Snackbars - AppSnackbar'),
            _buildSnackbarSection(),

            const SizedBox(height: 32),
            _buildSectionHeader('Dialogs - AppDialog'),
            _buildDialogSection(),

            const SizedBox(height: 32),
            _buildSectionHeader('App Bar - AppTopBar'),
            _buildAppBarSection(),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AppText.title(
        title,
        color: context.primary,
      ),
    );
  }

  Widget _buildTypographySection() {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.displayXL('Display XL Text'),
          const SizedBox(height: 8),
          AppText.title('Title Text'),
          const SizedBox(height: 8),
          AppText.subtitle('Subtitle Text'),
          const SizedBox(height: 8),
          AppText.heading('Heading Text'),
          const SizedBox(height: 8),
          AppText.body(
              'Body Text - This is the standard body text used throughout the app'),
          const SizedBox(height: 8),
          AppText.bodySmall(
              'Body Small Text - Smaller body text for secondary information'),
          const SizedBox(height: 8),
          AppText.caption('Caption Text - Used for labels and small details'),
        ],
      ),
    );
  }

  Widget _buildButtonSection() {
    return Column(
      children: [
        // Primary buttons
        AppCard.primary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Primary Buttons'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  AppButton.primary('Primary Button', onPressed: () {}),
                  AppButton.primary('With Icon',
                      icon: Icons.star, onPressed: () {}),
                  AppButton.primary('Loading',
                      isLoading: true, onPressed: () {}),
                  AppButton.primary('Custom Size',
                      width: 200, height: 60, onPressed: () {}),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Secondary buttons
        AppCard.secondary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Secondary Buttons'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  AppButton.secondary('Secondary Button', onPressed: () {}),
                  AppButton.secondary('With Icon',
                      icon: Icons.favorite, onPressed: () {}),
                  AppButton.secondary('Loading',
                      isLoading: true, onPressed: () {}),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tertiary and Error buttons
        AppCard.tertiary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Tertiary & Error Buttons'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  AppButton.tertiary('Tertiary Button', onPressed: () {}),
                  AppButton.tertiary('With Icon',
                      icon: Icons.info, onPressed: () {}),
                  AppButton.error('Error Button', onPressed: () {}),
                  AppButton.error('Error With Icon',
                      icon: Icons.warning, onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        // Primary inputs
        AppCard.primary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Primary Inputs'),
              const SizedBox(height: 16),
              AppInput.primary(
                labelText: 'Primary Input',
                hintText: 'Enter text here...',
                controller: _inputController,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              AppInput.primary(
                labelText: 'Input with Icon',
                hintText: 'Tap icon to clear',
                suffixIcon: Icons.clear,
                controller: _inputController,
                onSuffixIconTap: () => _inputController.clear(),
              ),
              const SizedBox(height: 16),
              AppInput.primary(
                labelText: 'Password Input',
                hintText: 'Enter password',
                obscureText: true,
                suffixIcon: Icons.visibility,
                controller: _inputController,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Secondary inputs
        AppCard.secondary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Secondary Inputs'),
              const SizedBox(height: 16),
              AppInput.secondary(
                labelText: 'Secondary Input',
                hintText: 'Secondary style input',
                controller: _inputController,
              ),
              const SizedBox(height: 16),
              AppInput.secondary(
                labelText: 'Email Input',
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                controller: _inputController,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Tertiary inputs and dropdowns
        AppCard.tertiary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Tertiary Inputs & Dropdowns'),
              const SizedBox(height: 16),
              AppInput.tertiary(
                labelText: 'Tertiary Input',
                hintText: 'Tertiary style input',
                controller: _inputController,
              ),
              const SizedBox(height: 16),
              AppInput(
                labelText: 'Dropdown Input',
                isDropdown: true,
                dropdownItems: _dropdownItems,
                dropdownValue: _dropdownValue,
                onDropdownChanged: (value) {
                  setState(() {
                    _dropdownValue = value ?? 'Option 1';
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardSection() {
    return Column(
      children: [
        AppCard.primary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Primary Card'),
              AppText.body(
                  'This is a primary card with white background and shadow'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard.secondary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Secondary Card'),
              AppText.body(
                  'This is a secondary card with light gray background and border'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard.tertiary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Tertiary Card'),
              AppText.body(
                  'This is a tertiary card with subtle tint background'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard.primary(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Card tapped!')),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.heading('Tappable Card'),
              AppText.body('Tap this card to see an interaction'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.touch_app, color: context.primary, size: 20),
                  const SizedBox(width: 8),
                  AppText.caption('Tap me!'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppInfoCard(
          icon: Icons.info_outline,
          label: 'Status',
          value: 'Active',
          iconColor: context.success,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Info card tapped!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSnackbarSection() {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.heading('Snackbar Examples'),
          AppText.body('Tap the buttons below to see different snackbar types'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton.primary(
                'Success Snackbar',
                onPressed: () => context.showSuccessTopSnackbar(
                    'Operation completed successfully!'),
              ),
              AppButton.primary(
                'Error Snackbar',
                onPressed: () =>
                    context.showErrorTopSnackbar('Something went wrong!'),
              ),
              AppButton.primary(
                'Info Snackbar',
                onPressed: () => context
                    .showInfoTopSnackbar('Here is some information for you'),
              ),
              AppButton.primary(
                'Warning Snackbar',
                onPressed: () => context.showWarningTopSnackbar(
                    'Please be careful with this action'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogSection() {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.heading('Dialog Examples'),
          AppText.body('Tap the buttons below to see different dialog types'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton.primary(
                'Success Dialog',
                onPressed: () => context.showSuccessDialog(
                    'Your action was completed successfully!'),
              ),
              AppButton.primary(
                'Error Dialog',
                onPressed: () => context.showErrorDialog(
                    'An error occurred while processing your request'),
              ),
              AppButton.primary(
                'Info Dialog',
                onPressed: () => AppDialogExtension.showInfo(
                  context,
                  'Information',
                  'This is an informational dialog with custom title and message',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarSection() {
    return AppCard.primary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.heading('App Bar Examples'),
          AppText.body(
              'The app bar above demonstrates the AppTopBar component'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: context.onSurface.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: context.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText.body(
                    'The AppTopBar above shows the logo on the left, title in center, and menu button on the right. It automatically adapts to the app\'s theme.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
