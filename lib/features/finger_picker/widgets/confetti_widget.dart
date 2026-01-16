import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A confetti particle for the celebration effect.
class ConfettiParticle {
  Offset position;
  Offset velocity;
  final Color color;
  final double size;
  final double rotationSpeed;
  double rotation;
  double opacity;

  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.rotationSpeed,
    this.rotation = 0,
    this.opacity = 1.0,
  });
}

/// Widget that displays confetti animation for winner celebration.
class ConfettiWidget extends StatefulWidget {
  final Offset origin;
  final VoidCallback? onComplete;

  const ConfettiWidget({
    required this.origin,
    super.key,
    this.onComplete,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  static const _particleCount = 80;
  static const _colors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFE66D),
    Color(0xFF95E1D3),
    Color(0xFFF38181),
    Color(0xFFAA96DA),
    Color(0xFFFCBAD3),
    Color(0xFFA8D8EA),
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _initializeParticles();

    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(seconds: 3),
          )
          ..addListener(_updateParticles)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onComplete?.call();
            }
          })
          ..forward();
  }

  void _initializeParticles() {
    for (var i = 0; i < _particleCount; i++) {
      final angle = _random.nextDouble() * math.pi * 2;
      final speed = 200 + _random.nextDouble() * 400;

      _particles.add(
        ConfettiParticle(
          position: widget.origin,
          velocity: Offset(
            math.cos(angle) * speed,
            math.sin(angle) * speed - 200, // Bias upward
          ),
          color: _colors[_random.nextInt(_colors.length)],
          size: 6 + _random.nextDouble() * 8,
          rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        ),
      );
    }
  }

  void _updateParticles() {
    if (!mounted) return;

    const dt = 1 / 60; // Assume 60 FPS
    const gravity = 500.0;
    const drag = 0.98;

    for (final particle in _particles) {
      // Apply physics
      particle.velocity = Offset(
        particle.velocity.dx * drag,
        particle.velocity.dy * drag + gravity * dt,
      );

      particle.position += particle.velocity * dt;
      particle.rotation += particle.rotationSpeed * dt;

      // Fade out over time
      particle.opacity = (1.0 - _controller.value).clamp(0.0, 1.0);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConfettiPainter(particles: _particles),
        size: Size.infinite,
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      // Draw rectangle confetti
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size * 0.6,
      );
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
