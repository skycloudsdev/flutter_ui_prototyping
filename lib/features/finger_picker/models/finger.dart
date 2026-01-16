import 'dart:ui';

/// Represents a finger touch point on the screen.
class Finger {
  /// Unique identifier for this finger (pointer ID from system).
  final int id;

  /// Current position of the finger on the screen.
  final Offset position;

  /// Color assigned to this finger's bubble.
  final Color color;

  /// Whether this finger is currently highlighted during selection.
  final bool isHighlighted;

  /// Scale factor for the bubble (1.0 = normal, larger for winner).
  final double scale;

  const Finger({
    required this.id,
    required this.position,
    required this.color,
    this.isHighlighted = false,
    this.scale = 1.0,
  });

  /// Creates a copy of this finger with updated properties.
  Finger copyWith({
    int? id,
    Offset? position,
    Color? color,
    bool? isHighlighted,
    double? scale,
  }) {
    return Finger(
      id: id ?? this.id,
      position: position ?? this.position,
      color: color ?? this.color,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      scale: scale ?? this.scale,
    );
  }
}
