import 'package:flutter/material.dart';
import 'package:limo/shared/constants/icon_constants.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class DrawerItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const DrawerItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = context.onSurface;

    return Container(
      padding: PaddingConstants.all16,
      child: InkWell(
        onTap: onTap,
        child: Row(
          spacing: PaddingConstants.p8,
          children: [
            Icon(icon, size: IconConstants.medium, color: onSurface),
            Text(title, style: context.subhead.copyWith(color: onSurface)),
          ],
        ),
      ),
    );
  }
}
