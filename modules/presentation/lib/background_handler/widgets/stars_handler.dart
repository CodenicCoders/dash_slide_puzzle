import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:presentation/background_handler/widgets/star_animator.dart';
import 'package:presentation/presentation.dart';

/// {@template StarsHandler}
///
/// A widget for rendering multiple animated stars in the background.
///
/// {@endtemplate}
class StarsHandler extends StatelessWidget {
  /// {@macro StarsHandler}
  const StarsHandler({
    this.starBoundSize = 40,
    this.starMaxSize = 32,
    this.spacing = 4,
    this.starCreationProbability = 0.12,
    Key? key,
  }) : super(key: key);

  /// The size of the bounding box for each stars.
  ///
  /// A bounding box is spread evenly throughout the screen and they do not
  /// overlap with one another.
  ///
  /// A bounding box may contain a single star or none at all. The larger the
  /// bounding size the lesser the stars will be and vice-versa.
  final double starBoundSize;

  /// The max size of the star.
  final double starMaxSize;

  /// A padding for the star bounding box.
  ///
  /// This ensures that stars won't directly touch each other.
  final double spacing;

  /// The probability that a single star will be generated in a bounding box.
  final double starCreationProbability;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocBuilder<app.SwitchThemeUseCase, app.RunnerState>(
          buildWhen: (oldState, newState) => newState is app.RunSuccess,
          builder: (context, state) {
            final starProps = _generateStarProps(constraints);

            return Stack(
              children: [
                for (var i = 0; i < starProps.length; i++)
                  AnimatedAlign(
                    key: ValueKey(i),
                    alignment: starProps[i].boundingBoxOffset,
                    duration: const Duration(milliseconds: 500),
                    child: SizedBox.square(
                      dimension: starBoundSize,
                      child: Align(
                        alignment: starProps[i].starPosition,
                        child: StarAnimator(
                          size: starMaxSize * starProps[i].scale,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  /// Generate the star properties with a quantity respective to the
  /// [screenConstraints].
  ///
  /// Each [_StarProps] represents a single star.
  ///
  /// The total number of [_StarProps] is less than the number of bounding box
  /// that can fit in the screen.
  List<_StarProps> _generateStarProps(BoxConstraints screenConstraints) {
    final boundingWidth = screenConstraints.maxWidth;
    final boundingHeight = screenConstraints.maxHeight;

    final starBoundingBoxWithMargin = starBoundSize + spacing * 2;

    final maxStarsPerRow = boundingWidth ~/ starBoundingBoxWithMargin;
    final maxStarsPerColumn = boundingHeight ~/ starBoundingBoxWithMargin;

    final starProps = <_StarProps>[];

    final random = Random();

    for (var y = 0; y < maxStarsPerColumn; y++) {
      for (var x = 0; x <= maxStarsPerRow; x++) {
        final starCreationValue = random.nextDouble();

        if (starCreationValue > starCreationProbability) {
          continue;
        }

        final offset =
            FractionalOffset(x / maxStarsPerRow, y / maxStarsPerColumn);

        final alignment = _randomizeStarPosition();

        final scale = random.nextDouble();

        final props = _StarProps(
          boundingBoxOffset: offset,
          starPosition: alignment,
          scale: scale,
        );
        starProps.add(props);
      }
    }

    return starProps;
  }
}

/// Creates a random value for the [_StarProps.starPosition].
Alignment _randomizeStarPosition() {
  final rnd = Random();

  final dx = rnd.nextInt(13) / 12;
  final dy = rnd.nextInt(13) / 12;

  return FractionalOffset(dx, dy);
}

class _StarProps {
  const _StarProps({
    required this.boundingBoxOffset,
    required this.starPosition,
    required this.scale,
  });

  /// The placement of the star's bounding box in the background.
  final FractionalOffset boundingBoxOffset;

  /// The position of the star within its bounding box.
  final Alignment starPosition;

  /// The scale of the star.
  final double scale;
}
