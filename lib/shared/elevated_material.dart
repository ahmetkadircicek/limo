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
      elevation: 2,
      borderRadius: GeneralConstants.borderRadius,
      shadowColor: GeneralConstants.shadowColor,
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceContainer,
          borderRadius: GeneralConstants.borderRadius,
          boxShadow: GeneralConstants.boxShadowDefault,
        ),
        child: child,
      ),
    );
  }
}
