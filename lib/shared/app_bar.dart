import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

/// Modern unified app bar for the entire application
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const AppTopBar({
    super.key,
    this.onMenuTap,
    this.title,
    this.showBackButton = false,
    this.onBackTap,
  });

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
              // Left side: back button or logo
              Positioned(
                left: 0,
                child: showBackButton
                    ? IconButton(
                        onPressed: onBackTap,
                        icon: Icon(
                          Icons.arrow_back,
                          color: context.onSurface,
                          size: 24,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                        ),
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          context.onSurface, // Logo color based on surface color
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/png/image/image_logo.png',
                          height: 40,
                          width: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              // Center: title
                              if (title != null)
                  Positioned(
                    child: AppText.heading(
                      title!,
                      color: context.onSurface,
                    ),
                  ),
              // Right side: hamburger menu
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: onMenuTap,
                  icon: Icon(
                    Icons.menu,
                    color: context.onSurface,
                    size: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
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
