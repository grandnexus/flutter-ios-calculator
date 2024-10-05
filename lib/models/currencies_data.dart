import 'package:flutter_ios_calculator/models/currency.dart';

/// A class representing the collection of currencies data.
class CurrenciesData {
  // Constructor that initializes the CurrenciesData object with a map of currencies.
  CurrenciesData({required this.currencies});

  // A map where the key is a string (currency code), and the value is a Currency object.
  final Map<String, Currency> currencies;

  /// Factory constructor to create a CurrenciesData object from a JSON map.
  /// Takes a JSON map and transforms the 'data' field into a map of Currency objects.
  factory CurrenciesData.fromJson(Map<String, dynamic> json) {
    // Extracting the 'data' field from the JSON, expected to be a map.
    final data = json['data'] as Map<String, dynamic>;
    // Map to store the processed currencies.
    Map<String, Currency> currencyMap = {};

    // Iterating over the data map and converting each entry to a Currency object.
    data.forEach((key, value) {
      currencyMap[key] = Currency.fromJson(value);
    });

    // Returning a new CurrenciesData object with the populated currencyMap.
    return CurrenciesData(currencies: currencyMap);
  }

  /// Method to convert the CurrenciesData object back into a JSON map.
  /// It returns a map with the 'data' field containing all currencies in JSON format.
  Map<String, dynamic> toJson() {
    // Creating an empty map to store the JSON data.
    final Map<String, dynamic> data = {};
    // Converting each Currency object back into JSON and adding it to the data map.
    currencies.forEach((key, value) {
      data[key] = value.toJson();
    });

    // Returning a map with 'data' field containing the converted currency data.
    return {'data': data};
  }
}
