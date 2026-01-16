# Finger Picker Game - MVP Implementation Plan

## 1. Overview

The Finger Picker is an interactive multi-touch game where two or more players place their fingers on the screen, and the app randomly selects one player as the winner. The game features colorful, glowing bubbles that follow each finger, a roulette-style selection animation, and celebratory confetti for the winner.

**Core Objective**: Create an engaging decision-making tool for groups, useful for scenarios like "who pays the bill?", "who goes first?", or any random selection need.

---

## 2. Technical Approach

### 2.1 State Management (BLoC Pattern)

The game has distinct states that benefit from BLoC:

```
┌─────────────────────────────────────────────────────────────┐
│                      FingerPickerState                      │
├─────────────────────────────────────────────────────────────┤
│  • IdleState        → Waiting for fingers                   │
│  • TrackingState    → Fingers detected, showing bubbles     │
│  • CountdownState   → 3-second countdown before selection   │
│  • SelectingState   → Roulette animation in progress        │
│  • WinnerState      → Winner selected, show confetti        │
│  • ResetState       → Clearing and returning to idle        │
└─────────────────────────────────────────────────────────────┘
```

**Events**:

- `FingerDown(pointerId, position)` - New finger detected
- `FingerMove(pointerId, position)` - Finger position updated
- `FingerUp(pointerId)` - Finger lifted
- `CountdownComplete` - 3-second timer finished
- `SelectionComplete(winnerId)` - Roulette animation finished
- `ResetGame` - User tapped reset button

### 2.2 Rendering Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                    Widget Tree Structure                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  FingerPickerScreen (Scaffold)                              │
│  └── BlocProvider<FingerPickerBloc>                         │
│      └── BlocBuilder                                        │
│          └── Stack                                          │
│              ├── GestureDetector (Listener for multi-touch) │
│              │   └── Container (full screen touch area)     │
│              ├── CustomPaint / Stack of Bubbles             │
│              │   └── AnimatedBubble (per finger)            │
│              ├── CountdownOverlay (when counting)           │
│              ├── ConfettiWidget (on winner)                 │
│              └── ResetButton (positioned bottom center)     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Bubble Rendering Options**:

1. **CustomPainter** - Best for performance with many bubbles and glow effects
2. **Stack of Positioned Widgets** - Simpler, good for < 10 fingers

**Recommendation**: Use `CustomPainter` for smooth glow effects and animations.

### 2.3 Multi-Touch Detection

Flutter's `Listener` widget provides low-level pointer events needed for multi-touch:

```dart
Listener(
  onPointerDown: (event) => bloc.add(FingerDown(event.pointer, event.localPosition)),
  onPointerMove: (event) => bloc.add(FingerMove(event.pointer, event.localPosition)),
  onPointerUp: (event) => bloc.add(FingerUp(event.pointer)),
  onPointerCancel: (event) => bloc.add(FingerUp(event.pointer)),
  child: Container(color: Colors.black), // Dark background for glow visibility
)
```

### 2.4 Animation Strategy

| Animation          | Duration   | Technique                                 |
| ------------------ | ---------- | ----------------------------------------- |
| Bubble appear      | 200ms      | Scale + Fade In                           |
| Bubble follow      | Continuous | Lerp position with damping                |
| Bubble glow pulse  | 1.5s loop  | AnimationController + CustomPainter       |
| Countdown          | 3s         | Timer + UI overlay                        |
| Roulette selection | 2-3s       | Highlight cycling with easing (fast→slow) |
| Winner celebration | 500ms      | Scale up + Confetti burst                 |
| Confetti           | 3s         | Particle system or package                |

### 2.5 Performance Optimization

1. **RepaintBoundary** - Wrap bubble layer to isolate repaints
2. **Ticker Management** - Use single `Ticker` for coordinated animations
3. **Object Pooling** - Reuse bubble objects instead of creating/destroying
4. **Shader Caching** - Pre-compile glow shader if using custom effects
5. **Avoid rebuilds** - Use `BlocSelector` for targeted rebuilds

### 2.6 UI/UX Analysis

