import 'package:intl/intl.dart';
import '../constants/app_strings.dart';

/// Helper pour la manipulation des dates
class DateHelper {
  DateHelper._();

  /// Formatte une date selon le pattern fourni
  static String format(DateTime date, String pattern) {
    return DateFormat(pattern, 'fr_FR').format(date);
  }

  /// Retourne la date du jour à minuit
  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Retourne le nom du jour de la semaine (court)
  static String getShortDayName(int weekday) {
    switch (weekday) {
      case 1:
        return AppStrings.monday;
      case 2:
        return AppStrings.tuesday;
      case 3:
        return AppStrings.wednesday;
      case 4:
        return AppStrings.thursday;
      case 5:
        return AppStrings.friday;
      case 6:
        return AppStrings.saturday;
      case 7:
        return AppStrings.sunday;
      default:
        return '';
    }
  }

  /// Retourne le nom du jour de la semaine (complet)
  static String getFullDayName(int weekday) {
    switch (weekday) {
      case 1:
        return AppStrings.mondayFull;
      case 2:
        return AppStrings.tuesdayFull;
      case 3:
        return AppStrings.wednesdayFull;
      case 4:
        return AppStrings.thursdayFull;
      case 5:
        return AppStrings.fridayFull;
      case 6:
        return AppStrings.saturdayFull;
      case 7:
        return AppStrings.sundayFull;
      default:
        return '';
    }
  }

  /// Retourne le nom du mois (court)
  static String getShortMonthName(int month) {
    switch (month) {
      case 1:
        return AppStrings.january;
      case 2:
        return AppStrings.february;
      case 3:
        return AppStrings.march;
      case 4:
        return AppStrings.april;
      case 5:
        return AppStrings.may;
      case 6:
        return AppStrings.june;
      case 7:
        return AppStrings.july;
      case 8:
        return AppStrings.august;
      case 9:
        return AppStrings.september;
      case 10:
        return AppStrings.october;
      case 11:
        return AppStrings.november;
      case 12:
        return AppStrings.december;
      default:
        return '';
    }
  }

  /// Retourne le nom du mois (complet)
  static String getFullMonthName(int month) {
    switch (month) {
      case 1:
        return AppStrings.januaryFull;
      case 2:
        return AppStrings.februaryFull;
      case 3:
        return AppStrings.marchFull;
      case 4:
        return AppStrings.aprilFull;
      case 5:
        return AppStrings.mayFull;
      case 6:
        return AppStrings.juneFull;
      case 7:
        return AppStrings.julyFull;
      case 8:
        return AppStrings.augustFull;
      case 9:
        return AppStrings.septemberFull;
      case 10:
        return AppStrings.octoberFull;
      case 11:
        return AppStrings.novemberFull;
      case 12:
        return AppStrings.decemberFull;
      default:
        return '';
    }
  }

  /// Formatte une date en format "Jeudi 1er Janvier"
  static String formatFullDate(DateTime date) {
    final dayName = getFullDayName(date.weekday);
    final day = date.day;
    final suffix = day == 1 ? 'er' : '';
    final monthName = getFullMonthName(date.month);
    return '$dayName $day$suffix $monthName';
  }

  /// Retourne la liste des 7 derniers jours
  static List<DateTime> getLastWeek() {
    final today = DateHelper.today;
    return List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });
  }

  /// Retourne le lundi de la semaine courante
  static DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Retourne le dimanche de la semaine courante
  static DateTime getWeekEnd(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  /// Formate une plage de dates pour l'affichage de la semaine
  /// Ex: "29-3 Janvier" ou "27 Jan - 2 Fév"
  static String formatWeekRange(DateTime start, DateTime end) {
    if (start.month == end.month) {
      return '${start.day}-${end.day} ${getFullMonthName(start.month)}';
    } else {
      return '${start.day} ${getShortMonthName(start.month)} - ${end.day} ${getShortMonthName(end.month)}';
    }
  }

  /// Vérifie si deux dates sont le même jour
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Retourne le nombre de jours entre deux dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
