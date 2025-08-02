import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/core/init/util/phone_number_formatter.dart';
import 'package:soforvarcom/shared/elevated_material.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onCountryChanged,
    this.initialCountryCode = 'TR',
    this.validator,
  });

  final String hintText;
  final TextEditingController controller;
  final Function(CountryCode) onCountryChanged;
  final String initialCountryCode;
  final String? Function(String?)? validator;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: Row(
        children: [
          // Country Code Picker
          CountryCodePicker(
            onChanged: widget.onCountryChanged,
            initialSelection: widget.initialCountryCode,
            favorite: const ['+90', '+1', '+44', '+49'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            hideSearch: true,
            hideMainText: true,
            alignLeft: false,
            showFlagMain: true,
            textStyle: GoogleFonts.nunito(
              color: context.secondary,
              fontWeight: GeneralConstants.fontWeightRegular,
              fontSize: GeneralConstants.fontSizeSmall,
            ),
            dialogTextStyle: GoogleFonts.nunito(
              color: context.secondary,
              fontWeight: GeneralConstants.fontWeightRegular,
              fontSize: GeneralConstants.fontSizeSmall,
            ),
            searchStyle: GoogleFonts.nunito(
              color: context.secondary,
              fontWeight: GeneralConstants.fontWeightRegular,
              fontSize: GeneralConstants.fontSizeSmall,
            ),
            flagWidth: 24,
            padding: PaddingConstants.zeroPadding,
            margin: PaddingConstants.zeroPadding,
          ),
          // Vertical divider
          Container(
            height: 24,
            width: 1,
            color: context.secondary.withOpacity(0.3),
            margin: PaddingConstants.onlyRightSmall,
          ),
          // Phone number input field
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
                PhoneNumberFormatter(),
              ],
              validator: widget.validator ?? _defaultValidator,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.nunito(
                  color: context.secondary.withOpacity(0.5),
                  fontWeight: GeneralConstants.fontWeightRegular,
                  fontSize: GeneralConstants.fontSizeSmall,
                ),
                border: InputBorder.none,
                contentPadding: PaddingConstants.symmetricHorizontalSmall +
                    PaddingConstants.symmetricVerticalSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone Number is required';
    }

    if (!_isValidPhoneFormat(value)) {
      return 'Invalid phone number format';
    }

    return null;
  }

  bool _isValidPhoneFormat(String value) {
    // Check for format: (xxx) xxx-xxxx
    return RegExp(r'^\(\d{3}\) \d{3}-\d{4}$').hasMatch(value);
  }
}
