import 'dart:ui';

import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_type.dart';

/// Base class for all canvas events.
sealed class CanvasEvent {
  const CanvasEvent();
}

/// Event to add a new shape to the canvas.
class AddShapeEvent extends CanvasEvent {
  final ShapeType shapeType;
  final Offset position;

  const AddShapeEvent({
    required this.shapeType,
    required this.position,
  });
}

/// Event to update a shape's position.
class UpdateShapePositionEvent extends CanvasEvent {
  final String shapeId;
  final Offset position;

  const UpdateShapePositionEvent({
    required this.shapeId,
    required this.position,
  });
}

/// Event to update a shape's scale/size.
class UpdateShapeScaleEvent extends CanvasEvent {
  final String shapeId;
  final Size newSize;

  const UpdateShapeScaleEvent({
    required this.shapeId,
    required this.newSize,
  });
}

/// Event to update a shape's rotation.
class UpdateShapeRotationEvent extends CanvasEvent {
  final String shapeId;
  final double rotation;

  const UpdateShapeRotationEvent({
    required this.shapeId,
    required this.rotation,
  });
}

/// Event to rotate a shape by 90 degrees.
class RotateShape90Event extends CanvasEvent {
  final String shapeId;

  const RotateShape90Event({required this.shapeId});
}

/// Event to flip a shape horizontally.
class FlipShapeHorizontalEvent extends CanvasEvent {
  final String shapeId;

  const FlipShapeHorizontalEvent({required this.shapeId});
}

/// Event to flip a shape vertically.
class FlipShapeVerticalEvent extends CanvasEvent {
  final String shapeId;

  const FlipShapeVerticalEvent({required this.shapeId});
}

/// Event to select or deselect a shape.
class SelectShapeEvent extends CanvasEvent {
  final String? shapeId;

  const SelectShapeEvent({this.shapeId});
}

/// Event to delete a shape from the canvas.
class DeleteShapeEvent extends CanvasEvent {
  final String shapeId;

  const DeleteShapeEvent({required this.shapeId});
}

/// Event to clear all shapes from the canvas.
class ClearCanvasEvent extends CanvasEvent {
  const ClearCanvasEvent();
}

/// Event to undo the last action.
class UndoEvent extends CanvasEvent {
  const UndoEvent();
}

/// Event to redo the last undone action.
class RedoEvent extends CanvasEvent {
  const RedoEvent();
}

/// Event to save position to history (called when drag ends).
class SavePositionToHistoryEvent extends CanvasEvent {
  const SavePositionToHistoryEvent();
}

/// Event to save scale to history (called when scale ends).
class SaveScaleToHistoryEvent extends CanvasEvent {
  const SaveScaleToHistoryEvent();
}

/// Event to clear the animating shape id.
class ClearAnimatingShapeEvent extends CanvasEvent {
  const ClearAnimatingShapeEvent();
}
