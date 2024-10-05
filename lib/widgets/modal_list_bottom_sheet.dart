import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_calculator/models/models.dart';
import 'package:flutter_ios_calculator/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;

/// A modal bottom sheet that displays a list of currencies.
///
/// This widget fetches a list of available currencies from an external source
/// and allows the user to select one. The selected currency is highlighted,
/// and a callback returns the chosen currency when tapped.
///
/// The [currencyCode] parameter is required to specify the currently selected currency.
///
/// Example usage:
/// ```dart
/// showCupertinoModalBottomSheet(
///   context: context,
///   builder: (context) => ModalListBottomSheet(
///     currencyCode: 'USD',
///   ),
/// );
/// ```
class ModalListBottomSheet extends StatefulWidget {
  const ModalListBottomSheet({
    super.key,
    required this.currencyCode,
    this.mockClient,
  });

  /// The currency code of the currently selected currency.
  final String currencyCode;

  final http.Client? mockClient;

  @override
  State<ModalListBottomSheet> createState() => ModalListBottomSheetState();
}

/// The state of [ModalListBottomSheet] responsible for handling data fetching and displaying the currency list.
class ModalListBottomSheetState extends State<ModalListBottomSheet> {
  late Future<Map<String, Currency>> _currenciesFuture;

  @override
  void initState() {
    super.initState();
    // Fetches the list of currencies asynchronously when the widget is initialized.
    _currenciesFuture =
        Converter.fetchCurrencies(mockClient: widget.mockClient);
  }

  /// Builds a list tile for each currency, showing its name and code.
  /// Highlights the tile if the currency is currently selected.
  Widget _buildListTile(Currency currency, bool isSelected) {
    const selectedStyle = TextStyle(
      color: Colors.orange,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    const defaultStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  currency.name ?? '',
                  style: isSelected ? selectedStyle : defaultStyle,
                ),
                AutoSizeText(
                  currency.code ?? '',
                  style: isSelected
                      ? selectedStyle.copyWith(fontSize: 14)
                      : defaultStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          if (isSelected)
            const FaIcon(
              FontAwesomeIcons.check,
              color: Colors.orange,
            ),
        ],
      ),
    );
  }

  /// Builds the list view containing all the currencies.
  /// The list allows the user to scroll and select a currency.
  Widget _buildListView(Map<String, Currency> currencies) {
    return ListView.builder(
      shrinkWrap: true,
      controller: ModalScrollController.of(context),
      itemCount: currencies.length,
      itemBuilder: (context, index) {
        final currency = currencies.values.elementAt(index);
        final isSelected = currency.code == widget.currencyCode;
        return InkWell(
          onTap: () => Navigator.of(context).pop(currency),
          child: _buildListTile(currency, isSelected),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Map<String, Currency>>(
          future: _currenciesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Failed to load currencies"));
            }

            final currencies = snapshot.data!;
            return PageView(
              children: List.generate(
                2,
                (index) => _buildListView(currencies),
              ),
            );
          },
        ),
      ),
    );
  }
}
