import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/elevated_material.dart';

class GeneralTextField extends StatefulWidget {
  const GeneralTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.obscureText,
    this.enabled,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatter,
  });
  final String? hintText;
  final Icon? prefixIcon;
  final bool? obscureText;
  final bool? enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final dynamic inputFormatter;

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  final bool _visible = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: SizedBox(
        height: GeneralConstants.heightMedium,
        child: TextFormField(
          obscureText: widget.obscureText ?? false ? !_visible : false,
          validator: widget.validator != null
              ? widget.validator!
              : (value) {
                  setState(() {
                    _hasError = value == null || value.isEmpty;
                  });
                  return null;
                },
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          controller: widget.controller,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatter != null
              ? <TextInputFormatter>[widget.inputFormatter]
              : null,
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
            suffixIconColor: context.secondary,
            hintText: widget.hintText,
            hintTextDirection: TextDirection.ltr,
            alignLabelWithHint: true,
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
        ),
      ),
    );
  }
}
