import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';

class ElevatedMaterial extends StatelessWidget {
  const ElevatedMaterial({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      borderRadius: GeneralConstants.borderRadius,
      shadowColor: context.secondary.withOpacity(0.1),
      child: Container(
        color: context.surfaceContainer,
        child: child,
      ),
    );
  }
}
