import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            titlesData: const FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
            ),
            gridData: const FlGridData(show: true),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.blue,
                spots: [
                  const FlSpot(0, 1),
                  const FlSpot(1, 1.5),
                  const FlSpot(2, 1.4),
                  const FlSpot(3, 3.4),
                  const FlSpot(4, 2),
                  const FlSpot(5, 2.2),
                  const FlSpot(6, 1.8),
                ],
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.3),
                ),
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: AnalyticsPage()));
