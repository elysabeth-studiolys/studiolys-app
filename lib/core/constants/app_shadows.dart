import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Ombres utilisées dans l'application
class AppShadows {
  AppShadows._();

  // Ombre légère pour les cartes
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: AppColors.shadow,
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  // Ombre moyenne pour les éléments surélevés
  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: AppColors.shadow,
          offset: const Offset(0, 4),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ];

  // Ombre prononcée pour les modales
  static List<BoxShadow> get largeShadow => [
        BoxShadow(
          color: AppColors.shadow,
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];

  // Ombre pour le bottom navigation bar
  static List<BoxShadow> get bottomNavShadow => [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.1),
          offset: const Offset(0, -2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  // Ombre pour les boutons
  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];
}
