import 'package:flutter/material.dart';
import 'package:limo/core/providers/car_provider.dart';
import 'package:limo/module/car_management/widgets/car_card.dart';
import 'package:limo/module/car_management/widgets/car_management_header_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:provider/provider.dart';

class CarManagementView extends StatefulWidget {
  const CarManagementView({super.key});
  @override
  State<CarManagementView> createState() => _CarManagementViewState();
}

class _CarManagementViewState extends State<CarManagementView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (_, carProvider, _) {
        if (carProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (carProvider.cars.isEmpty) {
          return ListView(
            padding: PaddingConstants.all20,
            children: const [
              CarManagementHeaderWidget(),
              Center(child: Text('No cars')),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<CarProvider>().loadCars(context),
          child: ListView.builder(
            padding: PaddingConstants.all16,
            itemCount: carProvider.cars.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return const CarManagementHeaderWidget();
              }
              return CarCard(carModel: carProvider.cars[i - 1]);
            },
          ),
        );
      },
    );
  }
}
