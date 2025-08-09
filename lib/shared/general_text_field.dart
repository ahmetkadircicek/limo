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
    this.onChanged,
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
  final Function(String)? onChanged;

  @override
  State<GeneralTextField> createState() => _GeneralTextFieldState();
}

class _GeneralTextFieldState extends State<GeneralTextField> {
  final bool _visible = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (widget.prefixIcon != null) {
      // Custom implementation with Stack for better icon positioning
      return ElevatedMaterial(
        child: SizedBox(
          height: widget.maxLines > 1 ? null : GeneralConstants.inputHeight,
          child: Stack(
            children: [
              // Text field without prefix icon
              TextFormField(
                obscureText: widget.obscureText ?? false ? !_visible : false,
                validator: widget.validator,
                onChanged: (value) {
                  // Only update error state when necessary, not on every character
                  final hasError = value.isEmpty;
                  if (_hasError != hasError) {
                    setState(() {
                      _hasError = hasError;
                    });
                  }
                  // Call the provided onChanged callback
                  widget.onChanged?.call(value);
                },
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                controller: widget.controller,
                enabled: widget.enabled,
                inputFormatters: widget.inputFormatter != null
                    ? <TextInputFormatter>[widget.inputFormatter]
                    : null,
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.nunito(
                    color: context.secondary.withOpacity(0.5),
                    fontWeight: GeneralConstants.fontWeightBody,
                    fontSize: GeneralConstants.fontSizeBody,
                  ),
                  suffixIconColor: context.secondary,
                  hintText: widget.hintText,
                  hintTextDirection: TextDirection.ltr,
                  alignLabelWithHint: widget.maxLines > 1,
                  contentPadding: EdgeInsets.only(
                    left: 48.0, // Space for icon
                    right: PaddingConstants.spacingM,
                    top: widget.maxLines > 1 ? PaddingConstants.spacingM : 12.0,
                    bottom:
                        widget.maxLines > 1 ? PaddingConstants.spacingM : 12.0,
                  ),
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
              // Positioned icon at top-left
              Positioned(
                left: 12.0,
                top: 16.0, // Fixed position regardless of text field height
                child: Icon(
                  widget.prefixIcon!.icon,
                  color: _hasError ? context.error : context.secondary,
                  size: GeneralConstants.iconSizeSmall,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Standard implementation without icon
      return ElevatedMaterial(
        child: SizedBox(
          height: widget.maxLines > 1 ? null : GeneralConstants.inputHeight,
          child: TextFormField(
            obscureText: widget.obscureText ?? false ? !_visible : false,
            validator: widget.validator,
            onChanged: (value) {
              // Only update error state when necessary, not on every character
              final hasError = value.isEmpty;
              if (_hasError != hasError) {
                setState(() {
                  _hasError = hasError;
                });
              }
              // Call the provided onChanged callback
              widget.onChanged?.call(value);
            },
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            controller: widget.controller,
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatter != null
                ? <TextInputFormatter>[widget.inputFormatter]
                : null,
            decoration: InputDecoration(
              hintStyle: GoogleFonts.nunito(
                color: context.secondary.withOpacity(0.5),
                fontWeight: GeneralConstants.fontWeightBody,
                fontSize: GeneralConstants.fontSizeBody,
              ),
              suffixIconColor: context.secondary,
              hintText: widget.hintText,
              hintTextDirection: TextDirection.ltr,
              alignLabelWithHint: widget.maxLines > 1,
              contentPadding: EdgeInsets.only(
                left: PaddingConstants.spacingM,
                right: PaddingConstants.spacingM,
                top: widget.maxLines > 1 ? PaddingConstants.spacingM : 12.0,
                bottom: widget.maxLines > 1 ? PaddingConstants.spacingM : 12.0,
              ),
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
}
