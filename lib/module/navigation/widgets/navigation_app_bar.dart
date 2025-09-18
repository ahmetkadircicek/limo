// shared/widgets/app_primary_bar.dart
import 'package:flutter/material.dart';

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
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: () => _openDrawer(context),
        tooltip: 'Menu',
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
      ),
      actions: actions,
    );
  }
}
