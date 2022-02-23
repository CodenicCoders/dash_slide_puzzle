import 'dart:math';

import 'package:presentation/presentation.dart';

/// {@template StarPainter}
///
/// A single star painter fo the background.
///
/// Code was stolen from Kabos' wonderful
/// [flutter_glitters](https://github.com/kaboc/flutter_glitters) package!
///
/// {@endtemplate}
class StarPainter extends CustomPainter {
  /// {@macro StarPainter}
  StarPainter({required this.animation}) : super(repaint: animation);

  static const double _circleSizeRatio = 0.55;
  static const double _minCrossWidth = 2;
  static const double _opacity = 0.75;

  /// The parent [Animation] for making the star twinkle.
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    const arcCurve = ArcCurve();
    final t = arcCurve.transform(animation.value);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final dimension = size.longestSide;

    final center = Offset(dimension / 2, dimension / 2);
    final radius = dimension * _circleSizeRatio * t;

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    const color = Colors.white;

    canvas.drawPath(
      circlePath,
      paint
        ..shader = RadialGradient(
          colors: <Color>[
            color.withOpacity(_opacity),
            color.withOpacity(_opacity * 0.7),
            color.withOpacity(0),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius),
        ),
    );

    final smallerCirclePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius * 0.5));

    canvas.drawPath(
      smallerCirclePath,
      paint
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFFFFFFFF).withOpacity(_opacity * 0.9),
            const Color(0x00FFFFFF),
          ],
          stops: const <double>[0.4, 1],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius * 0.5),
        ),
    );

    final crossWidth = max(_minCrossWidth, dimension / 17);
    final crossHalfWidth = crossWidth / 2;

    final crossPath = Path()
      ..moveTo(center.dx - crossHalfWidth, center.dy - crossHalfWidth)
      ..lineTo(center.dx, 0)
      ..lineTo(center.dx + crossHalfWidth, center.dy - crossHalfWidth)
      ..lineTo(dimension, center.dy)
      ..lineTo(center.dx + crossHalfWidth, center.dy + crossHalfWidth)
      ..lineTo(center.dx, dimension)
      ..lineTo(center.dx - crossHalfWidth, center.dy + crossHalfWidth)
      ..lineTo(0, center.dy)
      ..lineTo(center.dx - crossHalfWidth, center.dy - crossHalfWidth);

    canvas.drawPath(
      crossPath,
      paint
        ..color = Colors.white
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFFFFFFFF).withOpacity(_opacity),
            color.withOpacity(_opacity),
          ],
          stops: const <double>[0.1, 0.45],
        ).createShader(
          Rect.fromCircle(
            center: Offset(center.dx, center.dy),
            radius: dimension / 2,
          ),
        ),
    );
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => false;
}
