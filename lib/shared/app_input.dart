import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

enum InputVariant { primary, secondary, tertiary }

class AppInput extends StatelessWidget {
  final String? hintText;
  final String labelText;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final VoidCallback? onSuffixIconTap;
  final InputVariant variant;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final Function(String?)? onDropdownChanged;

  // Ana constructor
  const AppInput({
    super.key,
    this.hintText,
    required this.labelText,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSuffixIconTap,
    this.variant = InputVariant.primary,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
  });

  // Factory: Primary
  const AppInput.primary({
    Key? key,
    String? hintText,
    required String labelText,
    IconData? suffixIcon,
    TextEditingController? controller,
    bool obscureText = false,
    bool enabled = true,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    VoidCallback? onSuffixIconTap,
  }) : this(
         key: key,
         hintText: hintText,
         labelText: labelText,
         suffixIcon: suffixIcon,
         controller: controller,
         obscureText: obscureText,
         enabled: enabled,
         validator: validator,
         keyboardType: keyboardType,
         inputFormatters: inputFormatters,
         onChanged: onChanged,
         onSuffixIconTap: onSuffixIconTap,
         variant: InputVariant.primary,
       );

  // Factory: Secondary
  const AppInput.secondary({
    Key? key,
    String? hintText,
    required String labelText,
    IconData? suffixIcon,
    TextEditingController? controller,
    bool obscureText = false,
    bool enabled = true,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    VoidCallback? onSuffixIconTap,
  }) : this(
         key: key,
         hintText: hintText,
         labelText: labelText,
         suffixIcon: suffixIcon,
         controller: controller,
         obscureText: obscureText,
         enabled: enabled,
         validator: validator,
         keyboardType: keyboardType,
         inputFormatters: inputFormatters,
         onChanged: onChanged,
         onSuffixIconTap: onSuffixIconTap,
         variant: InputVariant.secondary,
       );

  // Factory: Tertiary
  const AppInput.tertiary({
    Key? key,
    String? hintText,
    required String labelText,
    IconData? suffixIcon,
    TextEditingController? controller,
    bool obscureText = false,
    bool enabled = true,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    VoidCallback? onSuffixIconTap,
  }) : this(
         key: key,
         hintText: hintText,
         labelText: labelText,
         suffixIcon: suffixIcon,
         controller: controller,
         obscureText: obscureText,
         enabled: enabled,
         validator: validator,
         keyboardType: keyboardType,
         inputFormatters: inputFormatters,
         onChanged: onChanged,
         onSuffixIconTap: onSuffixIconTap,
         variant: InputVariant.tertiary,
       );

  // Factory: Dropdown
  const AppInput.dropdown({
    Key? key,
    required List<String> dropdownItems,
    String? dropdownValue,
    required Function(String?) onDropdownChanged,
    String? hintText,
    required String labelText,
    bool enabled = true,
    String? Function(String?)? validator,
    InputVariant variant = InputVariant.primary,
  }) : this(
         key: key,
         hintText: hintText,
         labelText: labelText,
         enabled: enabled,
         validator: validator,
         variant: variant,
         isDropdown: true,
         dropdownItems: dropdownItems,
         dropdownValue: dropdownValue,
         onDropdownChanged: onDropdownChanged,
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PaddingConstants.onlyBottomXs,
          child: AppText.caption(labelText, color: _getLabelColor(context)),
        ),
        isDropdown ? _buildDropdown(context) : _buildTextField(context),
      ],
    );
  }

  /// Ortak decoration
  InputDecoration _baseDecoration(BuildContext context) {
    // Kenar yumusatma ve border ekle
    Color borderColor;
    switch (variant) {
      case InputVariant.primary:
        borderColor = context.primary.withValues(alpha: 0.15);
        break;
      case InputVariant.secondary:
        borderColor = context.onSurface.withValues(alpha: 0.12);
        break;
      case InputVariant.tertiary:
        borderColor = context.secondary.withValues(alpha: 0.25);
        break;
    }

    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.montserrat(
        color: _getHintColor(context),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      suffixIcon:
          suffixIcon != null
              ? IconButton(
                onPressed: onSuffixIconTap,
                icon: Icon(suffixIcon, color: _getIconColor(context)),
              )
              : null,
      filled: true,
      fillColor: _getBackgroundColor(context),
      contentPadding: PaddingConstants.horizontalL,
      enabledBorder: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius, // kenar yumusatma
        borderSide: BorderSide(color: borderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius, // kenar yumusatma
        borderSide: BorderSide(
          color: context.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius, // kenar yumusatma
        borderSide: BorderSide(
          color: Colors.red.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius, // kenar yumusatma
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      border: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius, // kenar yumusatma
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: GeneralConstants.borderRadius, // kenar yumusatma
        borderSide: BorderSide(color: context.surfaceContainer, width: 1),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      maxLines: 1, // Always single line
      style: GoogleFonts.montserrat(
        color: _getTextColor(context),
        fontSize: 16,
      ),
      decoration: _baseDecoration(context),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: dropdownValue,
      onChanged: enabled ? onDropdownChanged : null,
      validator: validator,
      isExpanded: true,
      style: GoogleFonts.montserrat(
        color: _getTextColor(context),
        fontSize:
            DesignTokens.bodyLarge.fontSize, // 16px - consistent with theme
        fontWeight: FontWeight.w400, // Normal weight - consistent with theme
        height: DesignTokens.bodyLarge.height, // 22/16 - consistent line height
      ),
      decoration: _baseDecoration(context),
      items:
          dropdownItems?.map((value) {
            return DropdownMenuItem(
              value: value,
              child: AppText.body(value, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
      menuMaxHeight: 200, // Consistent with theme maximum size
      dropdownColor:
          DesignTokens.surface100, // Consistent with theme background
      borderRadius: BorderRadius.circular(
        DesignTokens.radiusMedium,
      ), // Ensure rounded corners
    );
  }

  Color _getLabelColor(BuildContext context) =>
      variant == InputVariant.primary && _isPrimaryBackground(context)
          ? context.onPrimary
          : context.onSurface;

  Color _getTextColor(BuildContext context) =>
      variant == InputVariant.primary && _isPrimaryBackground(context)
          ? context.onPrimary
          : context.onSurface;

  Color _getHintColor(BuildContext context) =>
      variant == InputVariant.primary && _isPrimaryBackground(context)
          ? context.onPrimary.withValues(alpha: 0.5)
          : context.onSurface.withValues(alpha: 0.5);

  Color _getIconColor(BuildContext context) =>
      variant == InputVariant.primary && _isPrimaryBackground(context)
          ? context.onPrimary.withValues(alpha: 0.6)
          : context.onSurface.withValues(alpha: 0.6);

  bool _isPrimaryBackground(BuildContext context) =>
      _getBackgroundColor(context).toARGB32() == context.primary.toARGB32();

  Color _getBackgroundColor(BuildContext context) {
    switch (variant) {
      case InputVariant.primary:
        return const Color(0xFFF6F6F6);
      case InputVariant.secondary:
        return context.surface;
      case InputVariant.tertiary:
        return context.secondary.withValues(alpha: 0.1);
    }
  }
}
