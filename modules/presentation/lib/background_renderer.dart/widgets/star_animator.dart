import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

class StarAnimator extends StatefulWidget {
  const StarAnimator({
    required this.size,
    required this.opacity,
    this.twinkleMinDuration = const Duration(milliseconds: 1000),
    this.twinkleMaxDuration = const Duration(seconds: 2),
    this.twinkleMinCooldown = Duration.zero,
    this.twinkleMaxCooldown = const Duration(seconds: 2),
    this.twinkleProbability = 0.3,
    Key? key,
  }) : super(key: key);

  final double size;
  final double opacity;
  final Duration twinkleMinDuration;
  final Duration twinkleMaxDuration;
  final Duration twinkleMinCooldown;
  final Duration twinkleMaxCooldown;
  final double twinkleProbability;

  @override
  State<StarAnimator> createState() => _StarAnimatorState();
}

class _StarAnimatorState extends State<StarAnimator>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _setupNextTwinkle();
      }
    });

    _setupNextTwinkle();
  }

  void _setupNextTwinkle() {
    Future.delayed(
      widget.twinkleMinCooldown.randomInBetween(widget.twinkleMaxCooldown),
      () {
        if (!mounted) {
          return;
        }

        final twinkleValue = Random().nextDouble();

        if (twinkleValue <= widget.twinkleProbability) {
          _animationController
            ..duration = widget.twinkleMinDuration
                .randomInBetween(widget.twinkleMaxDuration)
            ..forward(from: 0);
        } else {
          _setupNextTwinkle();
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        const twinkleCurve = ArcCurve();
        final t = twinkleCurve.transform(_animationController.value);

        return Transform.scale(
          scale: max(t, 0.5),
          child: CustomPaint(
            painter: StarPainter(
              dimension: widget.size,
              opacity: widget.opacity,
              twinkle: t,
            ),
            child: SizedBox.square(dimension: widget.size),
          ),
        );
      },
    );
  }
}
