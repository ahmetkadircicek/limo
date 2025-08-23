import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

/// AppBar variants for different page types
enum AppBarVariant {
  /// Main app bar with logo and menu for primary pages
  primary,

  /// Standard app bar with title for secondary pages
  secondary,

  /// Top bar with logo and menu for home page
  home,
}

/// Unified AppBar component with different variants
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarVariant variant;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onMenuTap;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double elevation;

  const AppAppBar.primary({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation = 0,
  }) : variant = AppBarVariant.primary,
       onMenuTap = null;

  const AppAppBar.secondary({super.key, this.title, this.actions})
    : variant = AppBarVariant.secondary,
      leading = null,
      onMenuTap = null,
      automaticallyImplyLeading = true,
      backgroundColor = null,
      elevation = 0;

  const AppAppBar.home({super.key, this.onMenuTap})
    : variant = AppBarVariant.home,
      title = null,
      actions = null,
      leading = null,
      automaticallyImplyLeading = true,
      backgroundColor = null,
      elevation = 0;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppBarVariant.primary:
        return _buildPrimaryAppBar(context);
      case AppBarVariant.secondary:
        return _buildSecondaryAppBar(context);
      case AppBarVariant.home:
        return _buildHomeAppBar(context);
    }
  }

  Widget _buildPrimaryAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          backgroundColor: (backgroundColor ?? context.surface).withValues(
            alpha: 0.8,
          ),
          elevation: elevation,
          title:
              title != null
                  ? AppText.heading(title!, color: context.onSurface)
                  : null,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          actions: actions,
        ),
      ),
    );
  }

  Widget _buildSecondaryAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          backgroundColor: context.surface.withValues(alpha: 0.8),
          elevation: 0,
          title:
              title != null
                  ? AppText.heading(title!, color: context.onSurface)
                  : null,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: actions,
        ),
      ),
    );
  }

  Widget _buildHomeAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: context.surface.withValues(alpha: 0.8),
            boxShadow: context.shadowLarge,
          ),
          child: SafeArea(
            child: Container(
              height: kToolbarHeight,
              padding: context.horizontalL,
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
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
