import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/general_text.dart';

class GeneralListTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const GeneralListTile({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark
          ? context.secondary.withValues(alpha: 0.06)
          : context.secondary.withValues(alpha: 0.01),
      height: GeneralConstants.heightLarge,
      child: Center(
        child: ListTile(
          contentPadding: PaddingConstants.symmetricHorizontalMedium,
          visualDensity: VisualDensity.compact,
          title: GeneralText(
            text: label,
            color: context.onSurface,
            fontSize: GeneralConstants.fontSizeExtraSmall,
            fontWeight: GeneralConstants.fontWeightBold,
          ),
          subtitle: GeneralText(
            text: value,
            color: context.onSurface,
            fontSize: GeneralConstants.fontSizeExtraSmall,
            fontWeight: GeneralConstants.fontWeightRegular,
            maxLines: 6,
          ),
        ),
      ),
    );
  }
}
