import 'package:flutter/material.dart';
import 'package:flutter_ui_prototyping/features/bill_splitter/bill_splitter_colors.dart';

class SplitSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  const SplitSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.activeColor,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: activeColor,
        inactiveTrackColor: BillSplitterColors.sliderTrackInactive,
        thumbColor: activeColor,
        thumbShape: _CustomThumbShape(activeColor),
        overlayColor: activeColor.withValues(alpha: 0.2),
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  final Color color;

  const _CustomThumbShape(this.color);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Outer glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, 14, glowPaint);

    // Main thumb
    final thumbPaint = Paint()..color = color;
    canvas.drawCircle(center, 12, thumbPaint);

    // Inner highlight
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawCircle(center.translate(-2, -2), 4, highlightPaint);
  }
}
