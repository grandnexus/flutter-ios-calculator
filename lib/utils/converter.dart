import 'dart:convert';
import 'package:flutter_ios_calculator/models/models.dart';
import 'package:http/http.dart' as http;

/// A service class for handling currency conversions and fetching exchange rates.
///
/// The [Converter] class provides methods for fetching the list of supported
/// currencies and the latest exchange rates from a third-party API. It also
/// contains a conversion method to calculate the exchange amount between two
/// currencies.
///
/// Example usage:
/// ```dart
/// final converter = await Converter.fetchLatest('USD', 'EUR');
/// final convertedAmount = converter.convert(100); // Converts 100 USD to EUR
/// ```
class Converter {
  Converter({
    required this.baseCurrency,
    required this.baseAmount,
    required this.targetCurrency,
    required this.targetAmount,
    required this.exchangeRate,
  });

  /// The base currency used for conversion.
  final String baseCurrency;

  /// The amount in the base currency.
  final double baseAmount;

  /// The target currency for conversion.
  final String targetCurrency;

  /// The amount in the target currency after conversion.
  final double targetAmount;

  /// The exchange rate between the base and target currency.
  final double exchangeRate;

  /// API key for the currency conversion service.
  static String _apiKey = '';

  /// Base API endpoint for fetching currency data.
  static const String _endpoint = 'https://api.freecurrencyapi.com/v1';

  /// Cache for storing fetched currencies.
  static final Map<String, Currency> currencies = {};

  /// Fetches the API key from environment variables.
  ///
  /// Throws an [AssertionError] if the `CURRENCY_API_KEY` is not set.
  static String _fetchAPIKey({bool isMock = false}) {
    const currencyApiKey = String.fromEnvironment('CURRENCY_API_KEY');
    if (!isMock && currencyApiKey.isEmpty) {
      throw AssertionError('CURRENCY_API_KEY is not set');
    }
    return currencyApiKey;
  }

  /// Fetches a list of currencies from the API and returns a map of currency codes.
  ///
  /// Throws an [Exception] if the API request fails.
  /// https://api.freecurrencyapi.com/v1/currencies?apikey={apikey}
  /// EUR, USD, JPY, BGN, CZK, DKK, GBP, HUF, PLN, RON, SEK, CHF, ISK, NOK, HRK, RUB,
  /// TRY, AUD, BRL, CAD, CNY, HKD, IDR, ILS, INR, KRW, MXN, MYR, NZD, PHP, SGD, THB, ZAR.
  static Future<Map<String, Currency>> fetchCurrencies({
    http.Client? mockClient,
  }) async {
    _apiKey = _fetchAPIKey(isMock: mockClient != null);
    final client = mockClient ?? http.Client();

    final uri = Uri.parse('$_endpoint/currencies?apikey=$_apiKey');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final currencyData = CurrenciesData.fromJson(data);
      currencies.addAll(currencyData.currencies);
    } else {
      throw Exception('Failed to load currencies: ${response.reasonPhrase}');
    }
    return currencies;
  }

  /// Fetches the latest exchange rate between the [baseCurrency] and [targetCurrency].
  ///
  /// Returns a [Converter] instance with the exchange rate information.
  /// Throws an [Exception] if the API request fails.
  /// https://api.freecurrencyapi.com/v1/latest?apikey={apikey}&base_currency=SGD&currencies=USD,EUR,JPY
  static Future<Converter> fetchLatest(
    String baseCurrency,
    String targetCurrency, {
    http.Client? mockClient,
  }) async {
    _apiKey = _fetchAPIKey(isMock: mockClient != null);
    final client = mockClient ?? http.Client();
    final uri = Uri.parse(
      '$_endpoint/latest?apikey=$_apiKey&base_currency=$baseCurrency&currencies=$targetCurrency',
    );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      double exchangeRate =
          double.tryParse(data['data'][targetCurrency].toString()) ?? 0.0;

      return Converter(
        baseCurrency: baseCurrency,
        baseAmount: 1,
        targetCurrency: targetCurrency,
        targetAmount: exchangeRate,
        exchangeRate: exchangeRate,
      );
    } else {
      throw Exception('Failed to load exchange rate: ${response.reasonPhrase}');
    }
  }

  /// Converts the given [amount] from the base currency to the target currency.
  double convert(double amount) {
    return amount * exchangeRate;
  }
}
