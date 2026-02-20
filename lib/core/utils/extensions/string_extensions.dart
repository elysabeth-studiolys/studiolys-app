/// Extensions pour les chaînes de caractères
extension StringExtensions on String {
  /// Capitalise la première lettre
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalise chaque mot
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Vérifie si la chaîne est vide ou null
  bool get isNullOrEmpty => trim().isEmpty;

  /// Vérifie si la chaîne n'est ni vide ni null
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Tronque la chaîne à une longueur donnée
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Supprime tous les espaces
  String removeAllWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }
}
