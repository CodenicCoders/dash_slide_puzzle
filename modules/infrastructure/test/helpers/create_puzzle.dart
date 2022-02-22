import 'package:domain/domain.dart';

/// Creates a [Puzzle] with the given [dimension].
///
/// The created puzzle will be in its completed state if not changed.
///
/// If [whitespaceTileCurrentPosition] is not `null`, then the whitespace
/// [Tile] will be swapped with the respective tile which may create an
/// unsolvable tile.
///
/// A 3x3 puzzle visualization:
///
/// ```
///  ┌─────0───────1───────2────► x
///  │  ┌─────┐ ┌─────┐ ┌─────┐
///  0  │  0  │ │  1  │ │  2  │
///  │  └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐
///  1  │  3  │ │  4  │ │  5  │
///  │  └─────┘ └─────┘ └─────┘
///  │  ┌─────┐ ┌─────┐ ┌─────┐
///  2  │  6  │ │  7  │ │     │
///  │  └─────┘ └─────┘ └─────┘
///  ▼
///  y
///  ```
Puzzle createPuzzle(
  int dimension, {
  Position? whitespaceTileCurrentPosition,
}) {
  final targetPositions = <Position>[
    for (var y = 0; y < dimension; y++)
      for (var x = 0; x < dimension; x++) Position(x: x, y: y)
  ];

  final currentPositions = targetPositions.toList();

  if (whitespaceTileCurrentPosition != null) {
    // Swap the whitespace tile position with the respective tile position

    final positionIndex = currentPositions
        .indexWhere((position) => position == whitespaceTileCurrentPosition);

    final whitespacePositionIndex = dimension * dimension - 1;

    currentPositions[positionIndex] = currentPositions[whitespacePositionIndex];
    currentPositions[whitespacePositionIndex] = whitespaceTileCurrentPosition;
  }

  final tiles = <Tile>[
    for (var i = 0; i < targetPositions.length; i++)
      Tile(
        targetPosition: targetPositions[i],
        currentPosition: currentPositions[i],
        isWhitespace: targetPositions[i].x == dimension - 1 &&
            targetPositions[i].y == dimension - 1,
      ),
  ];

  return Puzzle(tiles: tiles);
}
