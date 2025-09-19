import 'package:flutter/material.dart';
import 'package:limo/core/navigation/navigation_service.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';
import 'package:limo/shared/extensions/context_typography_extension.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? backPath;

  const SharedAppBar({super.key, required this.title, this.backPath});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.surface,
      foregroundColor: context.onSurface,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          if (backPath != null) {
            NavigationService.popOrGo(backPath!);
            return;
          }
          NavigationService.pop();
        },
      ),
      title: Text(
        title,
        style: context.body.copyWith(color: context.onSurface),
      ),
    );
  }
}
