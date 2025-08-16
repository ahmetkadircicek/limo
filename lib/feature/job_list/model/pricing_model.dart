class PricingModel {
  final double? basePrice; // Base price for the job
  final double? pricePerMile; // Price per mile for point-to-point jobs
  final double? hourlyRate; // Hourly rate for hourly jobs
  final double? dailyRate; // Daily rate for full-day jobs
  final double? extraCharges; // Additional charges (parking, tolls, etc.)
  final String? currency; // Currency code (default: USD)
  final String? pricingNotes; // Additional pricing information

  const PricingModel({
    this.basePrice,
    this.pricePerMile,
    this.hourlyRate,
    this.dailyRate,
    this.extraCharges,
    this.currency = 'USD',
    this.pricingNotes,
  });

  /// Factory constructor for empty pricing
  factory PricingModel.empty() {
    return const PricingModel();
  }

  /// Check if all pricing fields are empty
  bool get isEmpty =>
      basePrice == null &&
      pricePerMile == null &&
      hourlyRate == null &&
      dailyRate == null &&
      extraCharges == null;

  /// Check if at least one pricing field has a value
  bool get hasAnyPrice => !isEmpty;

  /// Get a summary of available pricing options
  String getPricingSummary() {
    if (isEmpty) return 'No pricing specified';

    List<String> availablePricing = [];

    if (basePrice != null) {
      availablePricing.add('\$${basePrice!.toStringAsFixed(2)} base');
    }
    if (pricePerMile != null) {
      availablePricing.add('\$${pricePerMile!.toStringAsFixed(2)}/mile');
    }
    if (hourlyRate != null) {
      availablePricing.add('\$${hourlyRate!.toStringAsFixed(2)}/hour');
    }
    if (dailyRate != null) {
      availablePricing.add('\$${dailyRate!.toStringAsFixed(2)}/day');
    }
    if (extraCharges != null) {
      availablePricing.add('\$${extraCharges!.toStringAsFixed(2)} extra');
    }

    return availablePricing.join(', ');
  }

  /// Get the primary price (first available price option)
  double? get primaryPrice {
    return basePrice ?? pricePerMile ?? hourlyRate ?? dailyRate ?? extraCharges;
  }

  /// Get the primary price type label
  String get primaryPriceLabel {
    if (basePrice != null) return 'base price';
    if (pricePerMile != null) return 'per mile';
    if (hourlyRate != null) return 'per hour';
    if (dailyRate != null) return 'per day';
    if (extraCharges != null) return 'extra charges';
    return 'no price';
  }

  /// Copy with method for updating individual values
  PricingModel copyWith({
    double? basePrice,
    double? pricePerMile,
    double? hourlyRate,
    double? dailyRate,
    double? extraCharges,
    String? currency,
    String? pricingNotes,
  }) {
    return PricingModel(
      basePrice: basePrice ?? this.basePrice,
      pricePerMile: pricePerMile ?? this.pricePerMile,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      dailyRate: dailyRate ?? this.dailyRate,
      extraCharges: extraCharges ?? this.extraCharges,
      currency: currency ?? this.currency,
      pricingNotes: pricingNotes ?? this.pricingNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basePrice': basePrice,
      'pricePerMile': pricePerMile,
      'hourlyRate': hourlyRate,
      'dailyRate': dailyRate,
      'extraCharges': extraCharges,
      'currency': currency,
      'pricingNotes': pricingNotes,
    };
  }

  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      basePrice: json['basePrice']?.toDouble(),
      pricePerMile: json['pricePerMile']?.toDouble(),
      hourlyRate: json['hourlyRate']?.toDouble(),
      dailyRate: json['dailyRate']?.toDouble(),
      extraCharges: json['extraCharges']?.toDouble(),
      currency: json['currency'] ?? 'USD',
      pricingNotes: json['pricingNotes'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PricingModel &&
        other.basePrice == basePrice &&
        other.pricePerMile == pricePerMile &&
        other.hourlyRate == hourlyRate &&
        other.dailyRate == dailyRate &&
        other.extraCharges == extraCharges &&
        other.currency == currency &&
        other.pricingNotes == pricingNotes;
  }

  @override
  int get hashCode {
    return basePrice.hashCode ^
        pricePerMile.hashCode ^
        hourlyRate.hashCode ^
        dailyRate.hashCode ^
        extraCharges.hashCode ^
        currency.hashCode ^
        pricingNotes.hashCode;
  }

  @override
  String toString() {
    return 'PricingModel(basePrice: $basePrice, pricePerMile: $pricePerMile, hourlyRate: $hourlyRate, dailyRate: $dailyRate, extraCharges: $extraCharges, currency: $currency, pricingNotes: $pricingNotes)';
  }
}
