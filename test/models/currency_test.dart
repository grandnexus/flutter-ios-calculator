import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ios_calculator/models/currency.dart';

/// Unit tests for the [Currency] class.
///
/// This file tests the creation, conversion, and properties of the
/// [Currency] class, verifying that the class behaves as expected
/// when initialized from JSON and when converted back to JSON.
///
/// Currencies tested:
/// - United States Dollar (USD)
/// - Singapore Dollar (SGD)
void main() {
  group('Currency', () {
    const currencyJson = {
      'symbol': '\$',
      'name': 'United States Dollar',
      'symbol_native': '\$',
      'decimal_digits': 2,
      'rounding': 0,
      'code': 'USD',
      'name_plural': 'US dollars',
    };

    // Test Currency object creation from JSON
    test('creates Currency object from JSON', () {
      final currency = Currency.fromJson(currencyJson);

      expect(currency.symbol, '\$');
      expect(currency.name, 'United States Dollar');
      expect(currency.symbolNative, '\$');
      expect(currency.decimalDigits, 2);
      expect(currency.rounding, 0);
      expect(currency.code, 'USD');
      expect(currency.namePlural, 'US dollars');
    });

    // Test Currency object conversion to JSON
    test('converts Currency object to JSON', () {
      final currency = Currency.fromJson(currencyJson);

      expect(currency.toJson(), currencyJson);
    });

    // Test properties of Currency class
    test('has the correct properties', () {
      final currency = Currency(
        symbol: 'S\$',
        name: 'Singapore Dollar',
        symbolNative: '\$',
        decimalDigits: 2,
        rounding: 0,
        code: 'SGD',
        namePlural: 'Singapore dollars',
      );

      expect(currency.symbol, 'S\$');
      expect(currency.name, 'Singapore Dollar');
      expect(currency.symbolNative, '\$');
      expect(currency.decimalDigits, 2);
      expect(currency.rounding, 0);
      expect(currency.code, 'SGD');
      expect(currency.namePlural, 'Singapore dollars');
    });
  });
}
