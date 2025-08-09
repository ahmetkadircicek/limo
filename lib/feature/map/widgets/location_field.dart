import 'package:flutter/material.dart';
import 'package:soforvarcom/core/constants/general_constants.dart';
import 'package:soforvarcom/core/constants/padding_constants.dart';
import 'package:soforvarcom/core/extensions/general_extensions.dart';
import 'package:soforvarcom/feature/map/models/location_model.dart';
import 'package:soforvarcom/feature/map/widgets/location_picker.dart';
import 'package:soforvarcom/shared/elevated_material.dart';

class LocationField extends StatelessWidget {
  final String? hintText;
  final Icon? prefixIcon;
  final LocationModel? selectedLocation;
  final Function(LocationModel) onLocationSelected;
  final String? Function(LocationModel?)? validator;
  final bool enabled;
  final String pickerTitle;

  const LocationField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.selectedLocation,
    required this.onLocationSelected,
    this.validator,
    this.enabled = true,
    required this.pickerTitle,
  });

  void _openLocationPicker(BuildContext context) {
    if (!enabled) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          title: pickerTitle,
          initialLocation: selectedLocation,
          onLocationSelected: onLocationSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: FormField<LocationModel>(
        validator: (_) => validator?.call(selectedLocation),
        builder: (field) {
          return Column(
            children: [
              InkWell(
                onTap: enabled ? () => _openLocationPicker(context) : null,
                borderRadius: GeneralConstants.borderRadius,
                child: Container(
                  width: double.infinity,
                  height: GeneralConstants.inputHeight,
                  padding: PaddingConstants.inputHorizontal,
                  decoration: BoxDecoration(
                    borderRadius: GeneralConstants.borderRadius,
                    border: Border.all(
                      color: field.hasError
                          ? context.error
                          : enabled
                              ? context.secondary.withOpacity(0.3)
                              : context.secondary.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (prefixIcon != null)
                        Icon(
                          prefixIcon!.icon,
                          color: field.hasError
                              ? context.error
                              : enabled
                                  ? context.secondary
                                  : context.secondary.withOpacity(0.5),
                          size: GeneralConstants.iconSizeSmall,
                        ),
                      if (prefixIcon != null) context.spacerWidth(1),
                      Expanded(
                        child: selectedLocation != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedLocation!.placeName,
                                    style: TextStyle(
                                      fontSize: GeneralConstants.fontSizeBody,
                                      fontWeight:
                                          GeneralConstants.fontWeightSubtitle,
                                      color: enabled
                                          ? context.onSurface
                                          : context.secondary.withOpacity(0.5),
                                    ),
                                  ),
                                  if (selectedLocation!.address.isNotEmpty)
                                    Text(
                                      selectedLocation!.address,
                                      style: TextStyle(
                                        fontSize:
                                            GeneralConstants.fontSizeCaption,
                                        fontWeight:
                                            GeneralConstants.fontWeightCaption,
                                        color: enabled
                                            ? context.secondary
                                            : context.secondary
                                                .withOpacity(0.5),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              )
                            : Text(
                                hintText ?? 'Select location',
                                style: TextStyle(
                                  fontSize: GeneralConstants.fontSizeBody,
                                  fontWeight: GeneralConstants.fontWeightBody,
                                  color: enabled
                                      ? context.secondary.withOpacity(0.7)
                                      : context.secondary.withOpacity(0.5),
                                ),
                              ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: enabled
                            ? context.secondary.withOpacity(0.7)
                            : context.secondary.withOpacity(0.3),
                        size: GeneralConstants.iconSizeSmall,
                      ),
                    ],
                  ),
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        fontSize: GeneralConstants.fontSizeCaption,
                        fontWeight: GeneralConstants.fontWeightCaption,
                        color: context.error,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
