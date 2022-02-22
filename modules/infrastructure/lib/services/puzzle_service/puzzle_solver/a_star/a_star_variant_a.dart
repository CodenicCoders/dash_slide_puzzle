import 'dart:math';

import 'package:domain/domain.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/a_star/a_star_helper.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/models/models.dart';

/// An A* variant for solving the tiles `A` in the graph below one by one.
///
/// ```
/// {solve order}.{A* variant}
///  ┌─────0───────1───────2───────3────► x
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  0  │ 0.A │ │ 1.A │ │ 2.A │ │     │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  1  │ 3.A │ │ 5.A │ │ 6.A │ │     │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  2  │ 4.A │ │     │ │     │ │     │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  3  │     │ │     │ │ 7.A │ │     │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  ▼
///  y
/// ```
class AStarVariantA {
  const AStarVariantA._(); // coverage:ignore-line

  /// Returns the calculated path cost between the start [Node] and the current
  /// [puzzle] node.
  ///
  /// This is an implementation of [G].
  static int g(Node puzzle) => puzzle.depth;

  /// {@template AStarVariantA.h}
  ///
  /// A heuristic function that calculates the estimated path of cost between
  /// the [puzzle] node and the goal [Node].
  ///
  /// This heuristic favors:
  ///
  /// - A smaller distance between the whitespace tile and the target tile.
  /// - A smaller distance between the target tile's current and target
  /// position.
  ///
  /// This is an implementation of [H].
  ///
  /// {@endtemplate}
  static double h(Node puzzle, Position targetPosition) {
    final tile = puzzle.tileWithTargetPosition(targetPosition)!;
    final whitespaceTile = puzzle.whitespaceTile;

    final distanceToWhitespaceTile =
        whitespaceTile.currentPosition.distance(tile.currentPosition);

    final dimension = puzzle.dimension;

    final weights = [
      distanceToWhitespaceTile * dimension * 2.0,
      tile.distanceToTargetPosition * dimension * 1.0,
    ];

    final h = weights.reduce((value, element) => value + element);

    return h;
  }

  /// Returns `true` if the [Tile] of [puzzle] node with the [targetPosition]
  /// has reached its target position.
  ///
  /// This is an implementation of [Goal].
  static bool goal(Node puzzle, Position targetPosition) {
    final tile = puzzle.tileWithTargetPosition(targetPosition)!;
    return tile.distanceToTargetPosition == 0;
  }

  /// {@template AStarVariantA.childNodes}
  ///
  /// Generates child [Node]s for the given [puzzle] node.
  ///
  /// Generated child nodes contain next puzzle states that have not changed
  /// any tiles that have been marked as completed.
  ///
  /// ```
  /// e.g. Target position at (2, 1)
  /// - The number indicates the completed tiles in order which cannot be
  /// candidate for movable tiles
  /// - t.pos indicates the target tile currently being solved
  /// - Movable tiles would be Tile(2, 2) and Tile(1, 3), both adjacent to the
  /// whitespace tile `w`.
  ///  ┌─────0───────1───────2───────3────► x
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  0  │  0  │ │  1  │ │  2  │ │  3  │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  1  │  4  │ │  7  │ │t.pos│ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  2  │  5  │ │  w  │ │     │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  3  │  6  │ │     │ │     │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  ▼
  ///  y
  ///  ```
  ///
  /// {@macro targetPosition}
  ///
  /// This is an implementation of [childNodes].
  /// {@endtemplate}
  static Future<List<Node>> childNodes(
    PuzzleService puzzleService,
    Node puzzle,
    Position targetPosition,
  ) async =>
      AStarHelper.generateChildNodes(
        puzzleService,
        puzzle,
        (tile) => _movableTileValidator(puzzle.dimension, targetPosition, tile),
      );

  /// A validator that prevents a completed [Tile] from being moved.
  ///
  /// If the [tile] is a completed tile, then this will return `false` and will
  /// be marked for removal. Otherwise, `true` will be returned.
  ///
  /// {@macro targetPosition}
  ///
  /// For more info about completed tiles, see [childNodes].
  static bool _movableTileValidator(
    int dimension,
    Position targetPosition,
    Tile tile,
  ) {
    final movableTileCurrentPosition = tile.currentPosition;

    final isTargetTileRightAligned = targetPosition.x >= targetPosition.y;

    if (isTargetTileRightAligned) {
      // Remove tiles that are currently in the x-marked positions
      // - if target position right-aligned
      //  ┌─────0───────1───────2───────3────► x
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  0  │     │ │     │ │     │ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  1  │  x  │ │  x  │ │t.pos│ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  2  │     │ │     │ │     │ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  3  │     │ │     │ │     │ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  ▼
      //  y
      if (movableTileCurrentPosition.x < targetPosition.x &&
          movableTileCurrentPosition.y == targetPosition.y) {
        return false;
      }
    } else {
      // Remove tiles that are currently in the x-marked positions
      // - if target position bottom-aligned
      //  ┌─────0───────1───────2───────3────► x
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  0  │     │ │  x  │ │     │ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  1  │     │ │  x  │ │     │ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  2  │     │ │t.pos│ │     │ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
      //  3  │     │ │     │ │     │ │     │
      //  │  └─────┘ └─────┘ └─────┘ └─────┘
      //  ▼
      //  y
      if (movableTileCurrentPosition.y < targetPosition.y &&
          movableTileCurrentPosition.x == targetPosition.x) {
        return false;
      }
    }

    // Remove tiles that are outside the given square bounds:
    // - if target position is right-aligned
    //  ┌─────0───────1───────2───────3────► x
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  0  │  x  │ │  x  │ │  x  │ │  x  │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  1  │  x  │ │     │ │t.pos│ │     │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  2  │  x  │ │     │ │     │ │     │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  3  │  x  │ │     │ │     │ │     │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  ▼
    //  y
    //
    // - if target position bottom-aligned
    //  ┌─────0───────1───────2───────3────► x
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  0  │  x  │ │  x  │ │  x  │ │  x  │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  1  │  x  │ │  x  │ │  x  │ │  x  │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  2  │  x  │ │t.pos│ │     │ │     │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
    //  3  │  x  │ │     │ │     │ │     │
    //  │  └─────┘ └─────┘ └─────┘ └─────┘
    //  ▼
    //  y

    return AStarHelper.isWithinBounds(
      movableTileCurrentPosition,
      Boundary(
        lesserBound: Position(
          x: min(targetPosition.x, targetPosition.y),
          y: min(
            targetPosition.x + (isTargetTileRightAligned ? 0 : 1),
            targetPosition.y,
          ),
        ),
        higherBound: Position(x: dimension - 1, y: dimension - 1),
      ),
    );
  }
}
