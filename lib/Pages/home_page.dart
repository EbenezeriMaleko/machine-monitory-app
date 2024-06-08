import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/—Pngtree—vector tools repair icon_3989997.png', // Path to the logo image
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'View Your Machine Status',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/data');
              },
              child: const Text('GET STARTED'),
            ),
          ],
        ),
      ),
    );
  }
}
