import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RainChart extends StatelessWidget {
  final List<double> data;

  const RainChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (i) => FlSpot(i.toDouble(), data[i]),
              ),
              isCurved: true,
              barWidth: 3,
            )
          ],
        ),
      ),
    );
  }
}