import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<dynamic> data = [];
  String _selectedOption = "country";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/pedrosantos992/web_dash_fl/main/assets/users.json'));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load JSON data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics Page"),
      ),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: _selectedOption,
                    items: const [
                      DropdownMenuItem(
                        value: "gender",
                        child: Text("Gender"),
                      ),
                      DropdownMenuItem(
                        value: "shirt_size",
                        child: Text("Shirt Size"),
                      ),
                      DropdownMenuItem(
                        value: "country",
                        child: Text("Country"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedOption == "country")
                    Expanded(child: _buildBarChart())
                  else if (_selectedOption == "gender" ||
                      _selectedOption == "shirt_size")
                    Expanded(child: _buildPieChart()),
                ],
              ),
            ),
    );
  }

  Widget _buildBarChart() {
    Map<String, int> chartData = {};

    for (var user in data) {
      String key = user[_selectedOption];
      chartData[key] = (chartData[key] ?? 0) + 1;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(top: 72.0),
        child: SizedBox(
          width: chartData.length * 80.0,
          child: BarChart(
            BarChartData(
              barGroups: chartData.entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key.hashCode,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: Colors.green,
                      width: 15,
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final title = chartData.keys.firstWhere(
                        (key) => key.hashCode == value.toInt(),
                        orElse: () => '',
                      );
                      return Text(title);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    Map<String, int> chartData = {};

    for (var user in data) {
      String key = user[_selectedOption];
      chartData[key] = (chartData[key] ?? 0) + 1;
    }

    return PieChart(
      PieChartData(
        sections: chartData.entries.map((entry) {
          return PieChartSectionData(
            title: "${entry.key}: ${entry.value.toString()}",
            value: entry.value.toDouble(),
            color: _getRandomColor(entry.key),
          );
        }).toList(),
      ),
    );
  }

  Color _getRandomColor(String key) {
    return Color((0xFF000000 + (0xFFFFFF * (key.hashCode % 255))).toInt());
  }
}

void main() {
  runApp(const MaterialApp(home: AnalyticsPage()));
}
