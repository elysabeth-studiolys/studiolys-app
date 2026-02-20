import '../date_helper.dart';

/// Extensions pour DateTime
extension DateTimeExtensions on DateTime {
  /// Retourne la date sans l'heure
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  /// Vérifie si c'est aujourd'hui
  bool get isToday {
    final now = DateTime.now();
    return DateHelper.isSameDay(this, now);
  }

  /// Vérifie si c'est demain
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return DateHelper.isSameDay(this, tomorrow);
  }

  /// Vérifie si c'est hier
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return DateHelper.isSameDay(this, yesterday);
  }

  /// Retourne le début de la semaine (lundi)
  DateTime get weekStart {
    return DateHelper.getWeekStart(this);
  }

  /// Retourne la fin de la semaine (dimanche)
  DateTime get weekEnd {
    return DateHelper.getWeekEnd(this);
  }

  /// Ajoute des jours
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  /// Soustrait des jours
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  /// Formate en date complète (ex: "Jeudi 1er Janvier")
  String toFullDateString() {
    return DateHelper.formatFullDate(this);
  }

  /// Retourne le nom du jour (court)
  String get shortDayName {
    return DateHelper.getShortDayName(weekday);
  }

  /// Retourne le nom du jour (complet)
  String get fullDayName {
    return DateHelper.getFullDayName(weekday);
  }

  /// Retourne le nom du mois (court)
  String get shortMonthName {
    return DateHelper.getShortMonthName(month);
  }

  /// Retourne le nom du mois (complet)
  String get fullMonthName {
    return DateHelper.getFullMonthName(month);
  }
}
