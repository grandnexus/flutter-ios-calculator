import 'package:flutter/material.dart';
import 'package:flutter_ios_calculator/widgets/currency_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// This file contains widget tests for the `CurrencyButton` component
/// in the Flutter application. The test verifies that the button
/// correctly handles user interactions by calling the `onPressed`
/// callback when tapped. It also checks that the button displays
/// the provided text and icon properly.
///
/// Dependencies:
/// - `flutter/material.dart`: For building the Flutter widget tree.
/// - `flutter_test`: For testing Flutter widgets and functionalities.
/// - `font_awesome_flutter`: For using Font Awesome icons in the button.
void main() {
  testWidgets('CurrencyButton calls onPressed when tapped',
      (WidgetTester tester) async {
    // Define a variable to capture the onPressed callback
    bool isPressed = false;

    // Build the CurrencyButton widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CurrencyButton(
            text: 'USD',
            onPressed: () {
              isPressed = true; // Update variable when button is pressed
            },
          ),
        ),
      ),
    );

    // Verify that the initial text and icon are rendered correctly
    expect(find.text('USD'), findsOneWidget);
    expect(find.byType(FaIcon), findsOneWidget);

    // Simulate tap on the button
    await tester.tap(find.byType(CurrencyButton));
    await tester
        .pump(); // Allow time for state change and animations to complete

    // Verify that onPressed was called
    expect(isPressed, isTrue);
  });
}
