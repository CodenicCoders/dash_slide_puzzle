import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/assets/assets.dart';

/// {@template PuzzleTile}
///
/// Represents a [tile] of a [app.Puzzle].
///
/// {@endtemplate}
class PuzzleTile extends StatefulWidget {
  /// {@macro PuzzleTile}
  const PuzzleTile({
    required this.puzzle,
    required this.tile,
    required this.themeVariant,
    this.isInteractive = false,
    this.isReactiveToSpells = false,
    Key? key,
  }) : super(key: key);

  /// The puzzle containing the [tile].
  final app.Puzzle puzzle;

  /// The [tile] represented by this widget.
  final app.Tile tile;

  /// The Dashatar theme of this puzzle tile.
  final DashatarVariant themeVariant;

  /// If `true`, then the user can tap this tile to move it. Otherwise, if
  /// `false`, then this tile cannot be tapped.
  final bool isInteractive;

  /// If `true`, then this tile will receive a color tint respective to the
  /// active [app.Spell] from [app.WatchActiveSpellStateUseCase]. Otherwise, if
  /// `false` then this tile does not react to the active spell.
  final bool isReactiveToSpells;

  @override
  State<PuzzleTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final gameStatus =
        context.select<app.WatchGameStateUseCase, app.GameStatus?>(
      (useCase) => useCase.rightEvent?.status,
    );

    final activeSpell =
        context.select<app.WatchActiveSpellStateUseCase, app.Spell?>(
      (useCase) => useCase.rightEvent?.spell,
    );

    final isMovable =
        widget.isInteractive && gameStatus == app.GameStatus.playing;

    final Color colorTint;

    if (widget.isReactiveToSpells) {
      switch (activeSpell) {
        case app.Spell.slow:
          colorTint = Colors.green.withOpacity(0.38);
          break;
        case app.Spell.stun:
          colorTint = Colors.black38;
          break;
        case app.Spell.timeReversal:
          colorTint = Colors.red.withOpacity(0.38);
          break;
        case null:
          colorTint = Colors.transparent;
      }
    } else {
      colorTint = Colors.transparent;
    }

    return AnimatedAlign(
      alignment: FractionalOffset(
        widget.tile.currentPosition.x / (widget.puzzle.dimension - 1),
        widget.tile.currentPosition.y / (widget.puzzle.dimension - 1),
      ),
      duration: const Duration(milliseconds: 300),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MouseRegion(
            onEnter:
                isMovable ? (event) => setState(() => _scale = 0.9) : null,
            onExit: isMovable ? (event) => setState(() => _scale = 1) : null,
            child: SizedBox.square(
              dimension:
                  constraints.maxWidth / widget.puzzle.dimension * 0.95,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: _scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          DashatarAssets.tileImage(
                            widget.themeVariant,
                            widget.tile.targetPosition,
                          ),
                        ),
                      ),
                    ),
                    child: AnimatedContainer(
                      color: colorTint,
                      duration: const Duration(milliseconds: 500),
                      child: isMovable
                          ? Material(
                              color: Colors.transparent,
                              child: InkWell(onTap: _onTap),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onTap() => context.read<app.MovePlayerTileUseCase>().run(
        params: app.MovePlayerTileParams(
          tileCurrentPosition: widget.tile.currentPosition,
        ),
      );

}
