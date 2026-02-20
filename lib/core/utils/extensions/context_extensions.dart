import 'package:flutter/material.dart';

/// Extensions pour BuildContext
extension ContextExtensions on BuildContext {
  /// Accès rapide au thème
  ThemeData get theme => Theme.of(this);

  /// Accès rapide au text theme
  TextTheme get textTheme => theme.textTheme;

  /// Accès rapide au color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Accès rapide à la taille de l'écran
  Size get screenSize => MediaQuery.of(this).size;

  /// Accès rapide à la largeur de l'écran
  double get screenWidth => screenSize.width;

  /// Accès rapide à la hauteur de l'écran
  double get screenHeight => screenSize.height;

  /// Accès rapide aux padding du MediaQuery (safe area)
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  /// Accès rapide aux insets du MediaQuery
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Vérifie si le clavier est visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Navigation
  NavigatorState get navigator => Navigator.of(this);

  /// Affiche un SnackBar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Affiche un SnackBar de succès
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Affiche un SnackBar d'erreur
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Ferme le clavier
  void closeKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
