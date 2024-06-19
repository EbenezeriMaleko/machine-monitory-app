import 'package:flutter/material.dart';
import 'package:machine_monitory/data/database_helper.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> temperatureData = [];
  List<Map<String, dynamic>> pressureData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<Map<String, dynamic>> tempData =
        await DatabaseHelper().fetchData('temperature');
    List<Map<String, dynamic>> pressData =
        await DatabaseHelper().fetchData('pressure');

    setState(() {
      temperatureData = tempData;
      pressureData = pressData;
    });
  }

  String formatTimestamp(String timestamp) {
    DateTime utcTime = DateTime.parse(timestamp);
    DateTime localTime = utcTime.add(const Duration(hours: 3));
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Temperature Data', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: temperatureData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${temperatureData[index]['value']} °C'),
                    subtitle: Text(
                        formatTimestamp(temperatureData[index]['timestamp'])),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pressure Data', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: pressureData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${pressureData[index]['value']} Pa'),
                    subtitle:
                        Text(formatTimestamp(pressureData[index]['timestamp'])),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
