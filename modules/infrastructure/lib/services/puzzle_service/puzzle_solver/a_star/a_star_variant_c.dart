import 'package:domain/domain.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/a_star/a_star_helper.dart';

/// An A* variant for solving two tiles (trailing and leading) at the right and
/// bottom edges.
///
///  ```
///  {solve order}.{A* variant}.{trailing or leading}
/// t = trailing
/// l = leading
///  ┌─────0───────1───────2───────3────► x
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  0  │     │ │     │ │0.C.t│ │0.C.l│
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  1  │     │ │     │ │2.C.t│ │2.C.l│
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  2  │1.C.t│ │3.C.t│ │4.C.t│ │4.C.l│
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  3  │1.C.l│ │3.C.l│ │     │ │     │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  ▼
///  y
///  ```
class AStarVariantC {
  const AStarVariantC._(); // coverage:ignore-line

  /// Returns the calculated path cost between the start [Node] and the current
  /// [node].
  ///
  /// This is an implementation of [G].
  static int g(Node node) => node.depth;

  /// A heuristic function that calculates the estimated path of cost between
  /// the [puzzle] node and the goal [Node].
  ///
  /// This heuristic favors:
  ///
  /// - A smaller distance between the leading [Tile]'s target position.
  /// - A smaller distance between the target [Tile]'s target position.
  ///
  /// {@macro targetPosition}
  ///
  /// This is an implementation of [H].
  static double h(Node puzzle, Position targetPosition) {
    final isAtRightEdge = targetPosition.x >= targetPosition.y;

    final tileBTargetPosition = targetPosition.move(
      isAtRightEdge ? const Position(x: -1, y: 0) : const Position(x: 0, y: -1),
    );

    final tileA = puzzle.tileWithTargetPosition(targetPosition)!;
    final tileB = puzzle.tileWithTargetPosition(tileBTargetPosition)!;

    final weights = <num>[
      tileA.distanceToTargetPosition * 1.0,
      tileB.distanceToTargetPosition * 1.0,
    ];

    final h = weights.reduce((value, element) => value + element).toDouble();

    return h;
  }

  /// Returns `true` if the leading [Tile] at [targetPosition] and its trailing
  /// tile is in their respective target position. Otherwise, `false` is
  /// returned.
  ///
  /// This is an implementation of [Goal].
  static bool goal(Node puzzle, Position targetPosition) {
    final isAtRightEdge = targetPosition.x >= targetPosition.y;

    final leadingTileTargetPosition = targetPosition;

    final trailingTileTargetPosition = targetPosition.move(
      isAtRightEdge ? const Position(x: -1, y: 0) : const Position(x: 0, y: -1),
    );

    final leadingTile =
        puzzle.tileWithTargetPosition(leadingTileTargetPosition)!;
    final trailingTile =
        puzzle.tileWithTargetPosition(trailingTileTargetPosition)!;

    return leadingTile.isCompleted && trailingTile.isCompleted;
  }

  /// Generates child [Node]s for the given [puzzle].
  ///
  /// Generated child nodes contain next puzzle states that are within the
  /// `optimizer bounds`.
  ///
  /// For more info on optimizer bounds, see
  /// [AStarHelper.createOptimizerBounds].
  ///
  /// {@macro targetPosition}
  ///
  /// This is an implementation of [childNodes].
  static Future<List<Node>> childNodes(
    PuzzleService puzzleService,
    Node puzzle,
    Position targetPosition,
  ) =>
      AStarHelper.generateChildNodes(
        puzzleService,
        puzzle,
        (tile) => _movableTileValidator(
          puzzle.dimension,
          targetPosition,
          tile,
        ),
      );

  /// A validator that prevents [Tile]s outside the `optimizer bounds` from
  /// being moved.
  ///
  /// If the [tile] is within the optimizer bounds, then `true` will be
  /// returned. Otherwise, this returns `false`.
  ///
  /// For more info on optimizer bounds, see
  /// [AStarHelper.createOptimizerBounds].
  ///
  /// {@macro targetPosition}
  static bool _movableTileValidator(
    int dimension,
    Position targetPosition,
    Tile tile,
  ) {
    final bounds = AStarHelper.createOptimizerBounds(dimension, targetPosition);
    return AStarHelper.isWithinBounds(tile.currentPosition, bounds);
  }
}
