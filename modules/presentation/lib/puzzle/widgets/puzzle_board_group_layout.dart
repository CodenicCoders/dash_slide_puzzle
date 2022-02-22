import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/constants/breakpoints.dart';
import 'package:presentation/puzzle/widgets/widgets.dart';

/// {@template PuzzleBoardGroupLayout}
///
/// A responsive widget for loading the [PuzzleBoard]s.
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

        final gameState = context.watch<app.WatchGameStateUseCase>().rightEvent;

        final theme = context.select<app.SwitchThemeUseCase, app.ThemeOption>(
          (useCase) => useCase.rightValue,
        );

        if (gameState == null) {
          return Container();
        }

        final DashatarVariant playerThemeVariant;
        final DashatarVariant botThemeVariant;

        switch (theme) {
          case app.ThemeOption.day:
            playerThemeVariant = DashatarVariant.blue1;
            botThemeVariant = DashatarVariant.blue2;
            break;
          case app.ThemeOption.prevening:
            playerThemeVariant = DashatarVariant.yellow1;
            botThemeVariant = DashatarVariant.yellow2;
            break;
          case app.ThemeOption.night:
            playerThemeVariant = DashatarVariant.indigo1;
            botThemeVariant = DashatarVariant.indigo2;
            break;
        }

        if (width <= Breakpoints.small) {
          return _BoardViewSmallLayout(
            gameState: gameState,
            playerThemeVariant: playerThemeVariant,
            botThemeVariant: botThemeVariant,
          );
        } else {
          return _BoardViewWideLayout(
            gameState: gameState,
            playerThemeVariant: playerThemeVariant,
            botThemeVariant: botThemeVariant,
          );
        }
      },
    );
  }
}

class _BoardViewSmallLayout extends StatelessWidget {
  const _BoardViewSmallLayout({
    required this.gameState,
    required this.playerThemeVariant,
    required this.botThemeVariant,
    Key? key,
  }) : super(key: key);

  final app.GameState gameState;
  final DashatarVariant playerThemeVariant;
  final DashatarVariant botThemeVariant;

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PuzzleBoard(
            puzzle: gameState.playerPuzzle,
            themeVariant: playerThemeVariant,
            isInteractive: true,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PuzzleBoard(
            puzzle: gameState.botPuzzle,
            themeVariant: botThemeVariant,
            isReactiveToSpells: true,
          ),
        )
      ],
    );
  }
}

class _BoardViewWideLayout extends StatelessWidget {
  const _BoardViewWideLayout(
      {required this.gameState,
      required this.playerThemeVariant,
      required this.botThemeVariant,
      Key? key})
      : super(key: key);

  final app.GameState gameState;
  final DashatarVariant playerThemeVariant;
  final DashatarVariant botThemeVariant;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(width: 48),
        Expanded(
          child: Center(
            child: PuzzleBoard(
              puzzle: gameState.playerPuzzle,
              themeVariant: playerThemeVariant,
              isInteractive: true,
            ),
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: Center(
            child: PuzzleBoard(
              puzzle: gameState.botPuzzle,
              themeVariant: botThemeVariant,
              isReactiveToSpells: true,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}
