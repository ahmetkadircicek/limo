import 'package:flutter/material.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/constants/radius_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';

class SharedCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const SharedCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      height: height,
      width: width,
      padding: PaddingConstants.all16,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.surface,
        borderRadius: RadiusConstants.standard,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    }
    return widget;
  }
}
