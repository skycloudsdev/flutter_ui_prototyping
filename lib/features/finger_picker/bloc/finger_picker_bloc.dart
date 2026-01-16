import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/bloc/finger_picker_event.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/bloc/finger_picker_state.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/models/models.dart';

/// BLoC for managing the Finger Picker game state.
class FingerPickerBloc extends Bloc<FingerPickerEvent, FingerPickerState> {
  Timer? _countdownTimer;
  Timer? _selectionTimer;
  Timer? _gracePeriodTimer;
  final Random _random = Random();

  /// Counter for assigning colors to fingers.
  int _colorIndex = 0;

  FingerPickerBloc() : super(const IdleState()) {
    on<FingerDown>(_onFingerDown);
    on<FingerMove>(_onFingerMove);
    on<FingerUp>(_onFingerUp);
    on<CountdownTick>(_onCountdownTick);
    on<StartSelection>(_onStartSelection);
    on<HighlightFinger>(_onHighlightFinger);
    on<SelectWinner>(_onSelectWinner);
    on<ResetGame>(_onResetGame);
  }

  void _onFingerDown(FingerDown event, Emitter<FingerPickerState> emit) {
    // Ignore new fingers during selection or winner state
    if (state is SelectingState || state is WinnerState) return;

    // Cancel grace period timer if we're adding fingers back
    _gracePeriodTimer?.cancel();

    final newFinger = Finger(
      id: event.pointerId,
      position: event.position,
      color: GameConfig.getColorForFinger(_colorIndex++),
    );

    final updatedFingers = Map<int, Finger>.from(state.fingers)
      ..[event.pointerId] = newFinger;

    // Check if we have enough fingers to start countdown
    if (updatedFingers.length >= GameConfig.minFingers) {
      if (state is! CountdownState) {
        _startCountdown();
        emit(
          CountdownState(
            fingers: updatedFingers,
            secondsRemaining: GameConfig.countdownDuration.inSeconds,
          ),
        );
      } else {
        emit(
          CountdownState(
            fingers: updatedFingers,
            secondsRemaining: (state as CountdownState).secondsRemaining,
          ),
        );
      }
    } else {
      emit(TrackingState(fingers: updatedFingers));
    }
  }

  void _onFingerMove(FingerMove event, Emitter<FingerPickerState> emit) {
    if (!state.fingers.containsKey(event.pointerId)) return;

    // Don't allow movement during selection animation
    if (state is SelectingState || state is WinnerState) return;

    final updatedFinger = state.fingers[event.pointerId]!.copyWith(
      position: event.position,
    );

    final updatedFingers = Map<int, Finger>.from(state.fingers)
      ..[event.pointerId] = updatedFinger;

    switch (state) {
      case IdleState():
        emit(TrackingState(fingers: updatedFingers));
      case TrackingState():
        emit(TrackingState(fingers: updatedFingers));
      case CountdownState(secondsRemaining: final seconds):
        emit(
          CountdownState(fingers: updatedFingers, secondsRemaining: seconds),
        );
      case SelectingState():
      case WinnerState():
        break;
    }
  }

  void _onFingerUp(FingerUp event, Emitter<FingerPickerState> emit) {
    if (!state.fingers.containsKey(event.pointerId)) return;

    // Ignore finger lifts during selection or winner state
    if (state is SelectingState || state is WinnerState) return;

    final updatedFingers = Map<int, Finger>.from(state.fingers)
      ..remove(event.pointerId);

    // If below minimum fingers during countdown, start grace period
    if (state is CountdownState &&
        updatedFingers.length < GameConfig.minFingers) {
      _gracePeriodTimer?.cancel();
      _gracePeriodTimer = Timer(GameConfig.gracePeriod, () {
        if (isClosed) return;
        _cancelCountdown();
        if (updatedFingers.isEmpty) {
          add(const ResetGame());
        } else {
          emit(TrackingState(fingers: updatedFingers));
        }
      });

      // Keep countdown state during grace period
      emit(
        CountdownState(
          fingers: updatedFingers,
          secondsRemaining: (state as CountdownState).secondsRemaining,
        ),
      );
      return;
    }

    if (updatedFingers.isEmpty) {
      _cancelCountdown();
      emit(const IdleState());
    } else if (updatedFingers.length < GameConfig.minFingers) {
      _cancelCountdown();
      emit(TrackingState(fingers: updatedFingers));
    } else if (state is CountdownState) {
      emit(
        CountdownState(
          fingers: updatedFingers,
          secondsRemaining: (state as CountdownState).secondsRemaining,
        ),
      );
    } else {
      emit(TrackingState(fingers: updatedFingers));
    }
  }

