import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A custom circular button that displays either text or an icon.
///
/// The button can display either a [text] or an [icon] inside a circular
/// button with customizable [textColor], [backgroundColor], and [onPressed]
/// callback.
///
/// - If [text] is provided, the button displays the text.
/// - If [icon] is provided (and [text] is null), the button displays the icon.
///
/// Example usage:
/// ```dart
/// CircularButton(
///   text: '1',
///   textColor: Colors.white,
///   backgroundColor: Colors.blue,
///   onPressed: () {
///     // Handle button press
///   },
/// );
/// ```
class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    this.text,
    this.icon,
    this.textSize = 42,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  /// The text to display inside the button. If null, the [icon] will be displayed instead.
  final String? text;

  /// The icon to display inside the button. Only used if [text] is null.
  final IconData? icon;

  /// The color of the text or icon.
  final Color textColor;

  /// The font size of the text. Defaults to 42.
  final double? textSize;

  /// The background color of the button.
  final Color backgroundColor;

  /// The callback that is called when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isTextButton = text != null;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(95, 95),
            maximumSize: const Size(95, 95),
            backgroundColor: backgroundColor,
            shape: const CircleBorder(),
          ),
          onPressed: onPressed,
          child: isTextButton
              ? AutoSizeText(
                  text!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                  ),
                )
              : FaIcon(
                  icon,
                  color: textColor,
                  size: 36.0,
                ),
        ),
      ),
    );
  }
}
