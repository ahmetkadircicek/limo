import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/shared/elevated_material.dart';

class PrefixedTextField extends StatefulWidget {
  const PrefixedTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    this.validator,
  });

  final String hintText;
  final Icon? prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<PrefixedTextField> createState() => _PrefixedTextFieldState();
}

class _PrefixedTextFieldState extends State<PrefixedTextField> {
  bool _visible = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator != null
            ? widget.validator!
            : (value) {
                setState(() {
                  _hasError = value == null || value.isEmpty;
                });
                return null;
              },
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_visible,
        decoration: InputDecoration(
          contentPadding: PaddingConstants.symmetricHorizontalMedium,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon!.icon,
                  color: _hasError ? context.error : context.secondary,
                )
              : null,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.nunito(
            color: context.secondary.withOpacity(0.5),
            fontWeight: GeneralConstants.fontWeightRegular,
            fontSize: GeneralConstants.fontSizeSmall,
          ),
          prefixIconColor: context.secondary,
          hintTextDirection: TextDirection.ltr,
          alignLabelWithHint: true,
          suffixIcon: _buildVisibilityIcon(),
          border: OutlineInputBorder(
            borderRadius: GeneralConstants.borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: GeneralConstants.borderRadius,
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilityIcon() {
    return IconButton(
      onPressed: () {
        setState(() {
          _visible = !_visible;
        });
      },
      icon: Icon(
        _visible ? Icons.visibility : Icons.visibility_off,
        color: context.secondary,
      ),
    );
  }
}
