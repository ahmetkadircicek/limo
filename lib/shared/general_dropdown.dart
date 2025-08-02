import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/elevated_material.dart';

class GeneralDropdown extends StatefulWidget {
  const GeneralDropdown({
    super.key,
    required this.items,
    required this.hintText,
    this.value,
    this.onChanged,
    this.prefixIcon,
  });

  final List<String> items;
  final String hintText;
  final String? value;
  final Function(String?)? onChanged;
  final Icon? prefixIcon;

  @override
  State<GeneralDropdown> createState() => _GeneralDropdownState();
}

class _GeneralDropdownState extends State<GeneralDropdown> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: SizedBox(
        height: GeneralConstants.heightMedium,
        child: DropdownButtonFormField<String>(
          value: widget.value,
          onChanged: widget.onChanged,
          validator: (value) {
            setState(() {
              _hasError = value == null || value.isEmpty;
            });
            return null;
          },
          decoration: InputDecoration(
            contentPadding: PaddingConstants.symmetricHorizontalMedium,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon!.icon,
                    color: _hasError ? context.error : context.secondary,
                  )
                : null,
            hintStyle: GoogleFonts.nunito(
              color: context.secondary.withOpacity(0.5),
              fontWeight: GeneralConstants.fontWeightRegular,
              fontSize: GeneralConstants.fontSizeSmall,
            ),
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: GeneralConstants.borderRadius,
              borderSide: BorderSide(
                color: context.secondary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: GeneralConstants.borderRadius,
              borderSide: BorderSide(
                color: context.primary,
              ),
            ),
          ),
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.nunito(
                  color: context.onSurface,
                  fontWeight: GeneralConstants.fontWeightRegular,
                  fontSize: GeneralConstants.fontSizeSmall,
                ),
              ),
            );
          }).toList(),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: context.secondary,
          ),
          dropdownColor: context.surface,
          style: GoogleFonts.nunito(
            color: context.onSurface,
            fontWeight: GeneralConstants.fontWeightRegular,
            fontSize: GeneralConstants.fontSizeSmall,
          ),
        ),
      ),
    );
  }
}
