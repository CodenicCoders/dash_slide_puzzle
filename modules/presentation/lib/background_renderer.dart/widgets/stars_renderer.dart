import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:presentation/background_renderer.dart/widgets/star_animator.dart';
import 'package:presentation/presentation.dart';

class StarsRenderer extends StatelessWidget {
  const StarsRenderer({
    this.starBoundSize = 40,
    this.starSize = 32,
    this.spacing = 4,
    this.starCreationProbability = 0.2,
    Key? key,
  }) : super(key: key);

  final double starBoundSize;
  final double starSize;
  final double spacing;
  final double starCreationProbability;

  @override
  Widget build(BuildContext context) {
    final theme = context.select<app.SwitchThemeUseCase, app.ThemeOption>(
      (useCase) => useCase.rightValue,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final starProps = _generateStarProps(constraints);

        final double starOpacity;

        switch (theme) {
          case app.ThemeOption.day:
            starOpacity = 0.25;
            break;
          case app.ThemeOption.night:
            starOpacity = 0.5;
            break;
          case app.ThemeOption.prevening:
            starOpacity = 0.75;
            break;
        }

        return Stack(
          children: [
            for (var i = 0; i < starProps.length; i++)
              AnimatedAlign(
                key: ValueKey(i),
                alignment: starProps[i].backgroundAlignment,
                duration: const Duration(milliseconds: 500),
                child: SizedBox.square(
                  dimension: starBoundSize,
                  child: Align(
                    alignment: starProps[i].boundingBoxOffset,
                    child: StarAnimator(
                      size: starSize * starProps[i].scale,
                      opacity: starOpacity,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<StarProps> _generateStarProps(BoxConstraints screenConstraints) {
    final boundingWidth = screenConstraints.maxWidth;
    final boundingHeight = screenConstraints.maxHeight;

    final starBoundingBoxWithMargin = starBoundSize + spacing * 2;

    final maxStarsPerRow = boundingWidth ~/ starBoundingBoxWithMargin;
    final maxStarsPerColumn = boundingHeight ~/ starBoundingBoxWithMargin;

    final starProps = <StarProps>[];

    final random = Random();

    for (var y = 0; y <= maxStarsPerColumn; y++) {
      for (var x = 0; x <= maxStarsPerRow; x++) {
        final starCreationValue = random.nextDouble();

        if (starCreationValue > starCreationProbability) {
          continue;
        }

        final offset =
            FractionalOffset(x / maxStarsPerRow, y / maxStarsPerColumn);

        final alignment = _randomizeAlignment();

        final scale = random.nextDouble();

        final props = StarProps(
          backgroundAlignment: offset,
          boundingBoxOffset: alignment,
          scale: scale,
        );
        starProps.add(props);
      }
    }

    return starProps;
  }
}

Alignment _randomizeAlignment() {
  final rnd = Random();

  final dx = rnd.nextInt(13) / 12;
  final dy = rnd.nextInt(13) / 12;

  return FractionalOffset(dx, dy);
}

class StarProps {
  const StarProps({
    required this.backgroundAlignment,
    required this.boundingBoxOffset,
    required this.scale,
  });

  /// The placement of the star in the background.
  final FractionalOffset backgroundAlignment;

  /// The position of the star within its bounding box.
  final Alignment boundingBoxOffset;

  /// The scale of the star.
  final double scale;
}
