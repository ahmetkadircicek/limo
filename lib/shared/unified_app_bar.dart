import 'package:flutter/material.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';

class UnifiedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoTap;

  const UnifiedAppBar({
    super.key,
    this.onProfileTap,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.surface,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
        child: GestureDetector(
          onTap: onLogoTap,
          child: Image.asset(
            'assets/png/image/image_logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onProfileTap,
          icon: Icon(
            Icons.person,
            color: context.secondary.withOpacity(0.5),
          ),
        ),
      ],
      leadingWidth: 120,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
