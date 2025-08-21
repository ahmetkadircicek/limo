import 'package:flutter/material.dart';
import 'package:limo/core/constants/general_constants.dart';
import 'package:limo/core/constants/padding_constants.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/feature/map/models/location_model.dart';
import 'package:limo/shared/app_card.dart';
import 'package:limo/shared/app_text.dart';

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

  // Open location picker
  Future<void> _openLocationPicker(BuildContext context) async {
    if (!enabled) return;

    // TODO: Navigate to location picker page
    // For now, just show a message or handle differently
  }

  @override
  Widget build(BuildContext context) {
    return AppCard.secondary(
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
                    borderRadius:
                        BorderRadius.circular(16), // Daha yuvarlak köşeler
                    border: Border.all(
                      color: field.hasError
                          ? context.error
                          : enabled
                              ? context.secondary.withValues(alpha: 0.3)
                              : context.secondary.withValues(alpha: 0.1),
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
                                  : context.secondary.withValues(alpha: 0.5),
                          size: GeneralConstants.iconSizeSmall,
                        ),
                      Expanded(
                        child: selectedLocation != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText.body(
                                    selectedLocation!.placeName,
                                    fontWeight:
                                        GeneralConstants.fontWeightSubtitle,
                                    color: enabled
                                        ? context.onSurface
                                        : context.secondary
                                            .withValues(alpha: 0.5),
                                  ),
                                  if (selectedLocation!.address.isNotEmpty)
                                    AppText.caption(
                                      selectedLocation!.address,
                                      color: enabled
                                          ? context.secondary
                                          : context.secondary
                                              .withValues(alpha: 0.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              )
                            : AppText.body(
                                hintText ?? 'Select location',
                                color: enabled
                                    ? context.secondary.withValues(alpha: 0.7)
                                    : context.secondary.withValues(alpha: 0.5),
                              ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: enabled
                            ? context.secondary.withValues(alpha: 0.7)
                            : context.secondary.withValues(alpha: 0.3),
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
                    child: AppText.caption(
                      field.errorText!,
                      color: context.error,
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
