import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';

/// Modern unified app bar for the entire application
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;

  const AppTopBar({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        boxShadow: DesignTokens.elevationLow,
      ),
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  context.onSurface,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/png/image/image_logo.png',
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  onPressed: onMenuTap,
                  icon: Icon(Icons.menu, color: context.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
