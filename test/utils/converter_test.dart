import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:flutter_ios_calculator/utils/converter.dart'; // Import the Converter class
import 'package:http/http.dart'
    as http; // Import the HTTP package for API calls
import 'package:flutter_test/flutter_test.dart'; // Import Flutter testing utilities
import 'package:mockito/mockito.dart'; // Import Mockito for creating mock objects
import 'package:mockito/annotations.dart'; // Import annotations for generating mock classes

import 'converter_test.mocks.dart'; // Import generated mock classes

/// This file contains unit tests for the `Converter` class in the
/// Flutter application. It uses the `mockito` package to create mock
/// HTTP client responses for API calls related to currency conversion.
/// The tests validate fetching available currencies, fetching the latest
/// exchange rates, conversion functionality, and handling error cases
/// when API calls fail.
///
/// Dependencies:
/// - `flutter_test`: For testing Flutter functionalities.
/// - `mockito`: For creating mock objects and simulating API responses.
/// - `http`: For making HTTP requests to the currency conversion APIs.
@GenerateMocks([http.Client])
void main() {
  // Ensure the test environment is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Define constants for API key and URLs for currency conversion
  const String apiKey = '';
  const String currenciesUrl =
      'https://api.freecurrencyapi.com/v1/currencies?apikey=$apiKey';
  const String latestUrl =
      'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&base_currency=USD&currencies=SGD';

  // Create instances of MockClient and Converter
  final mockClient = MockClient();
  final converter = Converter(
    baseCurrency: 'USD', // Set the base currency to USD
    baseAmount: 1.0, // Set the base amount for conversion
    targetCurrency: 'SGD', // Set the target currency to SGD
    targetAmount: 0.77, // Set the target amount for conversion
    exchangeRate: 0.77, // Set the exchange rate
  );

  // Group of tests for the Converter class
  group('Converter Functionality Tests', () {
    // Test for fetching available currencies
    test('fetchCurrencies returns a map of Currency objects', () async {
      // Arrange: Mock API response for currency data
      final mockResponse = {
        "data": {
          "USD": {"name": "United States Dollar", "code": "USD"},
          "SGD": {"name": "Singapore Dollar", "code": "SGD"},
        }
      };
      // Set up the mock client to return the mock response when the URL is called
      when(mockClient.get(Uri.parse(currenciesUrl))).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponse), 200));

      // Act: Call the fetchCurrencies method
      final currencies =
          await Converter.fetchCurrencies(mockClient: mockClient);

      // Assert: Check if the returned currencies are correct
      expect(currencies.length, 2); // Check the length of the currencies map
      expect(
          currencies['USD']!.name, 'United States Dollar'); // Validate USD name
      expect(currencies['SGD']!.name, 'Singapore Dollar'); // Validate SGD name
    });

    // Test for fetching the latest exchange rate
    test('fetchLatest returns a Converter instance', () async {
      // Arrange: Mock API response for the latest exchange rate
      final mockResponse = {
        "data": {"SGD": 0.77}
      };
      // Set up the mock client to return the mock response for the latest exchange rate
      when(mockClient.get(Uri.parse(latestUrl))).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponse), 200));

      // Act: Call the fetchLatest method
      final result =
          await Converter.fetchLatest('USD', 'SGD', mockClient: mockClient);

      // Assert: Check if the returned Converter instance has correct values
      expect(result.baseCurrency, 'USD'); // Check base currency
      expect(result.targetCurrency, 'SGD'); // Check target currency
      expect(result.exchangeRate, 0.77); // Check exchange rate
    });

    // Test for the convert method of the Converter class
    test('convert method works correctly', () {
      // Act: Call the convert method with 100
      final result = converter.convert(100);

      // Assert: Verify the conversion result is correct
      expect(result, 77.0); // Check that converting 100 gives 77 (100 * 0.77)
    });

    // Test for fetching currencies throwing an exception on failure
    test('fetchCurrencies throws an exception on failure', () async {
      // Arrange: Mock a failure response for fetching currencies
      when(mockClient.get(Uri.parse(currenciesUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert: Ensure an exception is thrown when fetching currencies
      expect(
          () async => await Converter.fetchCurrencies(mockClient: mockClient),
          throwsException);
    });

    // Test for fetching the latest exchange rate throwing an exception on failure
    test('fetchLatest throws an exception on failure', () async {
      // Arrange: Mock a failure response for fetching the latest exchange rate
      when(mockClient.get(Uri.parse(latestUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert: Ensure an exception is thrown when fetching the latest exchange rate
      expect(
          () async =>
              await Converter.fetchLatest('USD', 'SGD', mockClient: mockClient),
          throwsException);
    });
  });
}
