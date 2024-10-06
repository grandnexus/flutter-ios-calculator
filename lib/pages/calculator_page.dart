import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_calculator/models/models.dart';
import 'package:flutter_ios_calculator/utils/utils.dart';
import 'package:flutter_ios_calculator/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;

/// The main page for the currency calculator.
///
/// This page allows users to input currency amounts, select currencies, and
/// convert between them using a grid of calculator buttons and modal bottom sheets for currency selection.
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({
    super.key,
    this.mockClient,
  });

  // Optional HTTP client for mocking requests in testing.
  final http.Client? mockClient;

  @override
  CalculatorPageState createState() => CalculatorPageState();
}

class CalculatorPageState extends State<CalculatorPage> {
  bool isTopOutput = true; // Tracks which currency field is active for input.

  late Converter topConverter; // Converter for the top currency.
  String topOutput = '0'; // The value displayed for the top currency.
  String topCurrency = 'SGD'; // The currency code for the top currency.

  late Converter bottomConverter; // Converter for the bottom currency.
  String bottomOutput = '0.00'; // The value displayed for the bottom currency.
  String bottomCurrency = 'USD'; // The currency code for the bottom currency.

  @override
  void initState() {
    super.initState();
    _initializeConverters(); // Initialize the currency converters when the page is loaded.
  }

  /// Initializes the converters for the top and bottom currencies by fetching the latest conversion rates.
  Future<void> _initializeConverters() async {
    // Fetches conversion rates for both directions between the selected currencies.
    final converters = await Future.wait([
      Converter.fetchLatest(
        topCurrency,
        bottomCurrency,
        mockClient: widget.mockClient,
      ),
      Converter.fetchLatest(
        bottomCurrency,
        topCurrency,
        mockClient: widget.mockClient,
      ),
    ]);
    setState(() {
      topConverter = converters[0];
      bottomConverter = converters[1];
    });
  }

  /// Appends a digit or decimal to the current output for the active field (top or bottom).
  void _appendOutput(String value) {
    setState(() {
      String output = isTopOutput ? topOutput : bottomOutput;
      // Replace the output if it's the default '0' or '0.00', otherwise append the new value.
      if (output == '0' || output == '0.00' && value != '.') {
        output = value;
      } else if (!(output.contains('.') && value == '.')) {
        output += value;
      }
      _updateOutput(output); // Update the output based on the new value.
    });
  }

  /// Updates the output for both currencies based on the active input.
  void _updateOutput(String updatedValue) {
    if (isTopOutput) {
      topOutput = updatedValue;
      // Convert the top currency value to the bottom currency.
      bottomOutput = _convertOutput(topConverter, topOutput);
    } else {
      bottomOutput = updatedValue;
      // Convert the bottom currency value to the top currency.
      topOutput = _convertOutput(bottomConverter, bottomOutput);
    }
  }

  /// Converts the input using the provided converter and returns a formatted string.
  String _convertOutput(Converter converter, String output) {
    return converter.convert(double.parse(output)).toStringAsFixed(2);
  }

  /// Opens a modal bottom sheet to select a currency for either the top or bottom output.
  Future<void> _setCurrency(bool isTop) async {
    String currencyCode = isTop ? topCurrency : bottomCurrency;

    // Opens a bottom sheet for currency selection.
    final Currency currency = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) => ModalListBottomSheet(currencyCode: currencyCode),
    );

    // Updates the selected currency and re-initializes the converters.
    setState(() {
      if (isTop) {
        topCurrency = currency.code ?? 'SGD';
      } else {
        bottomCurrency = currency.code ?? 'USD';
      }
    });

    await _initializeConverters();
    _updateOutput(isTopOutput ? topOutput : bottomOutput);
  }

  /// Toggles the active output between the top and bottom currencies.
  Future<void> _toggle() async {
    setState(() {
      isTopOutput = !isTopOutput;
      String temp = topOutput;
      topOutput = bottomOutput;
      bottomOutput = temp;
    });

    _updateOutput(isTopOutput ? topOutput : bottomOutput);
  }

  /// Resets the calculator by clearing both outputs to their initial states.
  void reset() {
    setState(() {
      isTopOutput = true;
      topOutput = '0';
      bottomOutput = '0.00';
    });
  }

  /// Helper method to build a circular button with specific parameters.
  Widget _buildCircularButton({
    Key? key,
    required VoidCallback onPressed,
    String? text,
    IconData? icon,
    Color backgroundColor = Colors.grey,
  }) {
    return CircularButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      textColor: Colors.white,
      backgroundColor: backgroundColor,
    );
  }

  /// Builds the display for the top and bottom currency outputs, along with currency selection buttons.
  Widget _buildCurrencyDisplay() {
    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildCurrencyRow(true), // Top currency row.
          Row(
            children: [
              ToggleButton(
                key: const Key('toggle_button'),
                onPressed: _toggle,
                icon: CupertinoIcons.arrow_up_arrow_down,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Divider(
                  color: Colors.grey[700],
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          _buildCurrencyRow(false), // Bottom currency row.
        ],
      ),
    );
  }

  /// Builds a row for a given currency, showing the output value and a button to select the currency.
  Widget _buildCurrencyRow(bool isTop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                isTopOutput = isTop;
              });
            },
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.horizontal,
              child: AutoSizeText(
                isTop ? topOutput : bottomOutput,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isTopOutput == isTop ? Colors.white : Colors.grey,
                  fontSize: 72,
                ),
                maxLines: 1,
                minFontSize: 48,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: CurrencyButton(
            onPressed: () => _setCurrency(isTop),
            text: isTop ? topCurrency : bottomCurrency,
          ),
        ),
      ],
    );
  }

  /// Builds the grid of calculator buttons used to input numbers and operations.
  Widget _buildButtonGrid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            _buildCircularButton(
              onPressed: reset,
              text: topOutput == '0' && bottomOutput == '0.00' ||
                      topOutput == '0.00' && bottomOutput == '0'
                  ? 'AC'
                  : null,
              icon: CupertinoIcons.delete_left,
              backgroundColor: Colors.grey,
              key: const Key('reset_button'),
            ),
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: CupertinoIcons.plus_slash_minus,
              backgroundColor: Colors.grey,
            ),
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: CupertinoIcons.percent,
              backgroundColor: Colors.grey,
            ),
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: CupertinoIcons.divide,
              backgroundColor: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCircularButton(
              onPressed: () => _appendOutput('7'),
              text: '7',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('8'),
              text: '8',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('9'),
              text: '9',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: CupertinoIcons.xmark,
              backgroundColor: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCircularButton(
              onPressed: () => _appendOutput('4'),
              text: '4',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('5'),
              text: '5',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('6'),
              text: '6',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: CupertinoIcons.minus,
              backgroundColor: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCircularButton(
              onPressed: () => _appendOutput('1'),
              text: '1',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('2'),
              text: '2',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('3'),
              text: '3',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: CupertinoIcons.plus,
              backgroundColor: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: FontAwesomeIcons.calculator,
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('0'),
              text: '0',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () => _appendOutput('.'),
              text: '.',
              backgroundColor: Colors.grey[850]!,
            ),
            _buildCircularButton(
              onPressed: () {
                // Add action logic here
              },
              icon: CupertinoIcons.equal,
              backgroundColor: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the main layout for the calculator, including the display and button grid.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            const FaIcon(
              CupertinoIcons.list_bullet,
              color: Colors.orange,
              size: 28,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 90.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildCurrencyDisplay(),
                  _buildButtonGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
