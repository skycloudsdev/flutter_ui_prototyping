import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/finger_picker/models/models.dart';

/// Custom painter for rendering bubbles with glow effects.
class BubblePainter extends CustomPainter {
  final Map<int, Finger> fingers;
  final double animationValue;
  final int? winnerId;

  BubblePainter({
    required this.fingers,
    required this.animationValue,
    this.winnerId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final finger in fingers.values) {
      _drawBubble(canvas, finger);
    }
  }

  void _drawBubble(Canvas canvas, Finger finger) {
    final isWinner = winnerId != null && finger.id == winnerId;
    final baseRadius = isWinner
        ? GameConfig.winnerBubbleRadius
        : GameConfig.bubbleRadius;
    final radius = baseRadius * finger.scale;
    final glowRadius = GameConfig.glowRadius * finger.scale;

    // Pulsing effect
    final pulse = 1.0 + (math.sin(animationValue * math.pi * 2) * 0.1);
    final effectiveRadius = radius * pulse;
    final effectiveGlowRadius = glowRadius * pulse;

    // Draw outer glow
    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        finger.position,
        effectiveRadius + effectiveGlowRadius,
        [
          finger.color.withValues(alpha: finger.isHighlighted ? 0.6 : 0.4),
          finger.color.withValues(alpha: 0.1),
          finger.color.withValues(alpha: 0),
        ],
        [0, 0.6, 1],
      );

    canvas.drawCircle(
      finger.position,
      effectiveRadius + effectiveGlowRadius,
      glowPaint,
    );

    // Draw main bubble with gradient
    final bubblePaint = Paint()
      ..shader = ui.Gradient.radial(
        finger.position.translate(
          -effectiveRadius * 0.3,
          -effectiveRadius * 0.3,
        ),
        effectiveRadius * 1.5,
        [
          finger.color.withValues(alpha: 0.9),
          finger.color.withValues(alpha: 0.6),
          finger.color.withValues(alpha: 0.3),
        ],
        [0, 0.5, 1],
      );

    canvas.drawCircle(finger.position, effectiveRadius, bubblePaint);

    // Draw highlight shine
    final shinePaint = Paint()
      ..shader = ui.Gradient.radial(
        finger.position.translate(
          -effectiveRadius * 0.3,
          -effectiveRadius * 0.3,
        ),
        effectiveRadius * 0.5,
        [
          Colors.white.withValues(alpha: 0.6),
          Colors.white.withValues(alpha: 0),
        ],
      );

    canvas.drawCircle(
      finger.position.translate(-effectiveRadius * 0.2, -effectiveRadius * 0.2),
      effectiveRadius * 0.35,
      shinePaint,
    );

    // Draw border ring for highlighted finger
    if (finger.isHighlighted) {
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colors.white.withValues(alpha: 0.8);

      canvas.drawCircle(finger.position, effectiveRadius + 4, ringPaint);
    }

    // Draw winner star pattern
    if (isWinner) {
      _drawWinnerDecoration(canvas, finger.position, effectiveRadius);
    }
  }

  void _drawWinnerDecoration(Canvas canvas, Offset center, double radius) {
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // Draw small stars around the winner bubble
    const starCount = 8;
    for (var i = 0; i < starCount; i++) {
      final angle =
          (i / starCount) * math.pi * 2 + animationValue * math.pi * 2;
      final distance = radius + 20 + (math.sin(angle * 3) * 10);
      final starPos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      _drawStar(canvas, starPos, 6, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const points = 5;
    const innerRadius = 0.4;

    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? size : size * innerRadius;
      final angle = (i * math.pi / points) - (math.pi / 2);
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return oldDelegate.fingers != fingers ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.winnerId != winnerId;
  }
}
