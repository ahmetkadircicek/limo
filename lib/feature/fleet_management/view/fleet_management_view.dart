import 'package:flutter/material.dart';
import 'package:limo/feature/fleet_management/widgets/fleet_management_header_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/extensions/context_color_extension.dart';

class FleetManagementView extends StatelessWidget {
  const FleetManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceContainer,
      body: ListView(
        padding: PaddingConstants.all20,
        children: [FleetManagementHeaderWidget()],
      ),
    );
  }
}
