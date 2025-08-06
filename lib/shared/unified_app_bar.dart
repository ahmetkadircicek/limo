import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/general_text.dart';

class UnifiedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final bool showProfileIcon;
  final bool showMenuIcon;
  final int selectedIndex;

  const UnifiedAppBar({
    super.key,
    this.onProfileTap,
    this.onMenuTap,
    this.onLogoTap,
    this.showProfileIcon = true,
    this.showMenuIcon = true,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: onLogoTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GeneralText(
              text: 'Sevkiyat',
              fontSize: GeneralConstants.fontSizeLarge,
              fontWeight: GeneralConstants.fontWeightBold,
              color: context.onSurface,
            ),
            GeneralText(
              text: 'var',
              fontSize: GeneralConstants.fontSizeLarge,
              fontWeight: GeneralConstants.fontWeightBold,
              color: context.primary,
            ),
            GeneralText(
              text: '.com',
              fontSize: GeneralConstants.fontSizeLarge,
              fontWeight: GeneralConstants.fontWeightBold,
              color: context.onSurface,
            ),
          ],
        ),
      ),
      actions: [
        if (showProfileIcon)
          IconButton(
            onPressed: onProfileTap,
            icon: Icon(
              Icons.person_outline,
              color: selectedIndex == 6
                  ? context.onSecondaryContainer
                  : context.onSecondaryContainer.withValues(alpha: 0.3),
            ),
          ),
        if (showMenuIcon)
          IconButton(
            onPressed: onMenuTap,
            icon: Icon(
              Icons.menu,
              color: context.onSecondaryContainer.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
