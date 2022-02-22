import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart' show compute, kIsWeb;
import 'package:infrastructure/services/puzzle_service/puzzle_solver/a_star/a_star.dart';

/// {@template PuzzleSolverParams}
///
/// The parameter for [PuzzleSolver].
///
/// {@endtemplate}
class PuzzleSolverParams {
  /// {@macro PuzzleSolverParams}
  const PuzzleSolverParams({required this.puzzleService, required this.puzzle});

  /// An instance of [puzzleService] for managing the [puzzle].
  final PuzzleService puzzleService;

  /// The [Puzzle] to solve.
  final Puzzle puzzle;
}

/// A class for solving a sliding [Puzzle] with `n+1` dimension via a recursive
/// search with different variants of the A* search algorithm.
///
/// References used to create this puzzle solver:
/// - https://www.kopf.com.br/kaplof/how-to-solve-any-slide-puzzle-regardless-of-its-size/
/// - https://cs.stanford.edu/people/eroberts/courses/soco/projects/2003-04/intelligent-search/astar.html#:~:text=ALGORITHMS%20%2D%20A*,search%20and%20greedy%20search%20algorithms.
abstract class PuzzleSolver {
  const PuzzleSolver._(); // coverage:ignore-line

  /// Accepts an incomplete [Puzzle] with `n+1` dimension then returns a new
  /// solved [Puzzle] containing all its previous states leading to its
  /// completion.
  ///
  /// The tiles are solved one by one in the following order:
  ///
  ///  ```
  /// {solve order}.{A* variant}
  ///  ┌─────0───────1───────2───────3────► x
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  0  │ 0.A │ │ 1.A │ │2.A  │ │3.BC │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  1  │ 4.A │ │ 7.A │ │8.A  │ │9.BC │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  2  │5.A  │ │10.C │ │11.C │ │11.C │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
  ///  3  │6.BC │ │10.C │ │12.A │ │     │
  ///  │  └─────┘ └─────┘ └─────┘ └─────┘
  ///  ▼
  ///  y
  ///  ```
  ///
  /// For a printed demo of the search results, visit
  /// `test/puzzle_service_impl_test.dart` then run test group `demo`.
  ///
  /// NOTE:
  /// On Dart Native platforms, this is executed on an `Isolate` to prevent the
  /// main thread from freezing. Unfortunately, Dart web apps do not support
  /// this feature as of February 10, 2022. As a workaround, the algorithm
  /// `yields` every 10th node processed in the search tree to reduce the
  /// jank in the main thread.
  static Future<Puzzle> solve(PuzzleSolverParams params) async {
    final solvedPuzzle = await compute<PuzzleSolverParams, Puzzle>(
      PuzzleSolver._isolateSolve,
      params,
    );

    return solvedPuzzle;
  }

