import 'package:flutter/material.dart';
import 'package:limo/core/extensions/general_extensions.dart';
import 'package:limo/shared/app_text.dart';

class PricingInputForm extends StatefulWidget {
  final double? initialHourlyRate;
  final double? initialPricePerMile;
  final Function(double?) onHourlyRateChanged;
  final Function(double?) onPricePerMileChanged;
  final bool enabled;

  const PricingInputForm({
    super.key,
    this.initialHourlyRate,
    this.initialPricePerMile,
    required this.onHourlyRateChanged,
    required this.onPricePerMileChanged,
    this.enabled = true,
  });

  @override
  State<PricingInputForm> createState() => _PricingInputFormState();
}

class _PricingInputFormState extends State<PricingInputForm> {
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _pricePerMileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialHourlyRate != null) {
      _hourlyRateController.text = widget.initialHourlyRate!.toString();
    }
    if (widget.initialPricePerMile != null) {
      _pricePerMileController.text = widget.initialPricePerMile!.toString();
    }
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _pricePerMileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildPricingInputs(),
          const SizedBox(height: 12),
          _buildInfoText(),
        ],
      ),
    );
  }

  // Build form header with title and icon
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.attach_money,
            color: context.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        AppText.body(
          'Pricing Information',
          color: context.onSurface,
        ),
      ],
    );
  }

  // Build pricing input fields
  Widget _buildPricingInputs() {
    return Row(
      children: [
        Expanded(
          child: _buildHourlyRateInput(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPricePerMileInput(),
        ),
      ],
    );
  }

  // Build hourly rate input field
  Widget _buildHourlyRateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          'Hourly Rate (\$)',
          color: context.onSurface,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _hourlyRateController,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '\$ ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.primary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.1),
              ),
            ),
          ),
          onChanged: (value) {
            final rate = double.tryParse(value);
            widget.onHourlyRateChanged(rate);
          },
        ),
      ],
    );
  }

  // Build price per mile input field
  Widget _buildPricePerMileInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          'Price per Mile (\$)',
          color: context.onSurface,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _pricePerMileController,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '\$ ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.primary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.onSurface.withValues(alpha: 0.1),
              ),
            ),
          ),
          onChanged: (value) {
            final price = double.tryParse(value);
            widget.onPricePerMileChanged(price);
          },
        ),
      ],
    );
  }

  // Build informational text about pricing
  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.onSurface.withValues(alpha: 0.6),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.caption(
              'Set at least one pricing option. Both can be set for flexible pricing.',
              color: context.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
