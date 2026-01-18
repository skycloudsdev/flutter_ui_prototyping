# Canvas Shape Editor - MVP Implementation Plan

## 1. Overview

The Canvas Shape Editor is an interactive drawing application that allows users to create and manipulate geometric shapes on a blank canvas. Users can add shapes (circle, square, triangle) from a bottom sheet selector, then move, resize, flip, and delete them with full layering support. The app maintains session state through user interactions and resets when navigating away.

**Core Objective**: Provide an intuitive, touch-friendly interface for creating and manipulating 2D shapes with real-time visual feedback and layering capabilities.

---

## 2. Technical Approach

### 2.1 State Management: BLoC Pattern

The feature requires BLoC for managing canvas state complexity:

**Structure**:

```
lib/features/canvas_editor/
├── bloc/
│   ├── canvas_bloc.dart         # Main BLoC
│   ├── canvas_event.dart        # Events
│   └── canvas_state.dart        # States
├── models/
│   ├── shape_model.dart         # Shape data model
│   └── shape_type.dart          # Enum for shape types
├── screens/
│   └── canvas_editor_screen.dart
└── widgets/
    ├── canvas_painter.dart      # CustomPainter
    ├── shape_selector_bottom_sheet.dart
    └── shape_controls_overlay.dart
```

**BLoC Events**:

- `AddShapeEvent` - Add new shape to canvas
- `UpdateShapePositionEvent` - Move shape
- `UpdateShapeScaleEvent` - Resize shape
- `FlipShapeHorizontalEvent` - Mirror horizontally
- `FlipShapeVerticalEvent` - Mirror vertically
- `SelectShapeEvent` - Select/deselect shape
- `DeleteShapeEvent` - Remove shape
- `ClearCanvasEvent` - Remove all shapes
- `UndoEvent` - Revert last action
- `RedoEvent` - Redo last undone action

**BLoC State**:

```dart
abstract class CanvasState {}

class CanvasInitial extends CanvasState {}

class CanvasLoaded extends CanvasState {
  final List<ShapeModel> shapes;
  final ShapeModel? selectedShape;
  final List<List<ShapeModel>> undoHistory;
  final List<List<ShapeModel>> redoHistory;

  CanvasLoaded({
    required this.shapes,
    this.selectedShape,
    required this.undoHistory,
    required this.redoHistory,
  });
}
```

### 2.2 Rendering: Flutter Widgets

**Key Components**:

1. **Canvas Area**:
   - `GestureDetector` for touch input (pan, scale, tap)
   - `CustomPaint` with `CanvasPainter` for rendering shapes
   - `Stack` for layered shape management

2. **Shape Model**:

   ```dart
   class ShapeModel {
     final String id;
     final ShapeType type;
     final Offset position;
     final Size size;
     final bool isFlippedHorizontally;
     final bool isFlippedVertically;

     const ShapeModel({
       required this.id,
       required this.type,
       required this.position,
       required this.size,
       this.isFlippedHorizontally = false,
       this.isFlippedVertically = false,
     });
   }

   enum ShapeType { circle, square, triangle }
   ```

3. **Rendering Logic**:
   - Shapes rendered in order (first added = back, last added = front)
   - Selected shape rendered with selection border and resize handles
   - Use `Canvas.drawPath()` or `Canvas.drawCircle()` for shape rendering

4. **Touch Handling**:
   - **Tap**: Select/deselect shape under finger
   - **Pan/Drag**: Move selected shape
   - **Scale/Pinch**: Resize selected shape (preserving aspect ratio)
   - **Long Press**: Show shape controls menu (flip, delete)

### 2.3 Performance Optimization

1. **CustomPaint Optimization**:
   - Implement `shouldRepaint()` to avoid unnecessary redraws
   - Use `RepaintBoundary` for expensive shapes if needed
   - Cache shape geometry calculations

2. **Animation Performance**:
   - Use `AnimationController` for shape appearance animation (scale from 0 to target size)
   - Keep animation duration short (200-300ms)

3. **Touch Responsiveness**:
   - Debounce rapid position updates during drag
   - Use `HitTest` to efficiently determine which shape is tapped

4. **Memory Management**:
   - Limit undo/redo history to last 50 actions
   - Dispose BLoC resources properly on screen exit

### 2.4 UI/UX Patterns

**Visual Design**:

- Clean, minimalist canvas with light background
- Shapes rendered with solid colors (circle: blue, square: green, triangle: orange)
- Selected shape: border highlight + semi-transparent resize handles
- FAB for "Add Shape" action

**User Pain Points & Solutions**:

