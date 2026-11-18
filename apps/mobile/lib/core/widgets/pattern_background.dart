import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// A faint woven pattern in the spirit of mudcloth and kente strips. Painted,
/// not an image, so it costs nothing to ship and scales to any screen.
/// Stands in until the brand illustrations arrive.
class PatternBackground extends StatelessWidget {
  const PatternBackground({
    required this.child,
    super.key,
    this.opacity = 0.06,
  });

  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeavePainter(
        color: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: opacity),
      ),
      child: child,
    );
  }
}

class _WeavePainter extends CustomPainter {
  const _WeavePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const cell = TalantaSpacing.x12;
    final line = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final dot = Paint()..color = color;

    for (var y = 0.0; y < size.height + cell; y += cell) {
      final row = (y / cell).floor();
      for (var x = 0.0; x < size.width + cell; x += cell) {
        final col = (x / cell).floor();
        final center = Offset(x + cell / 2, y + cell / 2);
        if ((row + col).isEven) {
          // Diamond, the mudcloth motif.
          final path = Path()
            ..moveTo(center.dx, center.dy - cell / 3)
            ..lineTo(center.dx + cell / 3, center.dy)
            ..lineTo(center.dx, center.dy + cell / 3)
            ..lineTo(center.dx - cell / 3, center.dy)
            ..close();
          canvas.drawPath(path, line);
        } else {
          // Three short strokes, the kente weave.
          for (var i = -1; i <= 1; i++) {
            final dy = center.dy + i * cell / 6;
            canvas.drawLine(
              Offset(center.dx - cell / 4, dy),
              Offset(center.dx + cell / 4, dy),
              line,
            );
          }
        }
        canvas.drawCircle(Offset(x, y), 1.5, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_WeavePainter oldDelegate) => oldDelegate.color != color;
}

/// The signature orange-to-violet gradient. Logo, splash and record button only.
class SignatureGradient extends StatelessWidget {
  const SignatureGradient({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: TalantaBrand.signatureGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: GradientRotation(math.pi / 12),
      ).createShader(bounds),
      child: child,
    );
  }
}
