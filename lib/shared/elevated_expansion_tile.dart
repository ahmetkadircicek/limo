import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/shared/elevated_material.dart';

class ElevatedExpansionTile extends StatelessWidget {
  const ElevatedExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: GeneralConstants.borderRadius,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: GeneralConstants.borderRadius,
        ),
        title: title,
        initiallyExpanded: initiallyExpanded,
        children: children,
      ),
    );
  }
}