**User Flow**:

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  Empty   │───▶│ Fingers  │───▶│ Countdown│───▶│ Roulette │───▶│  Winner  │
│  Screen  │    │ Tracking │    │   (3s)   │    │ Animation│    │  Reveal  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
     │               │                                               │
     │               │ (lift finger                                  │
     │               │  before 2 min)                                │
     │               ▼                                               │
     │          Back to waiting                                      │
     │                                                               │
     └◀──────────────────────── [Reset Button] ◀─────────────────────┘
```

**Potential Pain Points & Solutions**:

| Pain Point                                  | Solution                                             |
| ------------------------------------------- | ---------------------------------------------------- |
| Users don't know minimum finger requirement | Show instruction text: "Place 2+ fingers to start"   |
| Accidental finger lift during countdown     | Grace period (500ms) before canceling                |
| Users can't see their finger under bubble   | Semi-transparent bubble + offset slightly            |
| Winner not obvious enough                   | Dramatic scale + glow intensity + haptics + confetti |
| Dark room visibility                        | High contrast colors, strong glow effects            |
| Confusion about game state                  | Clear visual/text indicators for each state          |

**Color Palette for Bubbles** (distinct per finger):

```
Finger 1: #FF6B6B (Coral Red)
Finger 2: #4ECDC4 (Teal)
Finger 3: #FFE66D (Yellow)
Finger 4: #95E1D3 (Mint)
Finger 5: #F38181 (Salmon)
Finger 6: #AA96DA (Lavender)
Finger 7: #FCBAD3 (Pink)
Finger 8: #A8D8EA (Sky Blue)
```

---

## 3. MVP Features

### 3.1 Essential Widgets & Components

```
lib/features/finger_picker/
├── finger_picker.dart              # Barrel export
├── screens/
│   └── finger_picker_screen.dart   # Main game screen
├── bloc/
│   ├── finger_picker_bloc.dart     # Game logic
│   ├── finger_picker_event.dart    # Events
│   └── finger_picker_state.dart    # States
├── models/
│   ├── finger.dart                 # Finger data (id, position, color)
│   └── game_config.dart            # Configuration constants
├── widgets/
│   ├── bubble_painter.dart         # CustomPainter for bubbles + glow
│   ├── countdown_overlay.dart      # "3, 2, 1" display
│   ├── confetti_widget.dart        # Winner celebration
│   ├── instruction_text.dart       # "Place fingers to start"
│   └── reset_button.dart           # Bottom reset button
└── utils/
    └── haptic_helper.dart          # Haptic feedback wrapper
```

### 3.2 Core Models

```dart
// finger.dart
class Finger {
  final int id;
  final Offset position;
  final Color color;
  final bool isHighlighted;
  final double scale;

  const Finger({
    required this.id,
    required this.position,
    required this.color,
    this.isHighlighted = false,
    this.scale = 1.0,
  });
}

// game_config.dart
abstract class GameConfig {
  static const int minFingers = 2;
  static const int maxFingers = 10;
  static const Duration countdownDuration = Duration(seconds: 3);
  static const Duration selectionDuration = Duration(milliseconds: 2500);
  static const double bubbleRadius = 40.0;
  static const double winnerBubbleRadius = 60.0;
  static const double glowRadius = 20.0;
}
```

### 3.3 State Definitions

```dart
// finger_picker_state.dart
sealed class FingerPickerState {
  final Map<int, Finger> fingers;
  const FingerPickerState({required this.fingers});
}

class IdleState extends FingerPickerState { ... }
class TrackingState extends FingerPickerState { ... }
class CountdownState extends FingerPickerState {
  final int secondsRemaining;
}
class SelectingState extends FingerPickerState {
  final int? highlightedFingerId;
}
class WinnerState extends FingerPickerState {
  final int winnerId;
}
```

### 3.4 MVP Screens Layout

```
┌─────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │  ← Dark background
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░  "Place 2+ fingers"  ░░░░░░░░░ │  ← Instruction (fades when tracking)
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                         │
│              [ RESET ]                  │  ← Reset button (visible after winner)
└─────────────────────────────────────────┘

During Tracking:
┌─────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░  ╭───╮  ░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░  │ ○ │ ← Bubble (coral, glow) │
│ ░░░░░░░░░  ╰───╯  ░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ╭───╮ ░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │ ○ │ ░░░ │ ← Bubble (teal, glow)
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ╰───╯ ░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░  ╭───╮  ░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░  │ ○ │ ← Bubble (yellow, glow)    │
│ ░░░░░  ╰───╯  ░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                         │
└─────────────────────────────────────────┘

