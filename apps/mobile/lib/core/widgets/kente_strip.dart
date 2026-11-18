import 'package:flutter/widgets.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// The woven band that marks creator media: gold, orange, violet, earth.
class KenteStrip extends StatelessWidget {
  const KenteStrip({super.key, this.height = 4, this.block = 14});

  final double height;
  final double block;

  static const _colors = [
    TalantaBrand.gold,
    TalantaBrand.primary,
    TalantaBrand.secondary,
    Color(0xFF3A2A12),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _KentePainter(block)),
    );
  }
}

class _KentePainter extends CustomPainter {
  _KentePainter(this.block);

  final double block;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    var index = 0;
    for (var x = 0.0; x < size.width; x += block) {
      paint.color = KenteStrip._colors[index % KenteStrip._colors.length];
      canvas.drawRect(Rect.fromLTWH(x, 0, block, size.height), paint);
      index++;
    }
  }

  @override
  bool shouldRepaint(_KentePainter oldDelegate) => oldDelegate.block != block;
}
