import 'package:flutter/material.dart';
import 'package:flutter_ios_calculator/widgets/toggle_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// This file contains widget tests for the `ToggleButton` component
/// in the Flutter application. The tests ensure that the button behaves
/// as expected when interacted with:
///
/// - It verifies that the `onPressed` callback is triggered when the button
///   is tapped.
/// - It checks the correct rendering of the FontAwesome icon within the button.
///
/// Dependencies:
/// - `flutter/material.dart`: For building the Flutter widget tree.
/// - `flutter_test`: For testing Flutter widgets and functionalities.
/// - `font_awesome_flutter`: For using FontAwesome icons in the widget.
void main() {
  testWidgets('ToggleButton calls onPressed when tapped',
      (WidgetTester tester) async {
    // Arrange
    bool isPressed = false;
    final toggleButton = ToggleButton(
      icon: FontAwesomeIcons.heart, // Use the appropriate FontAwesome icon
      onPressed: () {
        isPressed = true; // Change this variable when the button is pressed
      },
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: toggleButton),
        ),
      ),
    );

    // Verify initial state
    final iconFinder = find.byType(FaIcon);
    expect(iconFinder, findsOneWidget);

    // Simulate a tap
    await tester.tap(iconFinder);
    await tester.pump(); // Rebuild after tap

    // Verify the onPressed callback was called
    expect(isPressed, isTrue);
  });
}
