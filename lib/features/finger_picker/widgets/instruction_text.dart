import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/models/models.dart';

/// Widget that displays instruction text for the user.
class InstructionText extends StatelessWidget {
  /// Semi-transparent black for background.
  static const _backgroundColor = Color(0x66000000);

  /// Semi-transparent white for border.
  static const _borderColor = Color(0x33FFFFFF);

  final bool isVisible;

  const InstructionText({
    required this.isVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'Place ${GameConfig.minFingers}+ fingers to start',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
