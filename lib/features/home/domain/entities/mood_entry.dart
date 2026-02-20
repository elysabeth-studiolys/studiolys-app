import 'package:equatable/equatable.dart';


class MoodEntry extends Equatable {
  final String id;
  final DateTime date;
  final double humeur;
  final double motivation;
  final double sommeil;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MoodEntry({
    required this.id,
    required this.date,
    required this.humeur,
    required this.motivation,
    required this.sommeil,
    required this.createdAt,
    this.updatedAt,
  });


  MoodEntry copyWith({
    String? id,
    DateTime? date,
    double? humeur,
    double? motivation,
    double? sommeil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      humeur: humeur ?? this.humeur,
      motivation: motivation ?? this.motivation,
      sommeil: sommeil ?? this.sommeil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  double get average => (humeur + motivation + sommeil) / 3;

  @override
  List<Object?> get props => [
        id,
        date,
        humeur,
        motivation,
        sommeil,
        createdAt,
        updatedAt,
      ];
}
