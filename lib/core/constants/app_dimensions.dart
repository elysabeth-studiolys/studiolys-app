import 'package:flutter/material.dart';

/// Dimensions et espacements de l'application
class AppDimensions {
  AppDimensions._();

  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Margin
  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 16.0;
  static const double marginL = 24.0;
  static const double marginXL = 32.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusCircle = 999.0;

  // Icon sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Button sizes
  static const double buttonHeight = 50.0;
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightLarge = 56.0;

  // Card
  static const double cardElevation = 2.0;
  static const double cardRadius = 16.0;
  static const double cardPadding = 16.0;

  // Bottom navigation bar
  static const double bottomNavHeight = 70.0;
  static const double bottomNavIconSize = 24.0;
  static const double bottomNavCenterIconSize = 32.0;

  // App bar
  static const double appBarHeight = 120.0;
  static const double appBarRadius = 32.0;

  // Date selector
  static const double dateSelectorHeight = 70.0;
  static const double dateSelectorItemWidth = 50.0;

  // Slider
  static const double sliderHeight = 40.0;
  static const double sliderThumbRadius = 12.0;

  // Habit tracker
  static const double habitItemSize = 14.0;
  static const double habitItemSpacing = 5.0;

  // Chart
  static const double chartHeight = 140.0;
  static const double chartBarWidth = 12.0;

  // Stat card
  static const double statCardHeight = 250.0;
  static const double statCardWidth = double.infinity;

  // Week selector
  static const double weekSelectorHeight = 50.0;

  // Spacing helpers
  static const SizedBox spacingXS = SizedBox(height: paddingXS, width: paddingXS);
  static const SizedBox spacingS = SizedBox(height: paddingS, width: paddingS);
  static const SizedBox spacingM = SizedBox(height: paddingM, width: paddingM);
  static const SizedBox spacingL = SizedBox(height: paddingL, width: paddingL);
  static const SizedBox spacingXL = SizedBox(height: paddingXL, width: paddingXL);

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;
}

