// import 'package:flutter/material.dart';

// import '../../../../core/components/general/general_button.dart';
// import '../../../../core/components/general/general_text.dart';
// import '../../../../core/components/general/text_field/prefix_text_field.dart';
// import '../../../../core/extensions/general_extensions.dart';
// import '../../../../core/extensions/string_extension.dart';
// import '../../../../core/init/lang/locale_keys.g.dart';
// import '../../../../core/init/navigation/navigation_service.dart';
// import '../../../../core/utilities/constants/general_constants.dart';
// import '../../../../core/utilities/constants/padding_constants.dart';
// import '../../../../core/utilities/enums/alert_type_enum.dart';

// class ForgetPasswordDialog extends StatelessWidget {
//   final String title;
//   final String action;
//   final AlertType alertType;
//   final TextEditingController controller;
//   final VoidCallback? onPressed;

//   const ForgetPasswordDialog({
//     super.key,
//     required this.title,
//     required this.alertType,
//     required this.action,
//     required this.controller,
//     this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         alignment: Alignment.topCenter,
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             padding: PaddingConstants.allMedium + PaddingConstants.onlyTopMedium,
//             margin: EdgeInsets.symmetric(horizontal: context.width * 0.05),
//             decoration: BoxDecoration(
//               color: context.surfaceContainer,
//               borderRadius: GeneralConstants.borderRadius,
//             ),
//             child: Padding(
//               padding: PaddingConstants.symmetricHorizontalSmall,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   context.spacerHeight(1),
//                   GeneralText(
//                     text: title,
//                     fontSize: GeneralConstants.fontSizeMedium,
//                     fontWeight: GeneralConstants.fontWeightBold,
//                     textAlign: TextAlign.center,
//                   ),
//                   context.spacerHeight(1),
//                   Column(
//                     children: [
//                       PrefixedTextField(
//                         hintText: LocaleKeys.fieldNumberHint,
//                         controller: controller,
//                         prefixIcon: const Icon(Icons.phone),
//                         isPhoneNumber: true,
//                       ),
//                       context.spacerHeight(2),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: GeneralButton(
//                               onPressed: () {
//                                 NavigationService.instance.goBack();
//                               },
//                               text: 'KAPAT',
//                               fontSize: GeneralConstants.fontSizeSmall,
//                               fontColor: context.onPrimary,
//                               color: context.error,
//                             ),
//                           ),
//                           context.spacerWidth(3),
//                           Expanded(
//                             child: GeneralButton(
//                               onPressed: onPressed,
//                               text: action.toUpperCaseTr(),
//                               fontSize: GeneralConstants.fontSizeSmall,
//                               fontColor: context.onPrimary,
//                               color: AlertUtils.getColor(context, alertType),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: -GeneralConstants.heightExtraSmall,
//             child: Container(
//               width: GeneralConstants.heightExtraLarge,
//               decoration: BoxDecoration(
//                 color: AlertUtils.getColor(context, alertType),
//                 borderRadius: GeneralConstants.borderRadius,
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   NavigationService.instance.goBack();
//                 },
//                 icon: Icon(
//                   AlertUtils.getIcon(alertType),
//                   color: Colors.white,
//                   size: GeneralConstants.fontSizeExtraLarge,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
