import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/bloc/canvas_event.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/bloc/canvas_state.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_model.dart';

/// BLoC for managing canvas state and shape operations.
class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  static const int _maxHistorySize = 50;
  static const double _defaultShapeSize = 100;
  static const double _minShapeSize = 30;
  static const double _maxShapeSize = 300;

  int _shapeCounter = 0;

  CanvasBloc() : super(const CanvasState()) {
    on<AddShapeEvent>(_onAddShape);
    on<UpdateShapePositionEvent>(_onUpdateShapePosition);
    on<UpdateShapeScaleEvent>(_onUpdateShapeScale);
    on<UpdateShapeRotationEvent>(_onUpdateShapeRotation);
    on<RotateShape90Event>(_onRotateShape90);
    on<FlipShapeHorizontalEvent>(_onFlipShapeHorizontal);
    on<FlipShapeVerticalEvent>(_onFlipShapeVertical);
    on<SelectShapeEvent>(_onSelectShape);
    on<DeleteShapeEvent>(_onDeleteShape);
    on<ClearCanvasEvent>(_onClearCanvas);
    on<UndoEvent>(_onUndo);
    on<RedoEvent>(_onRedo);
    on<SavePositionToHistoryEvent>(_onSavePositionToHistory);
    on<SaveScaleToHistoryEvent>(_onSaveScaleToHistory);
    on<ClearAnimatingShapeEvent>(_onClearAnimatingShape);
  }

  void _onAddShape(AddShapeEvent event, Emitter<CanvasState> emit) {
    final newShape = ShapeModel(
      id: 'shape_${_shapeCounter++}',
      type: event.shapeType,
      position: event.position,
      size: const Size(_defaultShapeSize, _defaultShapeSize),
    );

    final newShapes = [...state.shapes, newShape];

    emit(
      _pushToHistory(state).copyWith(
        shapes: newShapes,
        selectedShapeId: () => newShape.id,
        animatingShapeId: () => newShape.id,
        redoHistory: const [],
      ),
    );
  }

  void _onUpdateShapePosition(
    UpdateShapePositionEvent event,
    Emitter<CanvasState> emit,
  ) {
    final updatedShapes = state.shapes.map((shape) {
      if (shape.id == event.shapeId) {
        return shape.copyWith(position: event.position);
      }
      return shape;
    }).toList();

    emit(state.copyWith(shapes: updatedShapes));
  }

  void _onUpdateShapeScale(
    UpdateShapeScaleEvent event,
    Emitter<CanvasState> emit,
  ) {
    final updatedShapes = state.shapes.map((shape) {
      if (shape.id == event.shapeId) {
        final newWidth = event.newSize.width.clamp(
          _minShapeSize,
          _maxShapeSize,
        );
        final newHeight = event.newSize.height.clamp(
          _minShapeSize,
          _maxShapeSize,
        );
        return shape.copyWith(size: Size(newWidth, newHeight));
      }
      return shape;
    }).toList();

    emit(state.copyWith(shapes: updatedShapes));
  }

  void _onUpdateShapeRotation(
    UpdateShapeRotationEvent event,
    Emitter<CanvasState> emit,
  ) {
    final updatedShapes = state.shapes.map((shape) {
      if (shape.id == event.shapeId) {
        return shape.copyWith(rotation: event.rotation);
      }
      return shape;
    }).toList();

    emit(state.copyWith(shapes: updatedShapes));
  }

  void _onRotateShape90(
    RotateShape90Event event,
    Emitter<CanvasState> emit,
  ) {
    final updatedShapes = state.shapes.map((shape) {
      if (shape.id == event.shapeId) {
        return shape.copyWith(rotation: shape.rotation + math.pi / 2);
      }
      return shape;
    }).toList();

    emit(
      _pushToHistory(state).copyWith(
        shapes: updatedShapes,
        redoHistory: const [],
      ),
    );
  }

  void _onFlipShapeHorizontal(
    FlipShapeHorizontalEvent event,
    Emitter<CanvasState> emit,
  ) {
    final updatedShapes = state.shapes.map((shape) {
      if (shape.id == event.shapeId) {
        return shape.copyWith(
          isFlippedHorizontally: !shape.isFlippedHorizontally,
        );
      }
      return shape;
    }).toList();

    emit(
      _pushToHistory(state).copyWith(
        shapes: updatedShapes,
        redoHistory: const [],
      ),
    );
  }

  void _onFlipShapeVertical(
    FlipShapeVerticalEvent event,
    Emitter<CanvasState> emit,
  ) {
    final updatedShapes = state.shapes.map((shape) {
      if (shape.id == event.shapeId) {
        return shape.copyWith(
          isFlippedVertically: !shape.isFlippedVertically,
        );
      }
      return shape;
    }).toList();

    emit(
      _pushToHistory(state).copyWith(
        shapes: updatedShapes,
        redoHistory: const [],
      ),
    );
  }

  void _onSelectShape(SelectShapeEvent event, Emitter<CanvasState> emit) {
    emit(
      state.copyWith(
        selectedShapeId: () => event.shapeId,
        animatingShapeId: () => null,
      ),
    );
  }

  void _onDeleteShape(DeleteShapeEvent event, Emitter<CanvasState> emit) {
    final updatedShapes = state.shapes
        .where((s) => s.id != event.shapeId)
        .toList();

    emit(
      _pushToHistory(state).copyWith(
        shapes: updatedShapes,
        selectedShapeId: () => state.selectedShapeId == event.shapeId
            ? null
            : state.selectedShapeId,
        redoHistory: const [],
      ),
    );
  }

  void _onClearCanvas(ClearCanvasEvent event, Emitter<CanvasState> emit) {
    if (state.shapes.isEmpty) return;

    emit(
      _pushToHistory(state).copyWith(
        shapes: const [],
        selectedShapeId: () => null,
        redoHistory: const [],
      ),
    );
  }

  void _onUndo(UndoEvent event, Emitter<CanvasState> emit) {
    if (!state.canUndo) return;

    final previousShapes = state.undoHistory.last;
    final newUndoHistory = state.undoHistory.sublist(
      0,
      state.undoHistory.length - 1,
    );
    final newRedoHistory = [...state.redoHistory, state.shapes];

    emit(
      state.copyWith(
        shapes: previousShapes,
        undoHistory: newUndoHistory,
        redoHistory: newRedoHistory.length > _maxHistorySize
            ? newRedoHistory.sublist(newRedoHistory.length - _maxHistorySize)
            : newRedoHistory,
        selectedShapeId: () => null,
      ),
    );
  }

  void _onRedo(RedoEvent event, Emitter<CanvasState> emit) {
    if (!state.canRedo) return;

    final nextShapes = state.redoHistory.last;
    final newRedoHistory = state.redoHistory.sublist(
      0,
      state.redoHistory.length - 1,
    );
    final newUndoHistory = [...state.undoHistory, state.shapes];

    emit(
      state.copyWith(
        shapes: nextShapes,
        undoHistory: newUndoHistory.length > _maxHistorySize
            ? newUndoHistory.sublist(newUndoHistory.length - _maxHistorySize)
            : newUndoHistory,
        redoHistory: newRedoHistory,
        selectedShapeId: () => null,
      ),
    );
  }

  void _onSavePositionToHistory(
    SavePositionToHistoryEvent event,
    Emitter<CanvasState> emit,
  ) {
    emit(_pushToHistory(state).copyWith(redoHistory: const []));
  }

  void _onSaveScaleToHistory(
    SaveScaleToHistoryEvent event,
    Emitter<CanvasState> emit,
  ) {
    emit(_pushToHistory(state).copyWith(redoHistory: const []));
  }

  void _onClearAnimatingShape(
    ClearAnimatingShapeEvent event,
    Emitter<CanvasState> emit,
  ) {
    emit(state.copyWith(animatingShapeId: () => null));
  }

  /// Saves current state to undo history and clears animating state.
  CanvasState _pushToHistory(CanvasState currentState) {
    final newHistory = [...currentState.undoHistory, currentState.shapes];
    return currentState.copyWith(
      undoHistory: newHistory.length > _maxHistorySize
          ? newHistory.sublist(newHistory.length - _maxHistorySize)
          : newHistory,
      animatingShapeId: () => null,
    );
  }
}
