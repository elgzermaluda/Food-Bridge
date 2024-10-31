import 'package:flutter/material.dart';
import 'landing_page.dart'; // Import the LandingPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Bridge',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LandingPage(), // Set LandingPage as the home screen
    );
  }
}
