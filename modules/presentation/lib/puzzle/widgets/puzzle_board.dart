import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/puzzle/widgets/widgets.dart';

/// {@template PuzzleBoard}
///
/// A widget for rendering the puzzle.
///
/// {@endtemplate}
class PuzzleBoard extends StatelessWidget {
  /// {@macro PuzzleBoard}
  const PuzzleBoard({
    required this.puzzle,
    required this.themeVariant,
    this.isInteractive = false,
    this.isReactiveToSpells = false,
    Key? key,
  }) : super(key: key);

  /// The [app.Puzzle] being rendered.
  final app.Puzzle puzzle;

  /// The Dashatar theme of this puzzle.
  final DashatarVariant themeVariant;

  /// See [PuzzleTile.isInteractive].
  final bool isInteractive;

  /// See [PuzzleTile.isReactiveToSpells].
  final bool isReactiveToSpells;

  @override
  Widget build(BuildContext context) {
    final theme = context.select<app.SwitchThemeUseCase, app.ThemeOption>(
      (useCase) => useCase.rightValue,
    );

    final maxSize = theme is app.Running ? 0.0 : 432.0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Container(
        key: ValueKey(theme),
        constraints: BoxConstraints(maxHeight: maxSize, maxWidth: maxSize),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox.square(
              dimension: min(constraints.maxWidth, constraints.maxHeight),
              child: Stack(
                children: puzzle.tiles
                    .map<Widget>(
                      (tile) => tile.isWhitespace
                          ? const SizedBox()
                          : PuzzleTile(
                              key: Key('puzzle_tile_${tile.targetPosition}'),
                              puzzle: puzzle,
                              tile: tile,
                              themeVariant: themeVariant,
                              isInteractive: isInteractive,
                              isReactiveToSpells: isReactiveToSpells,
                            ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );

    return AnimatedContainer(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(8),
      ),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 350),
      constraints: BoxConstraints(maxHeight: maxSize, maxWidth: maxSize),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox.square(
            dimension: min(constraints.maxWidth, constraints.maxHeight),
            child: Stack(
              children: puzzle.tiles
                  .map<Widget>(
                    (tile) => tile.isWhitespace
                        ? const SizedBox()
                        : PuzzleTile(
                            key: Key('puzzle_tile_${tile.targetPosition}'),
                            puzzle: puzzle,
                            tile: tile,
                            themeVariant: themeVariant,
                            isInteractive: isInteractive,
                            isReactiveToSpells: isReactiveToSpells,
                          ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