During Countdown:
┌─────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░  ███████  ░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░  ██ 3 ██  ░░░░░░░░░░░░░░ │  ← Large countdown number
│ ░░░░░░░░░░░░░░  ███████  ░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░  (bubbles still visible beneath)  ░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
└─────────────────────────────────────────┘

Winner State:
┌─────────────────────────────────────────┐
│ ░░░  *  ░░░░░  *  ░░░░░  *  ░░░░░  *  ░ │  ← Confetti particles
│ ░  *  ░░░  *  ░░░░░  *  ░░░░░  *  ░░░░░ │
│ ░░░░  *  ░░░░░░░░░  *  ░░░░░░░░  *  ░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░  ╭─────────╮  ░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░  │ ★ ★ ★ ★ │  ░░░░░░░░░░░░░░░ │  ← Winner bubble (larger + glow)
│ ░░░░░░░░░  │    ●    │  ░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░  │ ★ ★ ★ ★ │  ░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░  ╰─────────╯  ░░░░░░░░░░░░░░░ │
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                         │
│              [ RESET ]                  │
└─────────────────────────────────────────┘
```

### 3.5 Possible Concerns & Mitigations

| Concern                        | Risk Level | Mitigation                                                                          |
| ------------------------------ | ---------- | ----------------------------------------------------------------------------------- |
| **Simultaneous touch limit**   | Medium     | iOS/Android typically support 5-10 touches. Document limit and cap at `maxFingers`. |
| **Gesture conflicts**          | Low        | Use `Listener` instead of `GestureDetector` for raw pointer events.                 |
| **Animation jank**             | Medium     | Use `RepaintBoundary`, limit particle count, profile on low-end devices.            |
| **Haptic availability**        | Low        | Check `HapticFeedback` availability, gracefully degrade.                            |
| **Confetti performance**       | Medium     | Limit particle count (50-100), use simple shapes, fade out quickly.                 |
| **Screen rotation**            | Low        | Lock to portrait (already enforced in app config).                                  |
| **Finger accidentally lifted** | Medium     | Add 500ms grace period before canceling countdown.                                  |

### 3.6 Dependencies

**No additional packages required** - MVP can be built with:

- `flutter_bloc` (already installed)
- Flutter's built-in `HapticFeedback` from `services.dart`
- Custom `ConfettiPainter` using `CustomPainter`

**Optional enhancement** (post-MVP):

- `confetti: ^0.7.0` - If custom confetti is too complex

### 3.7 Testing Strategy

```dart
// Unit tests for BLoC
- Test state transitions (Idle → Tracking → Countdown → Selecting → Winner)
- Test minimum finger requirement validation
- Test finger add/remove during different states
- Test countdown interruption when finger lifted

// Widget tests
- Test bubble rendering at correct positions
- Test countdown overlay visibility
- Test reset button functionality
- Test confetti triggers on winner state
```

---

## 4. Implementation Order

1. **Phase 1: Core Structure**

   - [ ] Create folder structure and barrel exports
   - [ ] Define models (`Finger`, `GameConfig`)
   - [ ] Set up BLoC skeleton with states and events

2. **Phase 2: Touch Detection**

   - [ ] Implement `Listener` for multi-touch
   - [ ] Track fingers in BLoC state
   - [ ] Basic bubble rendering (no glow yet)

3. **Phase 3: Animations**

   - [ ] Add glow effect to bubbles via `CustomPainter`
   - [ ] Implement smooth position interpolation
   - [ ] Add bubble appear/disappear animations

4. **Phase 4: Game Logic**

   - [ ] Countdown timer (3 seconds)
   - [ ] Roulette selection animation
   - [ ] Random winner selection

5. **Phase 5: Winner Celebration**

   - [ ] Confetti particle system
   - [ ] Haptic feedback on selection
   - [ ] Winner bubble enlargement

6. **Phase 6: Polish**
   - [ ] Reset button and flow
   - [ ] Instruction text
   - [ ] Edge case handling (grace period, etc.)

---

## 5. Route Registration

Add to `HomeScreen` games list:

```dart
(name: 'Finger Picker', route: '/finger-picker'),
```

Add to `AppRouter.routes`:

```dart
FingerPickerScreen.id: (_) => const FingerPickerScreen(),
```
