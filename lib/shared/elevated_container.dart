import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';

class ElevatedContainer extends StatelessWidget {
  final Widget child;
  const ElevatedContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: context.height * 0.5,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: GeneralConstants.borderRadius,
        boxShadow: [
          BoxShadow(
            color: context.secondary.withOpacity(0.1),
            blurRadius: 40,
          ),
        ],
      ),
      child: child,
    );
  }
}
