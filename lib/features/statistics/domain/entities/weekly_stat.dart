import 'package:equatable/equatable.dart';

class WeeklyStat extends Equatable {
  final DateTime weekStart;
  final double averageHumeur;
  final double averageMotivation;
  final double averageSommeil;
  final Map<DateTime, double> dailyValues;

  const WeeklyStat({
    required this.weekStart,
    required this.averageHumeur,
    required this.averageMotivation,
    required this.averageSommeil,
    required this.dailyValues,
  });

  double get overallAverage => 
      (averageHumeur + averageMotivation + averageSommeil) / 3;

  @override
  List<Object> get props => [
        weekStart,
        averageHumeur,
        averageMotivation,
        averageSommeil,
        dailyValues,
      ];
}
