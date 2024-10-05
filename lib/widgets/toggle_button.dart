import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A custom toggle button widget that allows for tap interactions with visual feedback.
///
/// The button displays an icon, which changes color when pressed. It also triggers
/// a callback function when the button is released.
///
/// The [icon] parameter is required and represents the icon displayed on the button.
/// The [onPressed] callback is triggered when the button is tapped.
///
/// Example usage:
/// ```dart
/// ToggleButton(
///   icon: Icons.favorite,
///   onPressed: () {
///     // Handle button press action
///   },
/// );
/// ```
class ToggleButton extends StatefulWidget {
  const ToggleButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  /// The icon displayed on the button.
  final IconData icon;

  /// Callback function triggered when the button is pressed and released.
  final VoidCallback onPressed;

  @override
  State<ToggleButton> createState() => ToggleButtonState();
}

/// The state for [ToggleButton], which manages the pressed state of the button.
class ToggleButtonState extends State<ToggleButton> {
  /// Boolean to track whether the button is pressed.
  bool isPressed = false;

  /// Handles the button press down event, changing the button color to indicate it's pressed.
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      isPressed = true;
    });
  }

  /// Handles the button release event, resetting the button color and triggering the [onPressed] callback.
  void _handleTapUp(TapUpDetails details) {
    setState(() {
      isPressed = false;
    });
    widget.onPressed();
  }

  /// Handles tap cancel events, resetting the button color if the tap was canceled (e.g., dragged out).
  void _handleTapCancel() {
    setState(() {
      isPressed = false;
    });
  }

  /// Builds the widget and manages the button's visual state.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: FaIcon(
        widget.icon,
        size: 28,
        color: isPressed ? Colors.orange[800] : Colors.orange,
      ),
    );
  }
}
