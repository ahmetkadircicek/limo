import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/enums/alert_type_enum.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/core/extensions/string_extension.dart';
import 'package:soforvarcom/core/init/navigation/navigation_service.dart';
import 'package:soforvarcom/shared/general_button.dart';
import 'package:soforvarcom/shared/general_text.dart';

class GeneralDialog extends StatelessWidget {
  final String title;
  final String? message;
  final String? action;
  final AlertType alertType;
  final VoidCallback? onPressed;

  const GeneralDialog({
    super.key,
    required this.title,
    this.message,
    required this.alertType,
    this.action,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding:
                PaddingConstants.allMedium + PaddingConstants.onlyTopMedium,
            margin: PaddingConstants.symmetricHorizontalSmall,
            decoration: BoxDecoration(
              color: context.surfaceContainer,
              borderRadius: GeneralConstants.borderRadius,
            ),
            child: Padding(
              padding: PaddingConstants.symmetricHorizontalSmall,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  context.spacerHeight(1),
                  GeneralText(
                    text: title,
                    fontSize: GeneralConstants.fontSizeMedium,
                    fontWeight: GeneralConstants.fontWeightBold,
                    textAlign: TextAlign.center,
                  ),
                  context.spacerHeight(1),
                  if (message != null)
                    GeneralText(
                      text: message!,
                      fontSize: GeneralConstants.fontSizeSmall,
                      fontWeight: GeneralConstants.fontWeightLight,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                  context.spacerHeight(2),
                  Row(
                    children: [
                      if (onPressed != null)
                        Expanded(
                          child: GeneralButton(
                            onPressed: () {
                              NavigationService.instance.goBack();
                            },
                            text: 'CLOSE',
                            fontSize: GeneralConstants.fontSizeSmall,
                            fontColor: context.onPrimary,
                            color: AlertUtils.getColor(context, alertType),
                          ),
                        ),
                      if (onPressed != null) context.spacerWidth(2),
                      if (onPressed != null && action != null)
                        Expanded(
                          child: GeneralButton(
                            onPressed: onPressed,
                            text: action!.toUpperCaseTr(),
                            fontSize: GeneralConstants.fontSizeSmall,
                            fontColor: context.onPrimary,
                            color: AlertUtils.getColor(context, alertType),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -GeneralConstants.heightExtraSmall,
            child: Container(
              width: GeneralConstants.heightExtraLarge,
              decoration: BoxDecoration(
                color: AlertUtils.getColor(context, alertType),
                borderRadius: GeneralConstants.borderRadius,
              ),
              child: IconButton(
                onPressed: () {
                  NavigationService.instance.goBack();
                },
                icon: Icon(
                  AlertUtils.getIcon(alertType),
                  color: Colors.white,
                  size: GeneralConstants.fontSizeExtraLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper extension for showing dialogs
extension DialogHelper on BuildContext {
  void showGeneralDialog({
    required String title,
    String? message,
    required AlertType alertType,
    String? action,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: this,
      builder: (context) => GeneralDialog(
        title: title,
        message: message,
        alertType: alertType,
        action: action,
        onPressed: onPressed,
      ),
    );
  }

  /// Show error dialog with predefined styling
  void showErrorDialog({
    required String message,
    String title = 'Error!',
  }) {
    showGeneralDialog(
      title: title,
      message: message,
      alertType: AlertType.error,
    );
  }

  /// Show success dialog with predefined styling
  void showSuccessDialog({
    required String message,
    String title = 'Success!',
  }) {
    showGeneralDialog(
      title: title,
      message: message,
      alertType: AlertType.success,
    );
  }

  /// Show confirmation dialog with action
  void showConfirmationDialog({
    required String title,
    required String message,
    required String actionText,
    required VoidCallback onConfirm,
    String cancelText = 'CANCEL',
  }) {
    showGeneralDialog(
      title: title,
      message: message,
      alertType: AlertType.confirmation,
      action: actionText,
      onPressed: onConfirm,
    );
  }

  /// Show warning dialog
  void showWarningDialog({
    required String message,
    String title = 'Warning!',
  }) {
    showGeneralDialog(
      title: title,
      message: message,
      alertType: AlertType.warning,
    );
  }

  /// Show info dialog
  void showInfoDialog({
    required String message,
    String title = 'Information',
  }) {
    showGeneralDialog(
      title: title,
      message: message,
      alertType: AlertType.info,
    );
  }
}
