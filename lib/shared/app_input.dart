import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';

enum InputVariant { primary, secondary, tertiary }

/// Unified input component with 3 variants
class AppInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final VoidCallback? onSuffixIconTap;
  final int maxLines;
  final InputVariant variant;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final Function(String?)? onDropdownChanged;

  // Dropdown özelleştirme parametreleri
  final Color? dropdownColor;
  final double? dropdownItemHeight;
  final EdgeInsets? dropdownItemPadding;
  final Color? dropdownItemTextColor;
  final Color? dropdownItemBackgroundColor;

  const AppInput({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSuffixIconTap,
    this.maxLines = 1,
    this.variant = InputVariant.primary,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.dropdownColor,
    this.dropdownItemHeight,
    this.dropdownItemPadding,
    this.dropdownItemTextColor,
    this.dropdownItemBackgroundColor,
  });

  // Factory constructors
  const AppInput.primary({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSuffixIconTap,
    this.maxLines = 1,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.dropdownColor,
    this.dropdownItemHeight,
    this.dropdownItemPadding,
    this.dropdownItemTextColor,
    this.dropdownItemBackgroundColor,
  }) : variant = InputVariant.primary;

  const AppInput.secondary({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSuffixIconTap,
    this.maxLines = 1,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.dropdownColor,
    this.dropdownItemHeight,
    this.dropdownItemPadding,
    this.dropdownItemTextColor,
    this.dropdownItemBackgroundColor,
  }) : variant = InputVariant.secondary;

  const AppInput.tertiary({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSuffixIconTap,
    this.maxLines = 1,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.dropdownColor,
    this.dropdownItemHeight,
    this.dropdownItemPadding,
    this.dropdownItemTextColor,
    this.dropdownItemBackgroundColor,
  }) : variant = InputVariant.tertiary;

  // Dropdown factory
  const AppInput.dropdown({
    super.key,
    required this.dropdownItems,
    this.dropdownValue,
    required this.onDropdownChanged,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.enabled = true,
    this.validator,
    this.variant = InputVariant.primary,
    this.dropdownColor,
    this.dropdownItemHeight,
    this.dropdownItemPadding,
    this.dropdownItemTextColor,
    this.dropdownItemBackgroundColor,
  })  : isDropdown = true,
        controller = null,
        obscureText = false,
        keyboardType = null,
        inputFormatters = null,
        onChanged = null,
        onSuffixIconTap = null,
        maxLines = 1,
        suffixIcon = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Padding(
            padding: PaddingConstants.onlyBottomS,
            child: Text(
              labelText!,
              style: GoogleFonts.nunito(
                color: context.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left, // sola hizala
              overflow: TextOverflow.ellipsis, // Handle label text overflow
              maxLines: 1, // Ensure single line for labels
            ),
          ),
        ],
        Container(
          height: maxLines > 1 ? null : GeneralConstants.inputHeight,
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: GeneralConstants.borderRadius,
            border: _getBorder(context),
            boxShadow: _getShadow(),
          ),
          child: ClipRRect(
            borderRadius: GeneralConstants.borderRadius,
            child:
                isDropdown ? _buildDropdown(context) : _buildTextField(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    // Hint ve input text sola hizalı olacak şekilde ayarlandı
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      maxLines: maxLines,
      style: GoogleFonts.nunito(
        color: context.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(
          color: context.onSurface.withValues(alpha: 0.5),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        icon: prefixIcon != null
            ? Padding(
                padding: PaddingConstants.onlyLeftL,
                child: Icon(
                  prefixIcon,
                  color: context.onSurface.withValues(alpha: 0.6),
                  size: GeneralConstants.iconSizeDefault,
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixIconTap,
                icon: Icon(
                  suffixIcon,
                  color: context.onSurface.withValues(alpha: 0.6),
                  size: GeneralConstants.iconSizeSmall,
                ),
              )
            : null,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: maxLines > 1
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            : EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    // Dropdown ve hint sola hizalı olacak şekilde ayarlandı
    return Theme(
      data: Theme.of(context).copyWith(
        // Dropdown menü için özel tema
        popupMenuTheme: PopupMenuThemeData(
          color: dropdownColor ?? _getDropdownBackgroundColor(context),
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: GeneralConstants.borderRadiusLarge,
            side: BorderSide(
              color: context.onSurface.withValues(alpha: 0.1),
              width: 1.0,
            ),
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: DropdownButtonFormField<String>(
          value: dropdownValue,
          onChanged: enabled ? onDropdownChanged : null,
          validator: validator,
          isExpanded: true,
          alignment: Alignment.centerLeft,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.nunito(
              color: context.onSurface.withValues(alpha: 0.5),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: prefixIcon != null
                ? Padding(
                    padding: PaddingConstants.onlyLeftL,
                    child: Icon(
                      prefixIcon,
                      color: context.onSurface.withValues(alpha: 0.6),
                      size: GeneralConstants.iconSizeDefault,
                    ),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: false,
          ),
          style: GoogleFonts.nunito(
            color: context.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: PaddingConstants.horizontalM,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: context.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
          dropdownColor: dropdownColor ?? _getDropdownBackgroundColor(context),
          menuMaxHeight: 300,
          // Modern dropdown styling için özel parametreler
          borderRadius: BorderRadius.circular(12),
          // DropdownMenuThemeData'dan gelen styling'i kullan
          items: dropdownItems?.map((String value) {
            // AHMET - Dropdown listesindeki her bir item component'i
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                height: dropdownItemHeight ?? 48,
                padding: dropdownItemPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: dropdownItemBackgroundColor ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: GoogleFonts.nunito(
                          color: dropdownItemTextColor ??
                              context.onSurface.withValues(alpha: 0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (dropdownValue == value)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: context.onPrimary,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          selectedItemBuilder: dropdownItems != null
              ? (context) => dropdownItems!.map((item) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: GeneralConstants.borderRadiusLarge),
                      width: double.infinity,
                      child: Text(
                        item,
                        style: GoogleFonts.nunito(
                          color: context.onSurface.withValues(alpha: 0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList()
              : null,
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (variant) {
      case InputVariant.primary:
        return const Color(0xFFF6F6F6); // Light gray
      case InputVariant.secondary:
        return context.surface; // White
      case InputVariant.tertiary:
        return context.secondary.withValues(alpha: 0.1); // Tinted
    }
  }

  Color _getDropdownBackgroundColor(BuildContext context) {
    switch (variant) {
      case InputVariant.primary:
        return context.surface; // White for dropdown menu
      case InputVariant.secondary:
        return context.surface; // White
      case InputVariant.tertiary:
        return context.surface; // White for dropdown menu
    }
  }

  Border? _getBorder(BuildContext context) {
    switch (variant) {
      case InputVariant.primary:
        return Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
          width: 1.0,
        );
      case InputVariant.secondary:
        return Border.all(
          color: context.onSurface.withValues(alpha: 0.2),
          width: 1.0,
        );
      case InputVariant.tertiary:
        return Border.all(
          color: context.secondary.withValues(alpha: 0.3),
          width: 1.0,
        );
    }
  }

  List<BoxShadow>? _getShadow() {
    if (variant == InputVariant.primary) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return null;
  }
}
