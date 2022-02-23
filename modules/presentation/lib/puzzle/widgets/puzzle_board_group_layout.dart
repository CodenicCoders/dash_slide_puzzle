import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/constants/breakpoints.dart';
import 'package:presentation/puzzle/widgets/widgets.dart';

/// {@template PuzzleBoardGroupLayout}
///
/// A responsive widget for rendering the [PuzzleBoard]s of the player and the
/// bot.
///
/// {@endtemplate}
class PuzzleBoardGroupLayout extends StatelessWidget {
  /// {@macro PuzzleBoardGroupLayout}
  const PuzzleBoardGroupLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width <= Breakpoints.small) {
          return const _BoardViewSmallLayout();
        } else {
          return const _BoardViewWideLayout();
        }
      },
    );
  }
}

class _BoardViewSmallLayout extends StatelessWidget {
  const _BoardViewSmallLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _PlayerPuzzleBoard(),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _BotPuzzleBoard(),
        )
      ],
    );
  }
}

class _BoardViewWideLayout extends StatelessWidget {
  const _BoardViewWideLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        SizedBox(width: 48),
        Expanded(child: Center(child: _PlayerPuzzleBoard())),
        SizedBox(width: 48),
        Expanded(child: Center(child: _BotPuzzleBoard())),
        SizedBox(width: 48),
      ],
    );
  }
}

class _PlayerPuzzleBoard extends StatelessWidget {
  const _PlayerPuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzle = context.select<app.WatchGameStateUseCase, app.Puzzle>(
      (useCase) => useCase.rightEvent.playerPuzzle,
    );

    return PuzzleBoard(puzzle: puzzle, isInteractive: true);
  }
}

class _BotPuzzleBoard extends StatelessWidget {
  const _BotPuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzle = context.select<app.WatchGameStateUseCase, app.Puzzle>(
      (useCase) => useCase.rightEvent.botPuzzle,
    );

    return PuzzleBoard(puzzle: puzzle, isReactiveToSpells: true);
  }
}
