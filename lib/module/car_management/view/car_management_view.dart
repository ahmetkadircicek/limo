import 'package:flutter/material.dart';
import 'package:limo/core/providers/car_provider.dart';
import 'package:limo/module/car_management/view_model/car_management_view_model.dart';
import 'package:limo/module/car_management/widgets/car_card.dart';
import 'package:limo/module/car_management/widgets/car_management_header_widget.dart';
import 'package:limo/shared/constants/padding_constants.dart';
import 'package:limo/shared/widgets/shared_async_status_builder.dart';
import 'package:provider/provider.dart';

class CarManagementView extends StatefulWidget {
  const CarManagementView({super.key});
  @override
  State<CarManagementView> createState() => _CarManagementViewState();
}

class _CarManagementViewState extends State<CarManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CarProvider>().loadCars(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
      builder: (_, carProvider, _) {
        return SharedAsyncStatusBuilder(
          status: carProvider.status,
          errorMessage: carProvider.errorMessage,
          idleBuilder: (_) => _buildLoadingState(),
          loadingBuilder: (_) => _buildLoadingState(),
          emptyBuilder: (_) => _buildEmptyState(context),
          errorBuilder: (ctx, message) => _buildErrorState(ctx, message),
          successBuilder: (_) => _buildSuccessState(context, carProvider),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      padding: PaddingConstants.all24,
      children: [
        _buildHeader(context, carCount: 0),
        const SizedBox(height: PaddingConstants.p16),
        Icon(
          Icons.directions_car_filled_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: PaddingConstants.p16),
        const Text(
          'No cars yet',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: PaddingConstants.p8),
        const Text(
          'Add a car to start managing your fleet.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PaddingConstants.p16),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => context.read<CarProvider>().loadCars(context),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return ListView(
      padding: PaddingConstants.all24,
      children: [
        _buildHeader(context, carCount: 0),
        const SizedBox(height: PaddingConstants.p16),
        Icon(
          Icons.error_outline,
          size: 64,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: PaddingConstants.p16),
        Text(
          message ?? 'An error occurred',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: PaddingConstants.p16),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => context.read<CarProvider>().loadCars(context),
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, CarProvider carProvider) {
    final cars = carProvider.cars;
    return RefreshIndicator(
      onRefresh: () => context.read<CarProvider>().loadCars(context),
      child: ListView.builder(
        padding: PaddingConstants.all24,
        itemCount: cars.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return _buildHeader(context, carCount: cars.length);
          }
          return CarCard(carModel: cars[i - 1]);
        },
      ),
    );
  }

  CarManagementHeaderWidget _buildHeader(
    BuildContext context, {
    required int carCount,
  }) {
    return CarManagementHeaderWidget(
      carCount: carCount,
      onAddCar:
          () => context.read<CarManagementViewModel>().addCarPressed(context),
    );
  }
}
