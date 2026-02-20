import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';

class MetricChart extends StatelessWidget {
  final Map<DateTime, double> data;
  final Color color;
  final DateTime weekStart;  

  const MetricChart({
    super.key,
    required this.data,
    required this.color,
    required this.weekStart,  
  });

  @override
  Widget build(BuildContext context) {

    final lineBarDataList = _createLineSegments();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 10,
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2.5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                final index = value.toInt();
                if (index >= 0 && index < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[index],
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: lineBarDataList.isEmpty 
            ? [] 
            : lineBarDataList,
      ),
    );
  }

  List<LineChartBarData> _createLineSegments() {
    if (data.isEmpty) return [];


    final weekValues = List<double?>.filled(7, null);
    
    for (int i = 0; i < 7; i++) {
      final currentDate = weekStart.add(Duration(days: i));
      final dateOnly = DateTime(currentDate.year, currentDate.month, currentDate.day);
      

      for (var entry in data.entries) {
        final entryDateOnly = DateTime(entry.key.year, entry.key.month, entry.key.day);
        if (entryDateOnly.year == dateOnly.year && 
            entryDateOnly.month == dateOnly.month && 
            entryDateOnly.day == dateOnly.day) {
          weekValues[i] = entry.value;
          break;
        }
      }
    }


    final segments = <LineChartBarData>[];
    List<FlSpot> currentSegment = [];

    for (int i = 0; i < 7; i++) {
      if (weekValues[i] != null) {

        currentSegment.add(FlSpot(i.toDouble(), weekValues[i]!));
      } else {
        if (currentSegment.isNotEmpty) {
          segments.add(_createLineSegment(currentSegment));
          currentSegment = [];
        }
      }
    }


    if (currentSegment.isNotEmpty) {
      segments.add(_createLineSegment(currentSegment));
    }

    return segments;
  }

  LineChartBarData _createLineSegment(List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 5,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}