import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:machine_monitory/data/database_helper.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  String temperature = 'Loading...';
  String pressure = 'Loading...';
  Timer? timer;
  List<double> temperatureData = [];
  List<double> pressureData = [];

  final String blynkAuthToken = 'ypoNXlByUxnZnIrZOzgU3Kh9pSMjZqRH';

  @override
  void initState() {
    super.initState();
    // Fetch data initially
    fetchDataFromBlynk();
    // Set up a timer to fetch data periodically
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => fetchDataFromBlynk());
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchDataFromBlynk() async {
    try {
      final tempUrl = Uri.https('blynk.cloud', '/external/api/get',
          {'token': blynkAuthToken, 'pin': 'V1'});
      final pressureUrl = Uri.https('blynk.cloud', '/external/api/get',
          {'token': blynkAuthToken, 'pin': 'V2'});

      var tempResponse = await http.get(tempUrl);
      var pressureResponse = await http.get(pressureUrl);

      print('Temperature status code: ${tempResponse.statusCode}');
      print('Pressure status code: ${pressureResponse.statusCode}');

      if (tempResponse.statusCode == 200 &&
          pressureResponse.statusCode == 200) {
        double tempValue = double.parse(tempResponse.body);
        double pressureValue = double.parse(pressureResponse.body);
        setState(() {
          temperature = tempResponse.body;
          pressure = pressureResponse.body;

          temperatureData.add(tempValue);
          pressureData.add(pressureValue);
        });

        await DatabaseHelper().insertData('temperature', tempValue);
        await DatabaseHelper().insertData('pressure', pressureValue);

      } else if (tempResponse.statusCode == 400 ||
          pressureResponse.statusCode == 400) {
        setState(() {
          temperature = 'No data available';
          pressure = 'No data available';
        });
      } else {
        throw Exception('Failed to load data from Blynk');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        temperature = 'Error';
        pressure = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DataCard(
              label: 'Temperature',
              value: temperature,
              unit: '°C',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 20),
            DataCard(
              label: 'Pressure',
              value: pressure,
              unit: 'Pa',
              icon: Icons.speed,
            ),
            const SizedBox(height: 20),
            const Text('Temperature Graph', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 2),
                      left: BorderSide(color: Colors.black, width: 2),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  minX: 0,
                  maxX: temperatureData.length.toDouble() - 1,
                  minY: temperatureData.isNotEmpty
                      ? temperatureData.reduce((a, b) => a < b ? a : b) - 5
                      : 0,
                  maxY: temperatureData.isNotEmpty
                      ? temperatureData.reduce((a, b) => a > b ? a : b) + 5
                      : 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: temperatureData.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.red,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pressure Graph', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.black, width: 2),
                      left: BorderSide(color: Colors.black, width: 2),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  minX: 0,
                  maxX: pressureData.length.toDouble() - 1,
                  minY: pressureData.isNotEmpty
                      ? pressureData.reduce((a, b) => a < b ? a : b) - 5
                      : 0,
                  maxY: pressureData.isNotEmpty
                      ? pressureData.reduce((a, b) => a > b ? a : b) + 5
                      : 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: pressureData.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.blue,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const DataCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$value $unit',
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
