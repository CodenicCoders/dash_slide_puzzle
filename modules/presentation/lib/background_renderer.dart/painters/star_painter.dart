/// Credits to Kabo for his wonderful 
/// [flutter_glitters](https://github.com/kaboc/flutter_glitters) package!
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:presentation/presentation.dart';

const double kDefaultSize = 20.0;
const double kCircleSizeRatio = 0.55;
const double kMinCrossWidth = 2.0;
const double kDefaultAspectRatio = 1.0;
const Duration kDefaultDuration = Duration(milliseconds: 150);
const Duration kDefaultInDuration = Duration(milliseconds: 150);
const Duration kDefaultOutDuration = Duration(milliseconds: 200);
const Duration kDefaultInterval = Duration(milliseconds: 500);
const Color kDefaultColor = Color(0xFFFFEB3B);

class StarPainter extends CustomPainter {
  StarPainter({
    required this.dimension,
    required this.twinkle,
    required this.opacity,
  });

  final double dimension;
  final double twinkle;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final center = Offset(dimension / 2, dimension / 2);
    final radius = dimension * kCircleSizeRatio * twinkle;

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    const color = Colors.white;

    canvas.drawPath(
      circlePath,
      paint
        ..shader = RadialGradient(
          colors: <Color>[
            color.withOpacity(opacity),
            color.withOpacity(opacity * 0.7),
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
            const Color(0xFFFFFFFF).withOpacity(opacity * 0.9),
            const Color(0x00FFFFFF),
          ],
          stops: const <double>[0.4, 1],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius * 0.5),
        ),
    );

    final crossWidth = max(kMinCrossWidth, dimension / 17);
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
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFFFFFFFF).withOpacity(opacity),
            color.withOpacity(opacity),
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
  bool shouldRepaint(StarPainter oldDelegate) {
    return opacity != oldDelegate.opacity;
  }
}

double calculateWidth(double width, double height, double aspectRatio) {
  return width / height >= aspectRatio ? height * aspectRatio : width;
}

double calculateHeight(double width, double height, double aspectRatio) {
  return width / height >= aspectRatio ? height : width / aspectRatio;
}
