import 'dart:math';

import 'package:collection/collection.dart';
import 'package:domain/entities/position.dart';
import 'package:domain/entities/tile.dart';
import 'package:equatable/equatable.dart';

/// {@template Puzzle}
///
/// Represents a slider puzzle containing a list of [Tile]s.
///
/// {@endtemplate}
class Puzzle with EquatableMixin {
  /// {@macro Puzzle}
  Puzzle({required List<Tile> tiles, this.previousPuzzle})
      : assert(
          tiles.where((tile) => tile.isWhitespace).length == 1,
          'Must have one whitespace tile',
        ),
        assert(
          sqrt(tiles.length) - sqrt(tiles.length).floor() == 0,
          'Puzzle must have a square dimension',
        ),
        tiles = UnmodifiableListView(
          tiles.toList()
            ..sort(
              (tileA, tileB) =>
                  tileA.targetPosition.compareTo(tileB.targetPosition),
            ),
        );

  /// Returns a 4x4 completed puzzle.
  factory Puzzle.defaults() {
    const dimension = 4;

    final tiles = <Tile>[
      for (var y = 0; y < dimension; y++)
        for (var x = 0; x < dimension; x++)
          Tile(
            currentPosition: Position(x: x, y: y),
            targetPosition: Position(x: x, y: y),
            isWhitespace: x == dimension - 1 && x == y,
          )
    ];

    return Puzzle(tiles: tiles);
  }

  /// List of [Tile]s of this puzzle sorted by target [Position].
  final UnmodifiableListView<Tile> tiles;

  /// The previous state of this [Puzzle].
  final Puzzle? previousPuzzle;

  /// A data holder for [history] to optimize performance.
  UnmodifiableListView<Puzzle>? _history;

  /// Returns all the previous states of this [Puzzle] in a list sorted
  /// ascendingly.
  UnmodifiableListView<Puzzle> get history => _history ??= UnmodifiableListView(
        previousPuzzle == null
            ? [this]
            : _generatePuzzleHistory(previousPuzzle!, [this]),
      );

  List<Puzzle> _generatePuzzleHistory(
    Puzzle puzzle,
    List<Puzzle> puzzles,
  ) {
    puzzles.insert(0, puzzle);

    return puzzle.previousPuzzle != null
        ? _generatePuzzleHistory(puzzle.previousPuzzle!, puzzles)
        : puzzles;
  }

  /// Returns the depth of the puzzle history.
  int get depth => history.length;

  /// Returns the whitespace [Tile] from [tiles].
  Tile get whitespaceTile => tiles.firstWhere((tile) => tile.isWhitespace);

  /// Get the dimension of a puzzle given its tile arrangement.
  ///
  /// Ex: A 4x4 puzzle has a dimension of 4.
  int get dimension => sqrt(tiles.length).toInt();

  /// Returns `true` if the puzzle is complete. Otherwise, `false` is returned.
  bool get isCompleted {
    for (final tile in tiles) {
      if (tile.currentPosition != tile.targetPosition) {
        return false;
      }
    }

    return true;
  }

  /// Returns the number of completed tiles.
  ///
  /// See [Tile.isCompleted].
  int get completedTilesCount => tiles.fold(
        0,
        (previousCount, tile) => previousCount + (tile.isCompleted ? 1 : 0),
      );

  /// Returns the number of incomplete tiles.
  ///
  /// See [Tile.isCompleted].
  int get incompleteTilesCount => tiles.fold(
        0,
        (previousCount, tile) => previousCount + (tile.isCompleted ? 0 : 1),
      );

  /// Returns the [Tile] with the given [currentPosition].
  Tile? tileWithCurrentPosition(Position currentPosition) => tiles
      .singleWhereOrNull((tile) => tile.currentPosition == currentPosition);

  /// Returns the [Tile] with the given [targetPosition].
  Tile? tileWithTargetPosition(Position targetPosition) =>
      tiles.singleWhereOrNull((tile) => tile.targetPosition == targetPosition);

  /// Returns the [Tile] relative to the [whitespaceTile]'s current [Position]
  /// with the given [offset].
  Tile? tileRelativeToWhitespaceTile(Position offset) {
    final position = whitespaceTile.currentPosition.move(offset);
    return tileWithCurrentPosition(position);
  }

  /// Returns `true` if both this and the [other] puzzle [Tile]s are equal
  /// regardless of their history. Otherwise, `false` is returned.
  ///
  /// This is different from the `==` operator in way that [previousPuzzle] is
  /// ignored.
  bool isTilesEqual(Puzzle other) =>
      const ListEquality<Tile>().equals(tiles, other.tiles);

  Puzzle copyWith({
    UnmodifiableListView<Tile>? tiles,
    Puzzle? previousPuzzle,
  }) {
    return Puzzle(
      tiles: tiles ?? this.tiles,
      previousPuzzle: previousPuzzle ?? this.previousPuzzle,
    );
  }

  @override
  List<Object?> get props => [tiles, previousPuzzle];
}
