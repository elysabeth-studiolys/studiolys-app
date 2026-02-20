/// Validateurs pour les formulaires et les données
class Validators {
  Validators._();

  /// Valide que la valeur n'est pas vide
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "Ce champ"} est requis';
    }
    return null;
  }

  /// Valide qu'un nombre est dans une plage donnée
  static String? rangeValidator(
    double value,
    double min,
    double max, [
    String? fieldName,
  ]) {
    if (value < min || value > max) {
      return '${fieldName ?? "La valeur"} doit être entre $min et $max';
    }
    return null;
  }

  /// Valide que la valeur est un nombre
  static String? number(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) {
      return '${fieldName ?? "Ce champ"} doit être un nombre';
    }
    return null;
  }

  /// Valide la longueur minimale
  static String? minLength(String? value, int length, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    if (value.length < length) {
      return '${fieldName ?? "Ce champ"} doit contenir au moins $length caractères';
    }
    return null;
  }

  /// Valide la longueur maximale
  static String? maxLength(String? value, int length, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    if (value.length > length) {
      return '${fieldName ?? "Ce champ"} ne peut pas dépasser $length caractères';
    }
    return null;
  }
}
