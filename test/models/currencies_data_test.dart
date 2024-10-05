import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ios_calculator/models/currency.dart';
import 'package:flutter_ios_calculator/models/currencies_data.dart'; // Import your CurrenciesData class

/// Unit tests for the [CurrenciesData] class.
///
/// This file contains tests to verify the correct creation and
/// functionality of the [CurrenciesData] and [Currency] classes.
/// It includes tests for:
/// - Creating a [CurrenciesData] object from JSON.
/// - Converting a [CurrenciesData] object back to JSON.
/// - Ensuring that the properties of the currencies are correct.
///
/// The following currencies are tested:
/// - United States Dollar (USD)
/// - Singapore Dollar (SGD)
void main() {
  const currencyJson = <String, Map<String, dynamic>>{
    'USD': {
      'symbol': '\$',
      'name': 'United States Dollar',
      'symbol_native': '\$',
      'decimal_digits': 2,
      'rounding': 0,
      'code': 'USD',
      'name_plural': 'US dollars',
    },
    'SGD': {
      'symbol': 'S\$',
      'name': 'Singapore Dollar',
      'symbol_native': '\$',
      'decimal_digits': 2,
      'rounding': 0,
      'code': 'SGD',
      'name_plural': 'Singapore dollars',
    },
  };

  group('CurrenciesData Functionality Tests', () {
    final expectedCurrenciesData = CurrenciesData(currencies: {
      for (var entry in currencyJson.entries)
        entry.key: Currency.fromJson(entry.value),
    });

    test('creates CurrenciesData object from JSON', () {
      final currenciesData = CurrenciesData.fromJson({'data': currencyJson});

      expect(currenciesData.currencies.length,
          expectedCurrenciesData.currencies.length);
      expect(currenciesData.currencies, expectedCurrenciesData.currencies);
    });

    test('converts CurrenciesData object to JSON', () {
      expect(expectedCurrenciesData.toJson(), {'data': currencyJson});
    });

    test('has the correct currencies', () {
      expect(
        expectedCurrenciesData.currencies['USD']!.name,
        'United States Dollar',
      );
      expect(
          expectedCurrenciesData.currencies['SGD']!.name, 'Singapore Dollar');
      expect(expectedCurrenciesData.currencies['USD']!.symbol, '\$');
      expect(expectedCurrenciesData.currencies['SGD']!.symbol, 'S\$');
    });
  });
}
