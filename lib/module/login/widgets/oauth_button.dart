import 'package:flutter/material.dart';
import 'package:limo/shared/constants/icon_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class OAuthButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final bool isLoading;

  const OAuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 60,
        padding: PaddingConstants.horizontal20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: RadiusConstants.standard,
        ),
        child: Center(
          child:
              isLoading
                  ? const SizedBox(
                    height: IconConstants.medium,
                    width: IconConstants.medium,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: PaddingConstants.p16,
                    children: [
                      Icon(icon, color: textColor, size: IconConstants.small),
                      Text(
                        text,
                        style: context.headline.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
