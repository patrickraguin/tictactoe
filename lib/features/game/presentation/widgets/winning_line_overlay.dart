import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Superposition animée traçant la ligne gagnante sur le plateau.
///
/// Utilise [TweenAnimationBuilder] pour animer le tracé progressif de la ligne
/// (0 → 100 % en 400 ms). N'intercepte aucun événement pointeur ([IgnorePointer]).
class WinningLineOverlay extends StatelessWidget {
  const WinningLineOverlay({
    super.key,
    required this.line,
    required this.color,
  });

  final List<int> line;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        builder: (context, t, _) => CustomPaint(
          painter: _LinePainter(line: line, color: color, progress: t),
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// Peintre personnalisé qui trace la ligne gagnante de façon progressive.
///
/// [progress] (0.0 → 1.0) contrôle la longueur du trait dessiné entre le
/// centre de la première et de la dernière cellule de la ligne gagnante.
class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.line,
    required this.color,
    required this.progress,
  });

  static const double _strokeWidth = 8;

  final List<int> line;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (line.length < 3) return;
    final cell = size.width / 3;
    Offset center(int index) {
      final row = index ~/ 3;
      final col = index % 3;
      return Offset(col * cell + cell / 2, row * cell + cell / 2);
    }

    final start = center(line.first);
    final end = center(line.last);
    final current = Offset.lerp(start, end, progress)!;

    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, current, paint);
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.progress != progress ||
      !listEquals(old.line, line) ||
      old.color != color;
}
