import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ios_calculator/pages/calculator_page.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'calculator_page_test.mocks.dart';

/// This file contains unit tests for the `CalculatorPage` widget in the
/// Flutter application. It uses the `mockito` package to create mock
/// HTTP client responses for currency conversion APIs. The tests
/// validate the initial output values, the ability to append numbers,
/// reset functionality, and the toggling of currency outputs.
///
/// Dependencies:
/// - `flutter_test`: For testing Flutter widgets.
/// - `mockito`: For creating mock classes and simulating API responses.
@GenerateMocks([http.Client])
void main() {
  // Ensure the test environment is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Create a mock client
  final mockClient = MockClient();

  // Define constants for API keys and URLs for currency conversion
  const String apiKey = '';
  const String latestSGDToUSDUrl =
      'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&base_currency=SGD&currencies=USD';
  const String latestUSDTOSGDUrl =
      'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&base_currency=USD&currencies=SGD';

  // Mock API responses for testing currency conversions
  final mockSGDToUSDResponse = {
    "data": {"USD": 1.30}
  };
  final mockUSDToSGDResponse = {
    "data": {"SGD": 0.77}
  };

  // Set up mock responses for currency conversion API calls
  when(mockClient.get(Uri.parse(latestSGDToUSDUrl))).thenAnswer(
      (_) async => http.Response(jsonEncode(mockSGDToUSDResponse), 200));
  when(mockClient.get(Uri.parse(latestUSDTOSGDUrl))).thenAnswer(
      (_) async => http.Response(jsonEncode(mockUSDToSGDResponse), 200));

  // Group of widget tests for CalculatorPage
  group('CalculatorPage Widget Tests', () {
    // Test for initial output values
    testWidgets('Initial output should display 0 and 0.00',
        (WidgetTester tester) async {
      // Build the CalculatorPage widget with the mock client
      await tester.pumpWidget(
        MaterialApp(
          home: CalculatorPage(mockClient: mockClient),
        ),
      );

      // Verify that initial output values are correct
      expect(
          find.text('0'), findsNWidgets(2)); // Check for two occurrences of '0'
      expect(find.text('0.00'),
          findsOneWidget); // Check for one occurrence of '0.00'
    });

    // Test for appending numbers to the output
    testWidgets('Appending numbers should update the output',
        (WidgetTester tester) async {
      // Build the CalculatorPage widget with the mock client
      await tester.pumpWidget(
        MaterialApp(
          home: CalculatorPage(mockClient: mockClient),
        ),
      );

      // Simulate tapping on number '7' twice
      await tester.tap(find.text('7'));
      await tester.tap(find.text('7'));
      await tester.pump(); // Rebuild the widget tree

      // Verify the top output has been updated to '77'
      expect(find.text('77'), findsOneWidget);
    });

    // Test for reset functionality
    testWidgets('Reset button should reset outputs to 0 and 0.00',
        (WidgetTester tester) async {
      // Build the CalculatorPage widget with the mock client
      await tester.pumpWidget(
        MaterialApp(
          home: CalculatorPage(mockClient: mockClient),
        ),
      );

      // Append the number '77'
      await tester.tap(find.text('7'));
      await tester.tap(find.text('7'));
      await tester.pump();

      // Simulate tapping the reset button (AC)
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pump(); // Rebuild the widget tree

      // Check if outputs are reset to initial values
      expect(
          find.text('0'), findsNWidgets(2)); // Check for two occurrences of '0'
      expect(find.text('0.00'),
          findsOneWidget); // Check for one occurrence of '0.00'
    });

    // Test for toggling currency
    testWidgets('Toggling currency should swap output values',
        (WidgetTester tester) async {
      // Build the CalculatorPage widget with the mock client
      await tester.pumpWidget(
        MaterialApp(
          home: CalculatorPage(mockClient: mockClient),
        ),
      );

      // Append the number '77'
      await tester.tap(find.text('7'));
      await tester.tap(find.text('7'));
      await tester.pump();

      // Simulate tapping the toggle button
      await tester.tap(find.byKey(const Key('toggle_button')));
      await tester.pump(); // Rebuild the widget tree

      // Verify that the bottom output now displays '77'
      expect(find.text('77'), findsOneWidget);
      expect(find.text('0.00'),
          findsNothing); // Ensure that '0.00' is no longer shown
    });
  });
}
