// shared/widgets/app_primary_bar.dart
import 'package:flutter/material.dart';
import 'package:limo/shared/constants/image_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final List<Widget>? actions;

  const NavigationAppBar({
    super.key,
    required this.title,
    this.scaffoldKey,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _openDrawer(BuildContext context) {
    final key =
        scaffoldKey ??
        Scaffold.maybeOf(context)?.widget.key as GlobalKey<ScaffoldState>?;
    if (key?.currentState?.hasDrawer ?? false) {
      key!.currentState!.openDrawer();
    } else {
      Scaffold.of(context).openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.surfaceContainer,
      foregroundColor: context.onSurface,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: () => _openDrawer(context),
        tooltip: 'Menu',
      ),
      title: Image.asset(
        ImageConstants.logo,
        height: 20,
        fit: BoxFit.contain,
        color: Colors.black,
      ),
      actions: actions,
    );
  }
}