| Pain Point                      | Solution                                        |
| ------------------------------- | ----------------------------------------------- |
| Don't know if shape is selected | Selection border + visual feedback              |
| Hard to resize precisely        | Aspect ratio lock + clear resize handles        |
| Can't undo mistakes             | Undo/Redo buttons in toolbar                    |
| Accidental delete               | Confirmation dialog or undo fallback            |
| Lost shapes in layers           | Selection overlay shows active shape            |
| Confusing controls              | Single long-press shows menu with clear options |

**Interaction Flow**:

```
1. User sees blank canvas + FAB
   ↓
2. Tap FAB → Bottom sheet appears with shape options
   ↓
3. Select shape → Closes bottom sheet, shape appears on canvas with scale-up animation
   ↓
4. Tap shape → Selects it (shows border + handles)
   ↓
5. Drag to move / Pinch to resize / Long-press for menu (flip/delete)
   ↓
6. User can add more shapes or edit existing ones
   ↓
7. Tap "Clear" or use Undo to remove shapes
   ↓
8. Navigate away → State resets
```

---

## 3. MVP Features

### Core Features (Essential)

- ✅ **Blank Canvas**: White/light background canvas spanning full screen
- ✅ **Shape Selection**: Bottom sheet with circle, square, triangle options
- ✅ **Shape Addition**: Tap shape type → appears on canvas with scale-up animation
- ✅ **Shape Movement**: Drag selected shape to new position
- ✅ **Shape Resizing**: Pinch/two-finger zoom to resize (maintains aspect ratio)
- ✅ **Shape Selection/Deselection**:
  - Tap shape to select (shows border + handles)
  - Tap empty canvas to deselect
- ✅ **Flip Horizontal**: Mirror shape left-right
- ✅ **Flip Vertical**: Mirror shape top-bottom
- ✅ **Shape Deletion**: Delete selected shape via menu
- ✅ **Clear Canvas**: Button to remove all shapes
- ✅ **Layering**: Newer shapes appear on top; can select any layer
- ✅ **Undo/Redo**: Navigate action history
- ✅ **Visual Feedback**:
  - Selection border on active shape
  - Scale-up animation on shape creation
  - Resize handles visible on selected shape

### UI Components

```
┌─────────────────────────────────────┐
│  Canvas Editor                  ↤ ↥ │  ← Undo/Redo buttons
│                                     │
│                                     │
│       ┌──●──┐                       │  ← Circle (selected, shows border)
│       │     │                       │
│       └─────┘                       │
│                                     │
│            ■                        │  ← Square
│                                     │
│                  ▲                  │  ← Triangle
│                 ╱ ╲                 │
│                ╱───╲                │
│                                     │
│                             [+]     │  ← FAB (Add Shape)
└─────────────────────────────────────┘

Long Press Menu (on selected shape):
┌─────────────────┐
│ Flip Horizontal │
│ Flip Vertical   │
│ Delete          │
└─────────────────┘
```

### Data Persistence

- **Session State**: Stored in BLoC, persists while app is running
- **Navigation Reset**: State cleared when leaving the screen (via BLoC dispose)
- **No Permanent Storage**: No SharedPreferences or local database needed for MVP

### Possible Concerns & Solutions

| Concern                                     | Mitigation                                                            |
| ------------------------------------------- | --------------------------------------------------------------------- |
| **Touch accuracy on small shapes**          | Increase tap target area with invisible buffer zone                   |
| **Pinch resize complexity**                 | Simplify by using single-pointer drag for resize if pinch too complex |
| **Animation janky on low-end devices**      | Profile with Devtools; simplify animations if needed                  |
| **Undo/redo memory bloat**                  | Limit history to 50 items; serialize only essential shape data        |
| **Confusion about which shape is selected** | Clear visual border + highlight entire shape region                   |
| **Accidental taps**                         | Require explicit long-press for destructive actions (delete)          |

### Testing Considerations

- **Unit Tests**: ShapeModel creation, position/scale calculations
- **BLoC Tests**: Event handling, state transitions (using `bloc_test`)
- **Widget Tests**: Canvas rendering, touch interactions
- **Integration Tests**: Full user flow (add → move → resize → delete)

---

## 4. Implementation Checklist

- [ ] Create BLoC structure and events/states
- [ ] Implement `ShapeModel` and `ShapeType` enum
- [ ] Build `CanvasPainter` CustomPainter for shape rendering
- [ ] Implement gesture detection (tap, drag, pinch)
- [ ] Add shape selection/deselection logic
- [ ] Implement move and resize functionality
- [ ] Add flip horizontal/vertical operations
- [ ] Create bottom sheet shape selector
- [ ] Add scale-up animation on shape creation
- [ ] Implement undo/redo stack
- [ ] Build UI controls (FAB, clear button, undo/redo buttons)
- [ ] Add visual feedback (selection border, handles)
- [ ] Test on multiple device sizes
- [ ] Integrate into router and home screen
