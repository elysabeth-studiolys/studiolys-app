import 'package:flutter/material.dart';

/// Extensions personnalisées du thème
class ThemeExtensions extends ThemeExtension<ThemeExtensions> {
  const ThemeExtensions();

  @override
  ThemeExtension<ThemeExtensions> copyWith() {
    return this;
  }

  @override
  ThemeExtension<ThemeExtensions> lerp(
    ThemeExtension<ThemeExtensions>? other,
    double t,
  ) {
    return this;
  }
}
