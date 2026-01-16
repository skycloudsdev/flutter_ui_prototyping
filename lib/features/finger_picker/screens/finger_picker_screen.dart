import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/bloc/bloc.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/utils/utils.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/widgets/widgets.dart';

/// Main screen for the Finger Picker game.
class FingerPickerScreen extends StatelessWidget {
  static const id = '/finger-picker';

  const FingerPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FingerPickerBloc(),
      child: const _FingerPickerView(),
    );
  }
}

class _FingerPickerView extends StatefulWidget {
  const _FingerPickerView();

  @override
  State<_FingerPickerView> createState() => _FingerPickerViewState();
}

class _FingerPickerViewState extends State<_FingerPickerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int? _previousHighlightedId;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    context.read<FingerPickerBloc>().add(
      FingerDown(event.pointer, event.localPosition),
    );
    HapticHelper.light();
  }

  void _onPointerMove(PointerMoveEvent event) {
    context.read<FingerPickerBloc>().add(
      FingerMove(event.pointer, event.localPosition),
    );
  }

  void _onPointerUp(PointerUpEvent event) {
    context.read<FingerPickerBloc>().add(FingerUp(event.pointer));
  }

  void _onPointerCancel(PointerCancelEvent event) {
    context.read<FingerPickerBloc>().add(FingerUp(event.pointer));
  }

  void _onReset() {
    context.read<FingerPickerBloc>().add(const ResetGame());
    HapticHelper.medium();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: BlocConsumer<FingerPickerBloc, FingerPickerState>(
        listenWhen: (previous, current) {
          // Listen for state changes that need haptic feedback
          if (current is SelectingState &&
              current.highlightedFingerId != _previousHighlightedId) {
            _previousHighlightedId = current.highlightedFingerId;
            return true;
          }
          if (current is WinnerState && previous is! WinnerState) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is SelectingState) {
            HapticHelper.selection();
          } else if (state is WinnerState) {
            HapticHelper.winnerCelebration();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1A2E),
                      Color(0xFF16213E),
                      Color(0xFF0F3460),
                    ],
                  ),
                ),
              ),

              // Bubbles layer (ignore pointer so touches pass through)
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: BubblePainter(
                        fingers: state.fingers,
                        animationValue: _pulseController.value,
                        winnerId: state is WinnerState ? state.winnerId : null,
                      ),
                      size: Size.infinite,
                    );
                  },
                ),
              ),

              // Instruction text (ignore pointer)
              IgnorePointer(
                child: InstructionText(
                  isVisible:
                      state is IdleState ||
                      (state is TrackingState && state.fingers.length < 2),
                ),
              ),

              // Countdown overlay (ignore pointer)
              if (state is CountdownState)
                IgnorePointer(
                  child: CountdownOverlay(
                    secondsRemaining: state.secondsRemaining,
                  ),
                ),

              // Confetti for winner (already has IgnorePointer inside)
              if (state is WinnerState)
                ConfettiWidget(
                  origin:
                      state.fingers[state.winnerId]?.position ??
                      MediaQuery.of(context).size.center(Offset.zero),
                ),

              // Touch detection layer - must be on top for multi-touch
              Listener(
                onPointerDown: _onPointerDown,
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),

              // Reset button (needs to receive touches)
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: ResetButton(
                    isVisible: state is WinnerState,
                    onPressed: _onReset,
                  ),
                ),
              ),

              // Back button (needs to receive touches)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white70,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
