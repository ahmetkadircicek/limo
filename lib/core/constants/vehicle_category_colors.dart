import 'package:flutter/material.dart';

/// Const color definitions for vehicle categories
/// Each category has a unique color that represents its level and prestige
class VehicleCategoryColors {
  // Ultra Premium/Luxury Vehicles (ID: 10) - Deep Black with Gold accents
  static const Color ultraLuxury = Color(0xFF0F0F0F);
  static const Color ultraLuxuryLight = Color(0xFF1A1A1A);
  static const Color ultraLuxuryAccent = Color(0xFFD4AF37);

  // Premium Luxury Vehicles (ID: 9) - Rich Purple with Silver accents
  static const Color luxury = Color(0xFF4C1D95);
  static const Color luxuryLight = Color(0xFF6D28D9);
  static const Color luxuryAccent = Color(0xFFC0C0C0);

  // High-End Premium Vehicles (ID: 8) - Deep Blue with White accents
  static const Color premium = Color(0xFF1E40AF);
  static const Color premiumLight = Color(0xFF3B82F6);
  static const Color premiumAccent = Color(0xFFFFFFFF);

  // Mid-Range Premium Vehicles (ID: 7) - Teal with Light Blue accents
  static const Color executive = Color(0xFF0F766E);
  static const Color executiveLight = Color(0xFF14B8A6);
  static const Color executiveAccent = Color(0xFF87CEEB);

  // Standard Mid-Range Vehicles (ID: 6) - Orange with Yellow accents
  static const Color standard = Color(0xFFEA580C);
  static const Color standardLight = Color(0xFFF97316);
  static const Color standardAccent = Color(0xFFFCD34D);

  // Economy Mid-Range Vehicles (ID: 5) - Green with Light Green accents
  static const Color economy = Color(0xFF16A34A);
  static const Color economyLight = Color(0xFF22C55E);
  static const Color economyAccent = Color(0xFF86EFAC);

  // Compact Economy Vehicles (ID: 4) - Light Blue with White accents
  static const Color compact = Color(0xFF0EA5E9);
  static const Color compactLight = Color(0xFF38BDF8);
  static const Color compactAccent = Color(0xFFE0F2FE);

  // Small Economy Vehicles (ID: 3) - Pink with Light Pink accents
  static const Color small = Color(0xFFBE185D);
  static const Color smallLight = Color(0xFFEC4899);
  static const Color smallAccent = Color(0xFFFCE7F3);

  // Micro Vehicles (ID: 2) - Light Purple with White accents
  static const Color micro = Color(0xFF8B5CF6);
  static const Color microLight = Color(0xFFA78BFA);
  static const Color microAccent = Color(0xFFF3F4F6);

  // Utility/Basic Vehicles (ID: 1) - Gray with Light Gray accents
  static const Color utility = Color(0xFF6B7280);
  static const Color utilityLight = Color(0xFF9CA3AF);
  static const Color utilityAccent = Color(0xFFF9FAFB);

  /// Get the primary color for a specific category
  static Color getPrimaryColor(int categoryId) {
    switch (categoryId) {
      case 10:
        return ultraLuxury;
      case 9:
        return luxury;
      case 8:
        return premium;
      case 7:
        return executive;
      case 6:
        return standard;
      case 5:
        return economy;
      case 4:
        return compact;
      case 3:
        return small;
      case 2:
        return micro;
      case 1:
        return utility;
      default:
        return standard;
    }
  }

  /// Get the light color for a specific category
  static Color getLightColor(int categoryId) {
    switch (categoryId) {
      case 10:
        return ultraLuxuryLight;
      case 9:
        return luxuryLight;
      case 8:
        return premiumLight;
      case 7:
        return executiveLight;
      case 6:
        return standardLight;
      case 5:
        return economyLight;
      case 4:
        return compactLight;
      case 3:
        return smallLight;
      case 2:
        return microLight;
      case 1:
        return utilityLight;
      default:
        return standardLight;
    }
  }

  /// Get the accent color for a specific category
  static Color getAccentColor(int categoryId) {
    switch (categoryId) {
      case 10:
        return ultraLuxuryAccent;
      case 9:
        return luxuryAccent;
      case 8:
        return premiumAccent;
      case 7:
        return executiveAccent;
      case 6:
        return standardAccent;
      case 5:
        return economyAccent;
      case 4:
        return compactAccent;
      case 3:
        return smallAccent;
      case 2:
        return microAccent;
      case 1:
        return utilityAccent;
      default:
        return standardAccent;
    }
  }

  /// Get color with specific opacity for a category
  static Color getColorWithOpacity(int categoryId, double opacity) {
    return getPrimaryColor(categoryId).withValues(alpha: opacity);
  }

  /// Get light color with specific opacity for a category
  static Color getLightColorWithOpacity(int categoryId, double opacity) {
    return getLightColor(categoryId).withValues(alpha: opacity);
  }

  /// Get accent color with specific opacity for a category
  static Color getAccentColorWithOpacity(int categoryId, double opacity) {
    return getAccentColor(categoryId).withValues(alpha: opacity);
  }

  /// Get a gradient for a specific category
  static List<Color> getGradient(int categoryId) {
    switch (categoryId) {
      case 10:
        return [ultraLuxury, ultraLuxuryLight, ultraLuxuryAccent];
      case 9:
        return [luxury, luxuryLight, luxuryAccent];
      case 8:
        return [premium, premiumLight, premiumAccent];
      case 7:
        return [executive, executiveLight, executiveAccent];
      case 6:
        return [standard, standardLight, standardAccent];
      case 5:
        return [economy, economyLight, economyAccent];
      case 4:
        return [compact, compactLight, compactAccent];
      case 3:
        return [small, smallLight, smallAccent];
      case 2:
        return [micro, microLight, microAccent];
      case 1:
        return [utility, utilityLight, utilityAccent];
      default:
        return [standard, standardLight, standardAccent];
    }
  }

  /// Get a subtle background color for a category (very low opacity)
  static Color getBackgroundColor(int categoryId) {
    return getPrimaryColor(categoryId).withValues(alpha: 0.05);
  }

  /// Get a medium background color for a category (medium opacity)
  static Color getMediumBackgroundColor(int categoryId) {
    return getPrimaryColor(categoryId).withValues(alpha: 0.1);
  }

  /// Get a strong background color for a category (high opacity)
  static Color getStrongBackgroundColor(int categoryId) {
    return getPrimaryColor(categoryId).withValues(alpha: 0.2);
  }

  /// Get a border color for a category
  static Color getBorderColor(int categoryId) {
    return getPrimaryColor(categoryId).withValues(alpha: 0.3);
  }

  /// Get a text color for a category (ensuring good contrast)
  static Color getTextColor(int categoryId) {
    final primaryColor = getPrimaryColor(categoryId);
    // Calculate luminance to determine if we need light or dark text
    final luminance = primaryColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
