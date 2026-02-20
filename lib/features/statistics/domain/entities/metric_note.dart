class MetricNote {
  final String id;
  final String metricType; 
  final DateTime weekStart;
  final String content;
  final DateTime createdAt;

  const MetricNote({
    required this.id,
    required this.metricType,
    required this.weekStart,
    required this.content,
    required this.createdAt,
  });
}