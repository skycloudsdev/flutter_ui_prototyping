import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_type.dart';

/// Immutable model representing a shape on the canvas.
@immutable
class ShapeModel {
  final String id;
  final ShapeType type;
  final Offset position;
  final Size size;
  final double rotation; // in radians
  final bool isFlippedHorizontally;
  final bool isFlippedVertically;

  const ShapeModel({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    this.rotation = 0,
    this.isFlippedHorizontally = false,
    this.isFlippedVertically = false,
  });

  /// Returns the bounding rectangle of the shape.
  Rect get bounds => Rect.fromCenter(
    center: position,
    width: size.width,
    height: size.height,
  );

  /// Checks if a point is within the shape's bounds (with optional padding).
  bool containsPoint(Offset point, {double padding = 10}) {
    final paddedBounds = bounds.inflate(padding);
    return paddedBounds.contains(point);
  }

  /// Creates a copy of the shape with updated properties.
  ShapeModel copyWith({
    String? id,
    ShapeType? type,
    Offset? position,
    Size? size,
    double? rotation,
    bool? isFlippedHorizontally,
    bool? isFlippedVertically,
  }) {
    return ShapeModel(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      isFlippedHorizontally:
          isFlippedHorizontally ?? this.isFlippedHorizontally,
      isFlippedVertically: isFlippedVertically ?? this.isFlippedVertically,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShapeModel &&
        other.id == id &&
        other.type == type &&
        other.position == position &&
        other.size == size &&
        other.rotation == rotation &&
        other.isFlippedHorizontally == isFlippedHorizontally &&
        other.isFlippedVertically == isFlippedVertically;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      type,
      position,
      size,
      rotation,
      isFlippedHorizontally,
      isFlippedVertically,
    );
  }
}
