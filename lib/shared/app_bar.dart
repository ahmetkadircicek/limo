import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';

/// Modern unified app bar for the entire application
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final String? title;

  const AppTopBar({
    super.key,
    this.onMenuTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Sol tarafta logo
              Positioned(
                left: 0,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    context.onSurface, // Yüzey rengine göre logo rengi
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
              // Sağda hamburger menü
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
