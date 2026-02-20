import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Dégradés utilisés dans l'application
class AppGradients {
  AppGradients._();

  // Dégradé principal (header)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5FEDAC), Color(0xFF63DBC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,

  );

  // Dégradé subtil pour les cartes
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFAFAFA),
    ],
  );

  // Dégradé pour les graphiques
  static const LinearGradient chartGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x804FD3C4),
      Color(0x004FD3C4),
    ],
  );

  // Dégradé rose/violet pour les stats
  static const LinearGradient secondaryChartGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x80E8B4E8),
      Color(0x00E8B4E8),
    ],
  );

  // Dégradé overlay (pour les effets de hover/press)
  static const LinearGradient overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00000000),
      Color(0x1A000000),
    ],
  );
}