  static Future<Puzzle> _isolateSolve(PuzzleSolverParams params) async {
    final isSolvableResult =
        await params.puzzleService.isPuzzleSolvable(puzzle: params.puzzle);

    final isSolvable = isSolvableResult.getRight();

    if (!isSolvable) {
      throw ArgumentError('Puzzle argument not solvable');
    }

    final puzzle = params.puzzle;
    final dimension = puzzle.dimension;

    var currentPuzzle = puzzle;

    for (var i = 0; i < dimension - 1; i++) {
      for (var x = i; x < dimension; x++) {
        final targetPosition = Position(x: x, y: i);

        final isAtLastFourBottomRightTiles =
            targetPosition.x == dimension - 2 &&
                targetPosition.y == dimension - 2;

        final isAtRightEdge = x == dimension - 1;

        if (isAtLastFourBottomRightTiles) {
          // For `11.C` of graph

          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition.move(const Position(x: 1, y: 0)),
            AStarVariantC,
          );

          break;
        } else if (isAtRightEdge) {
          // For `3.BC` and `9.BC` of graph

          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition,
            AStarVariantB,
          );

          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition,
            AStarVariantC,
          );
        } else {
          // For `0.A`, `1.A`, `2.A`, `7.A` and `8.A` of graph
          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition,
            AStarVariantA,
          );
        }
      }

      for (var y = i + 1; y < dimension; y++) {
        final targetPosition = Position(x: i, y: y);

        final isAtLastSixBottomRightTiles = targetPosition.x == dimension - 3 &&
            targetPosition.y == dimension - 2;

        final isAtBottomEdge = y == dimension - 1;

        if (isAtLastSixBottomRightTiles) {
          // For `10.C` of graph

          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition.move(const Position(x: 0, y: 1)),
            AStarVariantC,
          );

          break;
        } else if (isAtBottomEdge) {
          // For `6.BC` of graph

          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition,
            AStarVariantB,
          );

          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition,
            AStarVariantC,
          );
        } else {
          // For `4.A` and 5.A` of graph
          currentPuzzle = await _solveTile(
            params.puzzleService,
            currentPuzzle,
            targetPosition,
            AStarVariantA,
          );
        }
      }
    }

    // For `12.A` of graph

    final targetPosition = Position(x: dimension - 2, y: dimension - 1);

    return _solveTile(
      params.puzzleService,
      currentPuzzle,
      targetPosition,
      AStarVariantA,
    );
  }

  /// Returns a [Puzzle] with the completed [Tile] at the given
  /// [targetPosition] and new previous states taken to complete it.
  ///
  /// The [aStarVariant] signifies which A* algorithm will be used to solve the
  /// tile.
  static Future<Puzzle> _solveTile(
    PuzzleService puzzleService,
    Puzzle startPuzzle,
    Position targetPosition,
    Type aStarVariant,
  ) async {
    // Determine the A* variant that will be used

    final H h;
    final G g;
    final Goal goal;
    final ChildNodes childNodes;

    switch (aStarVariant) {
      case AStarVariantA:
        h = AStarVariantA.h;
        g = AStarVariantA.g;
        childNodes = AStarVariantA.childNodes;
        goal = AStarVariantA.goal;
        break;
      case AStarVariantB:
        h = AStarVariantB.h;
        g = AStarVariantB.g;
        childNodes = AStarVariantB.childNodes;
        goal = AStarVariantB.goal;
        break;
      case AStarVariantC:
        h = AStarVariantC.h;
        g = AStarVariantC.g;
        childNodes = AStarVariantC.childNodes;
        goal = AStarVariantC.goal;
        break;
      default:
        throw UnsupportedError('A* variant not supported');
    }

    // Contain all the nodes that have not been explored yet
    final openNodes = <Node>[];

    // Contains all the nodes that have been explored. This prevents us from
    // adding an already traversed node in `openNodes`

    final closedNodes = <Node>[];

    // Create the first node and put the first node in the `openNodes`

    final firstNode = startPuzzle;

    // Before starting the search, check whether the `firstNode` has
    // accomplished the goal

    if (goal(firstNode, targetPosition)) {
      return startPuzzle;
    }

    openNodes.add(firstNode);

    var i = 0;

    do {
      // Find the open node with the lowest F value

      final currentNode = openNodes.reduce(
        (oldNode, newNode) {
          final f1 = h(oldNode, targetPosition) + g(oldNode);
          final f2 = h(newNode, targetPosition) + g(newNode);

          return f1 < f2 ? oldNode : newNode;
        },
      );

      // Generate the child nodes of the current node

      for (final childNode
          in await childNodes(puzzleService, currentNode, targetPosition)) {
        // WORKAROUND:
        // If the app is running on the web, then limit the number of node
        // processing to `5` before yielding to prevent main thread freezing
        // due to lack of Isolate support
        if (kIsWeb) {
          if (i % 5 == 0) {
            await Future<void>.delayed(Duration.zero);
          }

          i++;
        }

        // If the child node has reached the goal, then return its puzzle path

        if (goal(childNode, targetPosition)) {
          return childNode;
        }

        // If the child node is in the closed node, then ignore

        final closedNodeMatchIndex =
            closedNodes.indexWhere(childNode.isTilesEqual);

        if (closedNodeMatchIndex != -1) {
          continue;
        }

        // If the child node is in the open node, then persist the node with
        // the lowest g value. Otherwise, add it to the open node

        final openNodeMatchIndex = openNodes.indexWhere(childNode.isTilesEqual);

        if (openNodeMatchIndex != -1) {
          final openNodeMatch = openNodes[openNodeMatchIndex];

          if (g(childNode) < g(openNodeMatch)) {
            openNodes[openNodeMatchIndex] = childNode;
          }
        } else {
          openNodes.add(childNode);
        }
      }

      // Mark the current node as a closed node

      closedNodes.add(currentNode);
      openNodes.remove(currentNode);
    } while (openNodes.isNotEmpty);

    throw StateError('No tile completion path found');
  }
}
