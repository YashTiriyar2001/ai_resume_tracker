import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Scattered glowing ember particles behind onboarding content.
class EmberBackground extends StatelessWidget {
  const EmberBackground({super.key});

  static const _particles = <_Particle>[
    _Particle(0.12, 0.08, 6, 0.9),
    _Particle(0.88, 0.14, 4, 0.7),
    _Particle(0.05, 0.32, 3, 0.5),
    _Particle(0.94, 0.38, 5, 0.6),
    _Particle(0.22, 0.52, 4, 0.45),
    _Particle(0.78, 0.58, 7, 0.55),
    _Particle(0.48, 0.18, 3, 0.4),
    _Particle(0.62, 0.72, 5, 0.35),
    _Particle(0.15, 0.78, 4, 0.5),
    _Particle(0.85, 0.82, 6, 0.4),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _EmberPainter(
            particles: _particles,
            seed: constraints.maxWidth.hashCode,
          ),
        );
      },
    );
  }
}

class _Particle {
  const _Particle(this.x, this.y, this.radius, this.opacity);

  final double x;
  final double y;
  final double radius;
  final double opacity;
}

class _EmberPainter extends CustomPainter {
  _EmberPainter({required this.particles, required this.seed});

  final List<_Particle> particles;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    for (final particle in particles) {
      final center = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );
      final glowRadius = particle.radius * (2.2 + random.nextDouble());
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            Color(0xFFFF8C00).withValues(alpha: particle.opacity),
            Color(0xFFFF8C00).withValues(alpha: 0),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: glowRadius * 3),
        );
      canvas.drawCircle(center, glowRadius * 3, paint);
      canvas.drawCircle(
        center,
        particle.radius,
        Paint()..color = Color(0xFFFFB74D).withValues(alpha: particle.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
