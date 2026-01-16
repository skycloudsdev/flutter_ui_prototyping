import 'package:flutter_ui_prototyping/features/finger_picker/models/models.dart';

/// Base class for all finger picker states.
sealed class FingerPickerState {
  /// Map of pointer ID to Finger data.
  final Map<int, Finger> fingers;

  const FingerPickerState({required this.fingers});
}

/// Initial state - waiting for fingers to be placed.
class IdleState extends FingerPickerState {
  const IdleState() : super(fingers: const {});
}

/// Fingers are being tracked but not enough for the game to start.
class TrackingState extends FingerPickerState {
  const TrackingState({required super.fingers});
}

/// Countdown is in progress before selection.
class CountdownState extends FingerPickerState {
  final int secondsRemaining;

  const CountdownState({
    required super.fingers,
    required this.secondsRemaining,
  });
}

/// Roulette selection animation is playing.
class SelectingState extends FingerPickerState {
  /// The ID of the currently highlighted finger (null = none).
  final int? highlightedFingerId;

  const SelectingState({
    required super.fingers,
    this.highlightedFingerId,
  });
}

/// Winner has been selected.
class WinnerState extends FingerPickerState {
  /// The pointer ID of the winning finger.
  final int winnerId;

  const WinnerState({
    required super.fingers,
    required this.winnerId,
  });
}
