import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

/// {@template PuzzleBoard}
///
/// A widget for rendering the puzzle.
///
/// {@endtemplate}
class PuzzleBoard extends StatefulWidget {
  /// {@macro PuzzleBoard}
  const PuzzleBoard({
    required this.puzzle,
    this.isInteractive = false,
    this.isReactiveToSpells = false,
    Key? key,
  }) : super(key: key);

  /// The [app.Puzzle] being rendered.
  final app.Puzzle puzzle;

  /// See [PuzzleTile.isInteractive].
  final bool isInteractive;

  /// See [PuzzleTile.isReactiveToSpells].
  final bool isReactiveToSpells;

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);

        return Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: widget.puzzle.tiles
                .map<Widget>(
                  (tile) => tile.isWhitespace
                      ? const SizedBox()
                      : PuzzleTile(
                          key: Key('puzzle_tile_${tile.targetPosition}'),
                          puzzle: widget.puzzle,
                          tile: tile,
                          isInteractive: widget.isInteractive,
                          isReactiveToSpells: widget.isReactiveToSpells,
                        ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
