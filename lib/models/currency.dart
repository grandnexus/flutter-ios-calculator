/// A class representing a currency with various properties such as symbol, name, etc.
class Currency {
  // Constructor that initializes the Currency object with optional fields.
  Currency({
    this.symbol,
    this.name,
    this.symbolNative,
    this.decimalDigits,
    this.rounding,
    this.code,
    this.namePlural,
  });

  // Properties of the Currency object, all are nullable.
  final String? symbol; // The symbol of the currency (e.g., $ for USD).
  final String? name; // The name of the currency (e.g., US Dollar).
  final String?
      symbolNative; // The native symbol of the currency (e.g., $ for USD).
  final int?
      decimalDigits; // The number of decimal digits used (e.g., 2 for USD).
  final int? rounding; // Rounding value for the currency.
  final String? code; // The code of the currency (e.g., USD for US Dollar).
  final String?
      namePlural; // The plural form of the currency name (e.g., US Dollars).

  /// Factory constructor to create a Currency object from a JSON map.
  /// Maps each JSON key to the respective property.
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      symbol: json['symbol'], // e.g., "$"
      name: json['name'], // e.g., "US Dollar"
      symbolNative: json['symbol_native'], // e.g., "$"
      decimalDigits: json['decimal_digits'], // e.g., 2
      rounding: json['rounding'], // e.g., 0
      code: json['code'], // e.g., "USD"
      namePlural: json['name_plural'], // e.g., "US Dollars"
    );
  }

  /// Method to convert a Currency object into a JSON map.
  /// Returns a map with key-value pairs of currency properties.
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'symbol_native': symbolNative,
      'decimal_digits': decimalDigits,
      'rounding': rounding,
      'code': code,
      'name_plural': namePlural,
    };
  }

  /// Equality operator to compare two Currency objects.
  /// Returns true if all properties are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Currency &&
        other.symbol == symbol &&
        other.name == name &&
        other.symbolNative == symbolNative &&
        other.decimalDigits == decimalDigits &&
        other.rounding == rounding &&
        other.code == code &&
        other.namePlural == namePlural;
  }

  /// Hashcode generator for the Currency object.
  /// Combines the hash codes of all properties.
  @override
  int get hashCode =>
      symbol.hashCode ^
      name.hashCode ^
      symbolNative.hashCode ^
      decimalDigits.hashCode ^
      rounding.hashCode ^
      code.hashCode ^
      namePlural.hashCode;
}
