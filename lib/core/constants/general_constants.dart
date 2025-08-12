import 'package:flutter/material.dart';
import 'package:limo/core/constants/design_tokens.dart';

class GeneralConstants {
  // MODERN DESIGN SYSTEM CONSTANTS - Following Professional Design Language

  // Heights - Reference Sizes from Design System
  static const buttonHeight = DesignTokens.primaryButtonHeight; // 48.0
  static const inputHeight = DesignTokens.inputHeight; // 48.0
  static const heightLarge = DesignTokens.listItemDouble; // 72.0
  static const heightMedium = DesignTokens.listItemSingle; // 56.0
  static const heightSmall = DesignTokens.secondaryButtonHeight; // 44.0
  static const heightExtraSmall = DesignTokens.smallButtonHeight; // 36.0

  // Border Radius - Following 4/8/16 system
  static final borderRadius =
      BorderRadius.circular(DesignTokens.radiusMedium); // 8.0
  static final borderRadiusSmall =
      BorderRadius.circular(DesignTokens.radiusSmall); // 4.0
  static final borderRadiusLarge =
      BorderRadius.circular(DesignTokens.radiusLarge); // 16.0
  static final borderRadiusRound =
      BorderRadius.circular(DesignTokens.radiusRound); // 9999.0

  // Typography Sizes - Professional Design Language
  static const fontSizeCaption = 12.0; // caption
  static const fontSizeSmall = 14.0; // bodySmall
  static const fontSizeBody = 16.0; // bodyLarge
  static const fontSizeSubtitle = 18.0; // h3
  static const fontSizeTitle = 22.0; // h2
  static const fontSizeHeading = 28.0; // h1

  // Legacy font sizes (deprecated - use DesignTokens.* directly)
  static const fontSizeExtraSmall = 12.0;
  static const fontSizeMedium = 18.0;
  static const fontSizeLarge = 22.0;
  static const fontSizeExtraLarge = 28.0;

  // Icon Sizes - Professional scaling
  static const iconSizeSmall = DesignTokens.iconSmall; // 16.0
  static const iconSizeDefault = DesignTokens.iconLarge; // 24.0
  static const iconSizeMedium = DesignTokens.iconXL; // 32.0
  static const iconSizeLarge = DesignTokens.iconXL; // 32.0

  // Animation Durations - Optimized for modern feel
  static const animationDurationFast = DesignTokens.durationSmall; // 100ms
  static const animationDurationMedium = DesignTokens.durationMedium; // 200ms
  static const animationDurationSlow = DesignTokens.durationLarge; // 350ms

  // Spacing shortcuts - 4pt base system
  static const spacingXS = DesignTokens.spacing1; // 4
  static const spacingS = DesignTokens.spacing2; // 8
  static const spacingM = DesignTokens.spacing3; // 12
  static const spacingL = DesignTokens.spacing4; // 16
  static const spacingXL = DesignTokens.spacing5; // 20
  static const spacingXXL = DesignTokens.spacing6; // 24
  static const spacingXXXL = DesignTokens.spacing8; // 32

  // Hit Areas - Accessibility compliant
  static const minTapArea = DesignTokens.iconHitArea; // 44.0

  // Top App Bar
  static const appBarHeight = DesignTokens.topAppBarHeight; // 56.0

  // Bottom Navigation
  static const bottomNavHeight = DesignTokens.bottomNavHeight; // 56.0

  // Floating Action Button
  static const fabSize = DesignTokens.fabRegular; // 56.0
  static const fabSizeSmall = DesignTokens.fabSmall; // 40.0

  // Font weights for backward compatibility
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightSubtitle = FontWeight.w500;
  static const fontWeightCaption = FontWeight.w400;
}
