import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limo/core/constants/design_tokens.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

enum InputVariant { primary, secondary, tertiary, search }

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
  final Function(String)? onSubmitted;
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
    this.onSubmitted,
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
    Function(String)? onSubmitted,
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
         onSubmitted: onSubmitted,
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
    Function(String)? onSubmitted,
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
         onSubmitted: onSubmitted,
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
    Function(String)? onSubmitted,
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
         onSubmitted: onSubmitted,
         onSuffixIconTap: onSuffixIconTap,
         variant: InputVariant.tertiary,
       );

  // Factory: Search
  const AppInput.search({
    Key? key,
    String? hintText,
    TextEditingController? controller,
    bool enabled = true,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    VoidCallback? onSuffixIconTap,
  }) : this(
         key: key,
         hintText: hintText ?? 'Search...',
         labelText: '',
         controller: controller,
         enabled: enabled,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         onSuffixIconTap: onSuffixIconTap,
         variant: InputVariant.search,
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
        if (variant != InputVariant.search)
          Padding(
            padding: context.verticalXs,
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
      case InputVariant.search:
        borderColor = context.onSurface.withValues(alpha: 0.12);
        break;
    }

    InputDecoration baseDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.montserrat(
        color: _getHintColor(context),
        fontSize: DesignTokens.bodySmall.fontSize,
        fontWeight: DesignTokens.bodySmall.fontWeight,
      ),
      filled: true,
      fillColor: _getBackgroundColor(context),
      contentPadding: context.horizontalL,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: borderColor, width: 0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: borderColor, width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: borderColor, width: 0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: context.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide(color: context.error, width: 1),
      ),
    );

    // Search variant için özel decoration
    if (variant == InputVariant.search) {
      baseDecoration = baseDecoration.copyWith(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.spacingM,
          vertical: context.spacingS,
        ),
      );
    }

    return baseDecoration;
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
      onFieldSubmitted: onSubmitted,
      maxLines: 1,
      style: GoogleFonts.montserrat(
        color: _getTextColor(context),
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: DesignTokens.bodyLarge.fontWeight,
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
        fontSize: DesignTokens.bodyLarge.fontSize,
        fontWeight: FontWeight.w400,
        height: DesignTokens.bodyLarge.height,
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
          : context.onSurface.withValues(alpha: 0.6);

  Color _getTextColor(BuildContext context) =>
      variant == InputVariant.primary && _isPrimaryBackground(context)
          ? context.onPrimary
          : context.onSurface;

  Color _getHintColor(BuildContext context) {
    if (!enabled) {
      return context.onSurface.withValues(alpha: 0.3);
    }

    return variant == InputVariant.primary && _isPrimaryBackground(context)
        ? context.onPrimary.withValues(alpha: 0.5)
        : context.onSurface.withValues(alpha: 0.5);
  }

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
      case InputVariant.search:
        return context.surfaceContainer;
    }
  }
}
