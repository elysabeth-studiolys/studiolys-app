import 'package:flutter/material.dart';

/// Palette de couleurs de l'application basée sur la maquette
class AppColors {
  AppColors._();

  // Couleurs principales
  static const Color primary = Color(0xFF63DBC4);
  static const Color primaryLight = Color(0xFF7DE0D5);
  static const Color primaryDark = Color(0xFF3CB5A8);
  
  // Couleurs d'accentuation
  static const Color secondary = Color(0xFFE8B4E8);
  static const Color secondaryLight = Color(0xFFF3E5F5);
  static const Color accent = Color(0xFF63DBC4);  // ← CHANGÉ
  
  // Backgrounds
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Textes
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFFB2BEC3);
  static const Color textLight = Color(0xFFDFE6E9);
  
  // États
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFD63031);
  static const Color info = Color(0xFF74B9FF);
  
  // Graphiques
  static const Color chartPrimary = Color(0xFF4FD3C4);
  static const Color chartSecondary = Color(0xFFE8B4E8);
  static const Color chartTertiary = Color(0xFF74B9FF);
  static const Color chartBackground = Color(0xFFF0F9F8);
  
  // UI Elements
  static const Color divider = Color(0xFFECF0F1);
  static const Color border = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDC3C7);
  static const Color shadow = Color(0x1A000000);
  
  // Tracker d'habitudes
  static const Color habitCompleted = Color(0xFF4FD3C4);
  static const Color habitIncomplete = Color(0xFFE8E8E8);
  static const Color habitIncompleteLight = Color(0xFFA2EFD5);

  
  // Bottom Navigation
  static const Color bottomNavSelected = Color(0xFF4FD3C4);
  static const Color bottomNavUnselected = Color(0xFFBDC3C7);
  // Gradient Colors (pour usage dans AppGradients)
  static const Color gradientStart = Color(0xFF4FD3C4);
  static const Color gradientEnd = Color(0xFF6FE5D5);
}
