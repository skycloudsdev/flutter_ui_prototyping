import 'dart:ui';

/// Configuration constants for the Finger Picker game.
abstract class GameConfig {
  /// Minimum number of fingers required to start the game.
  static const int minFingers = 2;

  /// Maximum number of fingers supported.
  static const int maxFingers = 10;

  /// Duration of the countdown before selection starts.
  static const Duration countdownDuration = Duration(seconds: 3);

  /// Duration of the roulette selection animation.
  static const Duration selectionDuration = Duration(milliseconds: 2500);

  /// Grace period before canceling when a finger is lifted.
  static const Duration gracePeriod = Duration(milliseconds: 500);

  /// Base radius of the bubble.
  static const double bubbleRadius = 50;

  /// Radius of the winner's bubble.
  static const double winnerBubbleRadius = 75;

  /// Additional glow radius around bubbles.
  static const double glowRadius = 25;

  /// Colors assigned to each finger (up to 8 distinct colors).
  static const List<Color> fingerColors = [
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFE66D), // Yellow
    Color(0xFF95E1D3), // Mint
    Color(0xFFF38181), // Salmon
    Color(0xFFAA96DA), // Lavender
    Color(0xFFFCBAD3), // Pink
    Color(0xFFA8D8EA), // Sky Blue
    Color(0xFFFF9F43), // Orange
    Color(0xFF6C5CE7), // Purple
  ];

  /// Returns a color for the given finger index.
  static Color getColorForFinger(int index) {
    return fingerColors[index % fingerColors.length];
  }
}
