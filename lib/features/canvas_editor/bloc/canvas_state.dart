import 'package:flutter/foundation.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_model.dart';

/// Represents the state of the canvas editor.
@immutable
class CanvasState {
  final List<ShapeModel> shapes;
  final String? selectedShapeId;
  final List<List<ShapeModel>> undoHistory;
  final List<List<ShapeModel>> redoHistory;
  final String? animatingShapeId;

  const CanvasState({
    this.shapes = const [],
    this.selectedShapeId,
    this.undoHistory = const [],
    this.redoHistory = const [],
    this.animatingShapeId,
  });

  /// Returns the currently selected shape, if any.
  ShapeModel? get selectedShape {
    if (selectedShapeId == null) return null;
    try {
      return shapes.firstWhere((s) => s.id == selectedShapeId);
    } catch (_) {
      return null;
    }
  }

  /// Whether undo is available.
  bool get canUndo => undoHistory.isNotEmpty;

  /// Whether redo is available.
  bool get canRedo => redoHistory.isNotEmpty;

  /// Creates a copy of the state with updated properties.
  CanvasState copyWith({
    List<ShapeModel>? shapes,
    String? Function()? selectedShapeId,
    List<List<ShapeModel>>? undoHistory,
    List<List<ShapeModel>>? redoHistory,
    String? Function()? animatingShapeId,
  }) {
    return CanvasState(
      shapes: shapes ?? this.shapes,
      selectedShapeId: selectedShapeId != null
          ? selectedShapeId()
          : this.selectedShapeId,
      undoHistory: undoHistory ?? this.undoHistory,
      redoHistory: redoHistory ?? this.redoHistory,
      animatingShapeId: animatingShapeId != null
          ? animatingShapeId()
          : this.animatingShapeId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CanvasState &&
        listEquals(other.shapes, shapes) &&
        other.selectedShapeId == selectedShapeId &&
        other.animatingShapeId == animatingShapeId;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(shapes),
    selectedShapeId,
    animatingShapeId,
  );
}
