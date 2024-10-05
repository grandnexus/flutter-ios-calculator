import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A custom button that displays a currency label and an icon.
///
/// This widget consists of a text label and an icon, both of which change
/// their color when pressed. The button triggers a callback when tapped.
///
/// The [text] parameter is the label of the currency that will be displayed.
/// The [onPressed] callback is executed when the button is pressed.
class CurrencyButton extends StatefulWidget {
  const CurrencyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  /// The text label representing the currency.
  final String text;

  /// Callback function triggered when the button is pressed.
  final VoidCallback onPressed;

  @override
  State<CurrencyButton> createState() => CurrencyButtonState();
}

class CurrencyButtonState extends State<CurrencyButton> {
  /// Tracks whether the button is currently pressed or highlighted.
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Define the text style for both pressed and normal states
    final textStyle = TextStyle(
      color: isPressed ? Colors.grey[700] : Colors.grey,
      fontSize: 24,
    );

    // Define the icon color based on the pressed state
    final iconColor = isPressed ? Colors.grey[700] : Colors.grey;

    return InkWell(
      onTap: widget.onPressed,
      onHighlightChanged: (value) {
        // Update the button's pressed state when the highlight changes
        setState(() {
          isPressed = value;
        });
      },
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        children: [
          AutoSizeText(
            widget.text,
            style: textStyle,
          ),
          const SizedBox(width: 8),
          FaIcon(
            CupertinoIcons.chevron_up_chevron_down,
            size: 32,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}
