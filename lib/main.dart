import 'package:flutter/material.dart';
import 'package:flutter_ios_calculator/pages/pages.dart';

/// The entry point of the application.
///
/// This function initializes the app by calling the [runApp] method with [MyApp].
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// This widget sets up the [MaterialApp] and defines the app's theme and home page.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SF Pro Display', // Specifies the font for the app.
        useMaterial3: true, // Enables Material Design 3.
      ),
      home: const CalculatorPage(), // Sets the initial page of the app.
    );
  }
}