  void _onCountdownTick(CountdownTick event, Emitter<FingerPickerState> emit) {
    if (state is! CountdownState) return;

    if (event.secondsRemaining > 0) {
      emit(
        CountdownState(
          fingers: state.fingers,
          secondsRemaining: event.secondsRemaining,
        ),
      );
    } else {
      _cancelCountdown();
      add(const StartSelection());
    }
  }

  void _onStartSelection(
    StartSelection event,
    Emitter<FingerPickerState> emit,
  ) {
    emit(SelectingState(fingers: state.fingers));
    _startSelectionAnimation();
  }

  void _onHighlightFinger(
    HighlightFinger event,
    Emitter<FingerPickerState> emit,
  ) {
    if (state is! SelectingState) return;

    final updatedFingers = <int, Finger>{};
    for (final entry in state.fingers.entries) {
      updatedFingers[entry.key] = entry.value.copyWith(
        isHighlighted: entry.key == event.fingerId,
      );
    }

    emit(
      SelectingState(
        fingers: updatedFingers,
        highlightedFingerId: event.fingerId,
      ),
    );
  }

  void _onSelectWinner(SelectWinner event, Emitter<FingerPickerState> emit) {
    _selectionTimer?.cancel();

    final updatedFingers = <int, Finger>{};
    for (final entry in state.fingers.entries) {
      final isWinner = entry.key == event.winnerId;
      updatedFingers[entry.key] = entry.value.copyWith(
        isHighlighted: isWinner,
        scale: isWinner ? 1.5 : 0.5,
      );
    }

    emit(
      WinnerState(
        fingers: updatedFingers,
        winnerId: event.winnerId,
      ),
    );
  }

  void _onResetGame(ResetGame event, Emitter<FingerPickerState> emit) {
    _cancelAllTimers();
    _colorIndex = 0;
    emit(const IdleState());
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    var seconds = GameConfig.countdownDuration.inSeconds;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      seconds--;
      add(CountdownTick(seconds));
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _startSelectionAnimation() {
    final fingerIds = state.fingers.keys.toList();
    if (fingerIds.isEmpty) return;

    // Roulette animation: highlight fingers rapidly, then slow down
    const totalMs = 2500;
    var elapsed = 0;
    var currentIndex = 0;
    var interval = 50; // Start fast (50ms between highlights)

    void scheduleNext() {
      if (isClosed) return;

      _selectionTimer = Timer(Duration(milliseconds: interval), () {
        if (isClosed) return;

        elapsed += interval;

        // Slow down as we approach the end
        final progress = elapsed / totalMs;
        if (progress > 0.7) {
          interval = 200 + ((progress - 0.7) * 500).toInt();
        } else if (progress > 0.5) {
          interval = 100;
        }

        currentIndex = (currentIndex + 1) % fingerIds.length;
        add(HighlightFinger(fingerIds[currentIndex]));

        if (elapsed >= totalMs) {
          // Select the winner
          final winnerId = fingerIds[_random.nextInt(fingerIds.length)];
          add(SelectWinner(winnerId));
        } else {
          scheduleNext();
        }
      });
    }

    // Start with highlighting first finger
    add(HighlightFinger(fingerIds[0]));
    scheduleNext();
  }

  void _cancelAllTimers() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _selectionTimer?.cancel();
    _selectionTimer = null;
    _gracePeriodTimer?.cancel();
    _gracePeriodTimer = null;
  }

  @override
  Future<void> close() {
    _cancelAllTimers();
    return super.close();
  }
}
