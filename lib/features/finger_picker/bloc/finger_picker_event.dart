import 'dart:ui';

/// Base class for all finger picker events.
sealed class FingerPickerEvent {
  const FingerPickerEvent();
}

/// Event when a new finger touches the screen.
class FingerDown extends FingerPickerEvent {
  final int pointerId;
  final Offset position;

  const FingerDown(this.pointerId, this.position);
}

/// Event when a finger moves on the screen.
class FingerMove extends FingerPickerEvent {
  final int pointerId;
  final Offset position;

  const FingerMove(this.pointerId, this.position);
}

/// Event when a finger is lifted from the screen.
class FingerUp extends FingerPickerEvent {
  final int pointerId;

  const FingerUp(this.pointerId);
}

/// Event when the countdown timer ticks.
class CountdownTick extends FingerPickerEvent {
  final int secondsRemaining;

  const CountdownTick(this.secondsRemaining);
}

/// Event when countdown completes and selection should start.
class StartSelection extends FingerPickerEvent {
  const StartSelection();
}

/// Event during roulette animation to highlight a finger.
class HighlightFinger extends FingerPickerEvent {
  final int? fingerId;

  const HighlightFinger(this.fingerId);
}

/// Event when the winner is selected.
class SelectWinner extends FingerPickerEvent {
  final int winnerId;

  const SelectWinner(this.winnerId);
}

/// Event to reset the game to initial state.
class ResetGame extends FingerPickerEvent {
  const ResetGame();
}
