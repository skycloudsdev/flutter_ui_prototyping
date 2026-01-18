import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_model.dart';
import 'package:flutter_ui_prototyping/features/canvas_editor/models/shape_type.dart';

/// CustomPainter for rendering shapes on the canvas.
class CanvasPainter extends CustomPainter {
  final List<ShapeModel> shapes;
  final String? selectedShapeId;
  final String? animatingShapeId;
  final double animationValue;

  CanvasPainter({
    required this.shapes,
    this.selectedShapeId,
    this.animatingShapeId,
    this.animationValue = 1.0,
  });

  static const Map<ShapeType, Color> _shapeColors = {
    ShapeType.circle: Colors.blue,
    ShapeType.square: Colors.green,
    ShapeType.triangle: Colors.orange,
  };

  @override
  void paint(Canvas canvas, Size size) {
    for (final shape in shapes) {
      final isSelected = shape.id == selectedShapeId;
      final isAnimating = shape.id == animatingShapeId;
      final scale = isAnimating ? animationValue : 1.0;

      _drawShape(canvas, shape, isSelected, scale);
    }
  }

  void _drawShape(
    Canvas canvas,
    ShapeModel shape,
    bool isSelected,
    double scale,
  ) {
    final paint = Paint()
      ..color = _shapeColors[shape.type] ?? Colors.grey
      ..style = PaintingStyle.fill;

    final scaledSize = Size(
      shape.size.width * scale,
      shape.size.height * scale,
    );

    canvas.save();
    canvas.translate(shape.position.dx, shape.position.dy);

    // Apply rotation
    if (shape.rotation != 0) {
      canvas.rotate(shape.rotation);
    }

    // Apply flip transformations
    if (shape.isFlippedHorizontally || shape.isFlippedVertically) {
      canvas.scale(
        shape.isFlippedHorizontally ? -1 : 1,
        shape.isFlippedVertically ? -1 : 1,
      );
    }

    switch (shape.type) {
      case ShapeType.circle:
        _drawCircle(canvas, scaledSize, paint);
      case ShapeType.square:
        _drawSquare(canvas, scaledSize, paint);
      case ShapeType.triangle:
        _drawTriangle(canvas, scaledSize, paint);
    }

    canvas.restore();

    // Draw selection border
    if (isSelected) {
      _drawSelectionBorder(canvas, shape, scaledSize);
    }
  }

  void _drawCircle(Canvas canvas, Size size, Paint paint) {
    final radius = size.width / 2;
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  void _drawSquare(Canvas canvas, Size size, Paint paint) {
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: size.width,
      height: size.height,
    );
    canvas.drawRect(rect, paint);
  }

  void _drawTriangle(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;

    path.moveTo(0, -halfHeight); // Top vertex
    path.lineTo(halfWidth, halfHeight); // Bottom right
    path.lineTo(-halfWidth, halfHeight); // Bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawSelectionBorder(Canvas canvas, ShapeModel shape, Size scaledSize) {
    final borderPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final handlePaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(shape.position.dx, shape.position.dy);

    // Apply rotation to selection border too
    if (shape.rotation != 0) {
      canvas.rotate(shape.rotation);
    }

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: scaledSize.width + 10,
      height: scaledSize.height + 10,
    );

    // Draw border
    canvas.drawRect(rect, borderPaint);

    // Draw corner handles
    const handleRadius = 6.0;
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomLeft,
      rect.bottomRight,
    ];

    for (final corner in corners) {
      canvas.drawCircle(corner, handleRadius, handlePaint);
    }

    // Draw rotation handle at top center
    final rotationHandlePos = Offset(0, rect.top - 20);
    canvas.drawLine(
      Offset(0, rect.top),
      rotationHandlePos,
      borderPaint,
    );
    canvas.drawCircle(rotationHandlePos, handleRadius, handlePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) {
    return shapes != oldDelegate.shapes ||
        selectedShapeId != oldDelegate.selectedShapeId ||
        animatingShapeId != oldDelegate.animatingShapeId ||
        animationValue != oldDelegate.animationValue;
  }
}
