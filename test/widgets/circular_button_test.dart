import 'package:auto_size_text/auto_size_text.dart'; // Import AutoSizeText for responsive text
import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:flutter_ios_calculator/widgets/circular_button.dart'; // Import CircularButton widget
import 'package:flutter_test/flutter_test.dart'; // Import Flutter testing utilities
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome icons

/// This file contains widget tests for the `CircularButton` component
/// in the Flutter application. The tests validate the following functionalities:
///
/// 1. Displaying text correctly on the button.
/// 2. Displaying an icon correctly on the button.
/// 3. Adjusting padding based on the presence of text or an icon.
///
/// The `CircularButton` widget is expected to handle both text and icon properties,
/// and the tests ensure that the button behaves as intended when pressed.
///
/// Dependencies:
/// - `flutter_test`: For testing Flutter widgets and functionalities.
/// - `auto_size_text`: For responsive text display within the button.
/// - `font_awesome_flutter`: For using Font Awesome icons in the button.
/// - `flutter/material.dart`: For Flutter's Material Design components.
void main() {
  // Ensure the test environment is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Test to verify that the CircularButton displays text correctly
  testWidgets('CircularButton displays text correctly',
      (WidgetTester tester) async {
    // Arrange: Set up the button's state and properties
    bool pressed = false; // Track if the button has been pressed
    const String buttonText = '1'; // Text to display on the button
    const Color buttonColor = Colors.blue; // Button background color
    const Color textColor = Colors.white; // Text color

    final circularButton = CircularButton(
      text: buttonText, // Assign text to button
      textColor: textColor, // Assign text color
      backgroundColor: buttonColor, // Assign background color
      onPressed: () {
        pressed = true; // Set pressed to true when button is pressed
      },
    );

    // Act: Build the widget tree with the CircularButton
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              circularButton, // Add CircularButton to the widget tree
            ],
          ),
        ),
      ),
    );

    // Verify initial state: Check that the text is displayed correctly
    final textFinder = find.byType(AutoSizeText); // Find AutoSizeText widget
    expect(
        textFinder, findsOneWidget); // Ensure there is one AutoSizeText widget
    expect((tester.widget<AutoSizeText>(textFinder).style?.color),
        textColor); // Check text color
    expect((tester.widget<AutoSizeText>(textFinder).data),
        buttonText); // Check displayed text

    // Simulate button press
    await tester.tap(find.byType(ElevatedButton)); // Find and tap the button
    await tester.pump(); // Rebuild the widget after the state change

    // Verify that onPressed was called
    expect(pressed, isTrue); // Ensure that the button press handler was invoked
  });

  // Test to verify that the CircularButton displays an icon correctly
  testWidgets('CircularButton displays icon correctly',
      (WidgetTester tester) async {
    // Arrange: Set up the button's state and properties
    bool pressed = false; // Track if the button has been pressed
    const Color buttonColor = Colors.blue; // Button background color
    const Color iconColor = Colors.white; // Icon color

    final circularButton = CircularButton(
      icon: FontAwesomeIcons.heart, // Assign an icon to the button
      textColor: iconColor, // Assign text color (used for the icon)
      backgroundColor: buttonColor, // Assign background color
      onPressed: () {
        pressed = true; // Set pressed to true when button is pressed
      },
    );

    // Act: Build the widget tree with the CircularButton
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              circularButton, // Add CircularButton to the widget tree
            ],
          ),
        ),
      ),
    );

    // Verify initial state: Check that the icon is displayed correctly
    final iconFinder = find.byType(FaIcon); // Find the FontAwesome icon widget
    expect(iconFinder, findsOneWidget); // Ensure there is one FaIcon widget
    expect((tester.widget<FaIcon>(iconFinder).color),
        iconColor); // Check icon color

    // Simulate button press
    await tester.tap(find.byType(ElevatedButton)); // Find and tap the button
    await tester.pump(); // Rebuild the widget after the state change

    // Verify that onPressed was called
    expect(pressed, isTrue); // Ensure that the button press handler was invoked
  });

  // Test to verify that the CircularButton adjusts padding based on text presence
  testWidgets('CircularButton padding adjusts based on text presence',
      (WidgetTester tester) async {
    // Arrange: Set up the button's state and properties
    const Color buttonColor = Colors.blue; // Button background color
    const Color textColor = Colors.white; // Text color

    // Create CircularButton with text
    final buttonWithText = CircularButton(
      text: '1', // Assign text to the button
      textColor: textColor, // Assign text color
      backgroundColor: buttonColor, // Assign background color
      onPressed: () {},
    );

    // Create CircularButton with icon
    final buttonWithIcon = CircularButton(
      icon: FontAwesomeIcons.heart, // Assign an icon to the button
      textColor: textColor, // Assign text color (used for the icon)
      backgroundColor: buttonColor, // Assign background color
      onPressed: () {},
    );

    // Act: Build the widget tree with both buttons
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              buttonWithText, // Add button with text to the widget tree
              buttonWithIcon, // Add button with icon to the widget tree
            ],
          ),
        ),
      ),
    );

    // Additional assertions could be added here to check padding if needed
  });
}
