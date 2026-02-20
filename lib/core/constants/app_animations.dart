import 'package:flutter/material.dart';

/// Configuration des animations
class AppAnimations {
  AppAnimations._();

  // Durées
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  // Courbes
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveBounce = Curves.bounceOut;
  static const Curve curveElastic = Curves.elasticOut;

  // Transitions
  static const Duration pageTransitionDuration = Duration(milliseconds: 350);
  static const Curve pageTransitionCurve = Curves.easeInOutCubic;

  // Sliders
  static const Duration sliderAnimationDuration = Duration(milliseconds: 200);

  // Bottom nav
  static const Duration bottomNavAnimationDuration = Duration(milliseconds: 250);

  // Cards
  static const Duration cardAnimationDuration = Duration(milliseconds: 300);

  // Ripple effect
  static const Duration rippleDuration = Duration(milliseconds: 400);
}
