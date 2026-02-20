import 'package:flutter/material.dart';


enum MetricType {
  humeur,
  motivation,
  sommeil;

  String get displayName {
    switch (this) {
      case MetricType.humeur:
        return 'Humeur';
      case MetricType.motivation:
        return 'Motivation';
      case MetricType.sommeil:
        return 'Sommeil';
    }
  }

  Color get color {
    switch (this) {
      case MetricType.humeur:
        return const Color(0xFF62E1BB);
      case MetricType.motivation:
        return const Color(0xFF6BCEF2);
      case MetricType.sommeil:
        return const Color(0xFFFF6B9D);
    }
  }

  double calculateAverage(List<dynamic> moods) {
    if (moods.isEmpty) return 0;
    
    double sum = 0;
    for (var mood in moods) {
      switch (this) {
        case MetricType.humeur:
          sum += mood.humeur;
          break;
        case MetricType.motivation:
          sum += mood.motivation;
          break;
        case MetricType.sommeil:
          sum += mood.sommeil;
          break;
      }
    }
    return sum / moods.length;
  }

  Map<DateTime, double> extractDataPoints(List<dynamic> moods) {
    final data = <DateTime, double>{};
    
    for (var mood in moods) {
      switch (this) {
        case MetricType.humeur:
          data[mood.date] = mood.humeur;
          break;
        case MetricType.motivation:
          data[mood.date] = mood.motivation;
          break;
        case MetricType.sommeil:
          data[mood.date] = mood.sommeil;
          break;
      }
    }
    
    return data;
  }
}