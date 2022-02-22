import 'package:domain/domain.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/a_star/a_star_helper.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/a_star/a_star_variant_a.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/a_star/a_star_variant_c.dart';

/// An A* variant for helping solve the [Tile]s located at `B` in the graph
/// below.
///
/// ```
/// {solve order}.{A* variant}
///  ┌─────0───────1───────2───────3────► x
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  0  │     │ │     │ │     │ │ 0.B │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  1  │     │ │     │ │     │ │ 2.B │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  2  │     │ │     │ │     │ │     │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
///  3  │ 1.B │ │ 3.B │ │     │ │     │
///  │  └─────┘ └─────┘ └─────┘ └─────┘
///  ▼
///  y
/// ```
///
/// Note that this is a helper variant for the [AStarVariantC] and does not
/// entirely solve tiles at `B`. Instead, this brings the `B` tiles within
/// their respective `optimizer bounds` so that they can be solved by
/// [AStarVariantC].
///
/// For more info on optimizer bounds, see [AStarHelper.createOptimizerBounds].
class AStarVariantB {
  const AStarVariantB._(); // coverage:ignore-line

  /// Returns the calculated path cost between the start [Node] and the current
  /// [puzzle] node.
  ///
  /// This is an implementation of [G].
  static int g(Node puzzle) => puzzle.depth;

  /// {@macro AStarVariantA.h}
  static double h(Node puzzle, Position targetPosition) =>
      AStarVariantA.h(puzzle, targetPosition);

  /// Returns `true` if both the [Tile] with the [targetPosition] and the
  /// whitespace [Tile] is within the respective `optimizer bounds` defined by
  /// [targetPosition].
  ///
  /// For more info on optimizer bounds, see
  /// [AStarHelper.createOptimizerBounds].
  ///
  /// An implementation of [Goal].
  static bool goal(Node puzzle, Position targetPosition) {
    final dimension = puzzle.dimension;

    final bounds = AStarHelper.createOptimizerBounds(dimension, targetPosition);

    final tile = puzzle.tileWithTargetPosition(targetPosition)!;
    final whitespaceTile = puzzle.whitespaceTile;

    return AStarHelper.isWithinBounds(tile.currentPosition, bounds) &&
        AStarHelper.isWithinBounds(whitespaceTile.currentPosition, bounds);
  }

  /// {@macro AStarVariantA.childNodes}
  static Future<List<Node>> childNodes(
    PuzzleService puzzleService,
    Node puzzle,
    Position targetPosition,
  ) =>
      AStarVariantA.childNodes(puzzleService, puzzle, targetPosition);
}
