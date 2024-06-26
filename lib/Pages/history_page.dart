import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:machine_monitory/data/database_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> temperatureData = [];
  List<Map<String, dynamic>> pressureData = [];
  bool isLoading = true;
  bool hasMoreTemperatureData = true;
  bool hasMorePressureData = true;
  DocumentSnapshot? lastTemperatureDocument;
  DocumentSnapshot? lastPressureDocument;
  final int documentLimit = 10;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    await fetchTemperatureData();
    await fetchPressureData();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchTemperatureData() async {
    if (!hasMoreTemperatureData) return;

    var result = await DatabaseHelper().fetchDataWithPagination(
      'temperature',
      documentLimit,
      lastTemperatureDocument,
    );

    if (result.isNotEmpty) {
      lastTemperatureDocument = result.last['document'];
      setState(() {
        temperatureData.addAll(result);
        if (result.length < documentLimit) {
          hasMoreTemperatureData = false;
        }
      });
    } else {
      if (mounted) {
        setState(() {
          hasMoreTemperatureData = false;
        });
      }
    }
  }

  Future<void> fetchPressureData() async {
    if (!hasMorePressureData) return;

    var result = await DatabaseHelper().fetchDataWithPagination(
      'pressure',
      documentLimit,
      lastPressureDocument,
    );

    if (result.isNotEmpty) {
      lastPressureDocument = result.last['document'];
      setState(() {
        pressureData.addAll(result);
        if (result.length < documentLimit) {
          hasMorePressureData = false;
        }
      });
    } else {
      if (mounted) {
        setState(() {
          hasMorePressureData = false;
        });
      }
    }
  }

  String formatTimestamp(DateTime timestamp) {
    DateTime localTime = timestamp;
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(localTime);
  }

  Map<String, double> getLatestValuesPerDay(List<Map<String, dynamic>> data) {
    Map<String, double> latestValues = {};

    for (var record in data) {
      DateTime date = record['timestamp'];
      String dateString = DateFormat('yyyy-MM-dd').format(date);
      double value = record['value'];

      latestValues[dateString] = value;
    }

    return latestValues;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> latestTempValues =
        getLatestValuesPerDay(temperatureData);
    Map<String, double> latestPressValues = getLatestValuesPerDay(pressureData);

    List<BarChartGroupData> temperatureBarGroups =
        latestTempValues.entries.map((entry) {
      return BarChartGroupData(
        x: DateTime.parse(entry.key).millisecondsSinceEpoch,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.red,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    List<BarChartGroupData> pressureBarGroups =
        latestPressValues.entries.map((entry) {
      return BarChartGroupData(
        x: DateTime.parse(entry.key).millisecondsSinceEpoch,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'List'),
              Tab(text: 'Graphs'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Temperature Data',
                            style: TextStyle(fontSize: 20)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: temperatureData.length +
                                (hasMoreTemperatureData ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == temperatureData.length) {
                                fetchTemperatureData();
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListTile(
                                title: Text(
                                    '${temperatureData[index]['value']} °C'),
                                subtitle: Text(formatTimestamp(
                                    temperatureData[index]['timestamp'])),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Pressure Data',
                            style: TextStyle(fontSize: 20)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: pressureData.length +
                                (hasMorePressureData ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == pressureData.length) {
                                fetchPressureData();
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListTile(
                                title:
                                    Text('${pressureData[index]['value']} Pa'),
                                subtitle: Text(formatTimestamp(
                                    pressureData[index]['timestamp'])),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Temperature Data',
                            style: TextStyle(fontSize: 20)),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              minY: 0,
                              maxY: 300,
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: temperatureBarGroups,
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      String date = DateFormat('MM-dd').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              value.toInt()));
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(date),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Pressure Data',
                            style: TextStyle(fontSize: 20)),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              minY: 0,
                              maxY: 1000,
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: pressureBarGroups,
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      String date = DateFormat('MM-dd').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              value.toInt()));
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(date),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
