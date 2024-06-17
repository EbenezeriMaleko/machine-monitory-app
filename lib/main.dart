import 'package:flutter/material.dart';
import 'package:machine_monitory/Pages/data_page.dart';
import 'package:machine_monitory/Pages/history_page.dart';
import 'package:machine_monitory/Pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/data': (context) => const DataPage(),
        '/history':(context) => const HistoryPage(),
      },
    );
  }
}
