import 'package:flutter/material.dart';

/// Button to reset the game after a winner is selected.
class ResetButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onPressed;

  const ResetButton({
    required this.isVisible,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: IgnorePointer(
          ignoring: !isVisible,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
              shadowColor: Colors.white.withValues(alpha: 0.3),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 28),
            label: const Text(
              'Play Again',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
