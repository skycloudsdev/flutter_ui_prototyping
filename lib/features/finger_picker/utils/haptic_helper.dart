import 'package:flutter/services.dart';

/// Helper class for haptic feedback.
abstract class HapticHelper {
  /// Trigger light haptic feedback.
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Trigger medium haptic feedback.
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Trigger heavy haptic feedback for winner selection.
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Trigger selection haptic feedback.
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// Trigger vibration pattern for winner.
  static Future<void> winnerCelebration() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }
}
