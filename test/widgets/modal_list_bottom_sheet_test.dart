import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ios_calculator/widgets/modal_list_bottom_sheet.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'modal_list_bottom_sheet_test.mocks.dart';

/// This file contains widget tests for the `ModalListBottomSheet` component
/// in the Flutter application. The tests verify the following functionalities:
///
/// - The loading indicator is displayed while fetching currencies.
/// - The currency list is displayed correctly when currencies are fetched successfully.
/// - An error message is shown if fetching currencies fails.
/// - A currency can be selected and the modal closes with the selected currency.
///
/// Dependencies:
/// - `flutter/material.dart`: For building the Flutter widget tree.
/// - `flutter_test`: For testing Flutter widgets and functionalities.
/// - `mockito`: For creating mock objects to simulate API responses.
/// - `http`: For making HTTP requests to fetch currency data.
@GenerateMocks([http.Client])
void main() {
  const String apiKey = '';
  const String currenciesUrl =
      'https://api.freecurrencyapi.com/v1/currencies?apikey=$apiKey';
  final mockClient = MockClient();

  final Map<String, dynamic> mockResponse = {
    "data": {
      "USD": {"name": "United States Dollar", "code": "USD"},
      "SGD": {"name": "Singapore Dollar", "code": "SGD"},
      "EUR": {"name": "Euro", "code": "EUR"},
    }
  };

  // Set up common widget for testing
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ModalListBottomSheet(
        currencyCode: 'USD',
        mockClient: mockClient,
      ),
    );
  }

  // Test when no currencies are fetched
  testWidgets('ModalListBottomSheet shows loading indicator',
      (WidgetTester tester) async {
    when(mockClient.get(Uri.parse(currenciesUrl)))
        .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    await tester.pumpWidget(createWidgetUnderTest());

    // Initially, a loading indicator should be shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the loading to complete
    await tester.pumpAndSettle();

    // After loading, it should show the list
    expect(find.byType(PageView), findsOneWidget);
  });

  // Test when currencies are fetched successfully
  testWidgets('ModalListBottomSheet displays currency list',
      (WidgetTester tester) async {
    when(mockClient.get(Uri.parse(currenciesUrl)))
        .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify that the currency names are displayed
    expect(find.text('United States Dollar'), findsOneWidget);
    expect(find.text('Singapore Dollar'), findsOneWidget);
  });

  // Test when currencies fetching fails
  testWidgets('ModalListBottomSheet shows error message on fetch failure',
      (WidgetTester tester) async {
    when(mockClient.get(Uri.parse(currenciesUrl)))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify that the error message is displayed
    expect(find.text('Failed to load currencies'), findsOneWidget);
  });

  // Test selecting a currency
  testWidgets('ModalListBottomSheet selects a currency',
      (WidgetTester tester) async {
    when(mockClient.get(Uri.parse(currenciesUrl)))
        .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap on the EUR currency
    await tester.tap(find.text('Euro'));
    await tester.pumpAndSettle(); // Wait for the animation

    // Verify that the ModalBottomSheet is popped with the selected currency
    expect(find.text('Euro'), findsNothing); // should not show anymore
  });
}
