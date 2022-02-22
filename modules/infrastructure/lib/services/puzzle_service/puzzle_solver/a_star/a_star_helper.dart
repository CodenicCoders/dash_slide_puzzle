import 'dart:math';

import 'package:domain/domain.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/models/models.dart';

/// Represents the node of an A* search algorithm.
typedef Node = Puzzle;

/// A function signature for calculating the distance between start [Node]
/// and the given [node].
typedef G = int Function(Node node);

/// A function signature for heuristic approximation of the distance between
/// the given [node] and the goal [Node].
///
/// {@template targetPosition}
///
/// The [targetPosition] represents the [Tile] being solved.
///
/// {@endtemplate}
typedef H = double Function(Node node, Position targetPosition);

/// A function signature for generating child [Node]s for the given [node].
///
/// {@macro targetPosition}
typedef ChildNodes = Future<List<Node>> Function(
  PuzzleService puzzleService,
  Node node,
  Position targetPosition,
);

/// A function signature representing the goal of an A* search algorithm.
///
/// {@macro targetPosition}
typedef Goal = bool Function(Node node, Position targetPosition);

/// A suite of helper functions for the A* variant classes.
class AStarHelper {
  const AStarHelper._(); // coverage:ignore-line

  /// Generates child [Node]s for the given [node].
  ///
  /// Child nodes are determined based on the movable [Tile]s of the [node]
  /// that have passed the [movableTileValidator].
  static Future<List<Node>> generateChildNodes(
    PuzzleService puzzleService,
    Node node,
    bool Function(Tile tile) movableTileValidator,
  ) async {
    final movableTiles = _fetchMovableTiles(node, movableTileValidator);

    final moveTileResults = await Future.wait<Either<Failure, Puzzle>>([
      for (final tile in movableTiles)
        puzzleService.moveTile(
          puzzle: node,
          tileCurrentPosition: tile.currentPosition,
        ),
    ]);

    final childNodes = moveTileResults
        .map((moveTileResult) => moveTileResult.getRight())
        .toList();

    // Create the child nodes

    return childNodes;
  }

  /// Fetches all [Tile]s adjacent to the whitespace [Tile] of the [puzzle] and
  /// have passed the [movableTileValidator].
  ///
  /// If the [movableTileValidator] returns `true` for a given [Tile], then it
  /// is retained. Otherwise, it will be removed.
  static List<Tile> _fetchMovableTiles(
    Puzzle puzzle,
    bool Function(Tile tile) movableTileValidator,
  ) {
    final dimension = puzzle.dimension;

    final whitespaceTile = puzzle.whitespaceTile;

    final movableTiles = <Tile>[
      if (whitespaceTile.currentPosition.x > 0)
        puzzle.tileWithCurrentPosition(
          Position(
            x: whitespaceTile.currentPosition.x - 1,
            y: whitespaceTile.currentPosition.y,
          ),
        )!,
      if (whitespaceTile.currentPosition.x < dimension - 1)
        puzzle.tileWithCurrentPosition(
          Position(
            x: whitespaceTile.currentPosition.x + 1,
            y: whitespaceTile.currentPosition.y,
          ),
        )!,
      if (whitespaceTile.currentPosition.y > 0)
        puzzle.tileWithCurrentPosition(
          Position(
            x: whitespaceTile.currentPosition.x,
            y: whitespaceTile.currentPosition.y - 1,
          ),
        )!,
      if (whitespaceTile.currentPosition.y < dimension - 1)
        puzzle.tileWithCurrentPosition(
          Position(
            x: whitespaceTile.currentPosition.x,
            y: whitespaceTile.currentPosition.y + 1,
          ),
        )!,
    ]..retainWhere(movableTileValidator);

    return movableTiles;
  }

  /// Checks whether the [position] is within the given [boundary].
  static bool isWithinBounds(Position position, Boundary boundary) {
    assert(
      position.x >= 0 && position.y >= 0,
      'Position must have a positive x and y values',
    );

    final lesserBound = boundary.lesserBound;
    final higherBound = boundary.higherBound;

    return position.x >= lesserBound.x &&
        position.y >= lesserBound.y &&
        position.x <= higherBound.x &&
        position.y <= higherBound.y;
  }

  /// Creates a 2x3 or 3x2 rectangle bounds around the [targetPosition] for
  /// constraining the path search within a certain area.
  ///
  /// A 2x3 rectangle bounds is created if the [targetPosition] aligns more to
  /// the right. On the other hand, a 3x2 bounds is created if it aligns more
  /// to the bottom.
  ///
  /// If the rectangle bounds exceed the given [dimension], then it will be
  /// truncated.
  ///
  /// An [AssertionError] will be thrown if the [targetPosition] is not
  /// exclusively at the right or bottom edge of the given [dimension].
  ///
  /// ```
  /// e.g. 2x3 bounds around target position (3, 0)
  ///
  ///  ┌─────0───────1───────2───────3────► x
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  0  │     │ │     │ │  o  │ │  +  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  1  │     │ │     │ │  o  │ │  o  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  2  │     │ │     │ │  o  │ │  o  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  3  │     │ │     │ │     │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  ▼
  ///  y
  ///
  /// e.g. 3x2 bounds around target position (1, 3)
  ///
  ///  ┌─────0───────1───────2───────3────► x
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  0  │     │ │     │ │     │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  1  │     │ │     │ │     │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  2  │     │ │  o  │ │  o  │ │  o  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  3  │     │ │  +  │ │  o  │ │  o  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  ▼
  ///  y
  ///
  /// e.g. 2x2 `truncated` bounds around target position (1, 3)
  ///
  ///  ┌─────0───────1───────2───────3────► x
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  0  │     │ │     │ │     │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  1  │     │ │     │ │     │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  2  │     │ │     │ │  o  │ │  x  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  3  │     │ │     │ │  o  │ │  o  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  ▼
  ///  y
  ///  ```
  static Boundary createOptimizerBounds(
    int dimension,
    Position targetPosition,
  ) {
    final isAtRightEdge = targetPosition.x >= targetPosition.y;

    if (isAtRightEdge) {
      assert(
        dimension - targetPosition.x == 1,
        'Target position must be at the right edge',
      );

      assert(
        dimension - targetPosition.y != 1,
        'Target position must not be at the bottom edge',
      );
    } else {
      assert(
        dimension - targetPosition.y == 1,
        'Target position must be at the bottom edge',
      );

      assert(
        dimension - targetPosition.x != 1,
        'Target position must not be at the right edge',
      );
    }

    final leadingTileTargetPosition = targetPosition;
    final trailingTileTargetPosition = targetPosition.move(
      isAtRightEdge ? const Position(x: -1, y: 0) : const Position(x: 0, y: -1),
    );

    final lesserBound = trailingTileTargetPosition;
    final higherBound = isAtRightEdge
        ? Position(
            x: leadingTileTargetPosition.x,
            y: min(leadingTileTargetPosition.y + 2, dimension - 1),
          )
        : Position(
            x: min(leadingTileTargetPosition.x + 2, dimension - 1),
            y: leadingTileTargetPosition.y,
          );

    return Boundary(lesserBound: lesserBound, higherBound: higherBound);
  }
}
