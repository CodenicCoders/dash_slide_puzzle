import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

/// {@template StarAnimator}
///
/// Creates an animated star object.
///
/// {@endtemplate}
class StarAnimator extends StatefulWidget {
  /// {@macro StarAnimator}
  const StarAnimator({
    required this.size,
    this.twinkleMinDuration = const Duration(milliseconds: 1000),
    this.twinkleMaxDuration = const Duration(seconds: 2),
    this.twinkleMinCooldown = Duration.zero,
    this.twinkleMaxCooldown = const Duration(seconds: 2),
    this.twinkleProbability = 0.3,
    Key? key,
  }) : super(key: key);

  /// The size of the star.
  final double size;

  /// The minimum [Duration] for the star twinkle.
  final Duration twinkleMinDuration;

  /// The maximum [Duration] for the star twinkle.
  final Duration twinkleMaxDuration;

  /// The minimum cooldown for the next star twinkle.
  final Duration twinkleMinCooldown;

  /// The maximum cooldown for the next star twinkle.
  final Duration twinkleMaxCooldown;

  /// The probability that the star will twinkle when the cooldown is reached.
  /// 
  /// This value must range between `0` and `1` inclusively.
  /// 
  /// Regardless whether the star twinkles or not, a new twinkle cooldown will 
  /// commence.
  final double twinkleProbability;

  @override
  State<StarAnimator> createState() => _StarAnimatorState();
}

class _StarAnimatorState extends State<StarAnimator>
    with SingleTickerProviderStateMixin {
  late final _twinkleAnimation = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();

    _twinkleAnimation.addStatusListener((status) {
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
          _twinkleAnimation
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
    _twinkleAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _twinkleAnimation,
      builder: (context, child) {
        const twinkleCurve = ArcCurve();
        final t = twinkleCurve.transform(_twinkleAnimation.value);

        return Transform.scale(
          scale: max(t, 0.5),
          child: CustomPaint(
            painter: StarPainter(animation: _twinkleAnimation),
            child: SizedBox.square(dimension: widget.size),
          ),
        );
      },
    );
  }
}
