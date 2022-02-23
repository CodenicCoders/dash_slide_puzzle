import 'dart:math';

import 'package:codenic_logger/codenic_logger.dart';
import 'package:domain/domain.dart';
import 'package:infrastructure/services/puzzle_service/puzzle_solver/puzzle_solver.dart';

/// {@template PuzzleServiceImpl}
///
/// The default implementation of the [PuzzleService].
///
/// {@endtemplate}
class PuzzleServiceImpl implements PuzzleService {
  /// {@macro PuzzleServiceImpl}
  const PuzzleServiceImpl({required CodenicLogger logger}) : _logger = logger;

  final CodenicLogger _logger;

  @override
  Future<Either<Failure, Puzzle>> createPuzzle({
    required int dimension,
    bool shuffle = true,
    String? puzzleId,
  }) async {
    assert(dimension > 1, 'Puzzle dimension must be greater than 1');

    final messageLog = MessageLog(
      id: '$PuzzleService-createPuzzle',
      data: <String, dynamic>{'dimension': dimension, 'shuffle': shuffle},
    );

    // Create all possible board positions

    final targetPositions = <Position>[];
    final currentPositions = <Position>[];

    for (var y = 0; y < dimension; y++) {
      for (var x = 0; x < dimension; x++) {
        final position = Position(x: x, y: y);
        targetPositions.add(position);
        currentPositions.add(position);
      }
    }

    // If do not shuffle, then create and return a puzzle in its completed state

    if (!shuffle) {
      final tiles =
          _createTilesFromPositions(targetPositions, currentPositions);

      final puzzle = Puzzle(tiles: tiles);

      _logger.info(
        messageLog
          ..message = 'Success'
          ..data['puzzle'] = puzzle.completedTilesCount,
      );

      return Right(puzzle);
    }

    // Shuffle the puzzle until a solvable puzzle is generated with at least
    // 85% of incomplete tiles

    while (true) {
      currentPositions.shuffle();

      final tiles =
          _createTilesFromPositions(targetPositions, currentPositions);

      final puzzle = Puzzle(tiles: tiles);

      if (puzzle.incompleteTilesCount < puzzle.tiles.length * 0.85) {
        continue;
      }

      final isPuzzleSolvableResult = await isPuzzleSolvable(puzzle: puzzle);

      final isSolvable = isPuzzleSolvableResult.getRight();

      if (!isSolvable) {
        continue;
      }

      _logger.info(
        messageLog
          ..message = 'Success'
          ..data['puzzle'] = puzzle.completedTilesCount,
      );

      return Right(puzzle);
    }
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _createTilesFromPositions(
    List<Position> targetPositions,
    List<Position> currentPositions,
  ) {
    final dimension = sqrt(targetPositions.length).toInt();
    final tiles = <Tile>[];

    for (var i = 0; i < targetPositions.length; i++) {
      final targetPosition = targetPositions[i];
      final currentPosition = currentPositions[i];

      final isWhitespace = targetPosition.x == dimension - 1 &&
          targetPosition.y == dimension - 1;

      tiles.add(
        Tile(
          currentPosition: currentPosition,
          targetPosition: targetPosition,
          isWhitespace: isWhitespace,
        ),
      );
    }

    return tiles;
  }

  @override
  Future<Either<Failure, bool>> isPuzzleSolvable({
    required Puzzle puzzle,
  }) async {
    // For more info in determining whether a sliding puzzle is solvable,
    // see https://www.geeksforgeeks.org/check-instance-15-puzzle-solvable/

    final messageLog = MessageLog(
      id: '$PuzzleService-isPuzzleSolvable',
      data: <String, dynamic>{'puzzle': puzzle.completedTilesCount},
    );

    final dimension = puzzle.dimension;

    final inversions = _countInversions(puzzle);

    // If the dimension is odd and the number of inversions is even, then the
    // puzzle is solvable

    if (dimension.isOdd) {
      _logger.info(
        messageLog
          ..message = 'Success'
          ..data['isSolvable'] = inversions.isEven,
      );

      return Right(inversions.isEven);
    }

    final whitespace = puzzle.whitespaceTile;
    final whitespaceRowFromBottom = dimension - whitespace.currentPosition.y;

    // The dimension is even. If the whitespace tile is on an odd row from
    // the bottom and the inversion count is even, then the puzzle is solvable
    if (whitespaceRowFromBottom.isOdd) {
      _logger.info(
        messageLog
          ..message = 'Success'
          ..data['isSolvable'] = inversions.isEven,
      );

      return Right(inversions.isEven);
    }
    // The dimension is even. If the whitespace tile is on an even row from
    // the bottom and the inversion count is odd, then the puzzle is solvable
    // if the inversion count is odd
    else {
      _logger.info(
        messageLog
          ..message = 'Success'
          ..data['isSolvable'] = inversions.isOdd,
      );

      return Right(inversions.isOdd);
    }
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  ///
  /// For more info on inversions, see https://math.stackexchange.com/a/838818/468695
  int _countInversions(Puzzle puzzle) {
    // Remove the whitespace tile since it will not be included in the
    // inversion count
    final whitespaceTile = puzzle.whitespaceTile;

    final nonWhitespaceTiles =
        puzzle.tiles.where((tile) => tile != whitespaceTile).toList();

    var inversionCount = 0;

    for (var a = 0; a < nonWhitespaceTiles.length - 1; a++) {
      for (var b = a + 1; b < nonWhitespaceTiles.length; b++) {
        final tileA = nonWhitespaceTiles[a];
        final tileB = nonWhitespaceTiles[b];

        // If tile A's current position is greater than tile B's, then
        // increment inversion count

        if (tileA.currentPosition.compareTo(tileB.currentPosition) > 0) {
          inversionCount++;
        }
      }
    }

    return inversionCount;
  }

  @override
  Future<Either<Failure, bool>> isTileMovable({
    required Puzzle puzzle,
    required Position tileCurrentPosition,
  }) async {
    final messageLog = MessageLog(
      id: '$PuzzleService-isTileMovable',
      data: <String, dynamic>{
        'puzzle': puzzle.completedTilesCount,
        'tileCurrentPosition': tileCurrentPosition
      },
    );

    final whitespaceTilePosition = puzzle.whitespaceTile.currentPosition;

    if (tileCurrentPosition == whitespaceTilePosition) {
      _logger.info(
        messageLog
          ..message = 'Selected tile is the whitespace tile'
          ..data['isMovable'] = false,
      );

      return const Right(false);
    }

    final isMovable = tileCurrentPosition.x == whitespaceTilePosition.x ||
        tileCurrentPosition.y == whitespaceTilePosition.y;

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['isMovable'] = isMovable,
    );

    return Right(isMovable);
  }

  @override
  Future<Either<Failure, Puzzle>> moveTile({
    required Puzzle puzzle,
    required Position tileCurrentPosition,
  }) async {
    final messageLog = MessageLog(
      id: '$PuzzleService-moveTile',
      data: <String, dynamic>{
        'puzzle': puzzle.completedTilesCount,
        'tileCurrentPosition': tileCurrentPosition
      },
    );

    final tileIndex = puzzle.tiles
        .indexWhere((tile) => tile.currentPosition == tileCurrentPosition);

    if (tileIndex == -1) {
      throw ArgumentError('Tile position is out of bounds');
    }

    final isTileMovableResult = await isTileMovable(
      puzzle: puzzle,
      tileCurrentPosition: tileCurrentPosition,
    );

    final isMovable = isTileMovableResult.getRight();

    if (!isMovable) {
      _logger.warn(messageLog..message = 'Tile is not movable');
      return const Left(TileNotMovableFailure());
    }

    final tile = puzzle.tiles[tileIndex];

    final newPuzzle = _moveTiles(puzzle, tile, []);

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['newPuzzle'] = newPuzzle.completedTilesCount,
    );

    return Right(newPuzzle);
  }

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified [Puzzle].
  ///
  /// Recursively stores a list of all tiles that need to be moved and passes
  /// the list to [_swapTiles] to individually swap them.
  Puzzle _moveTiles(Puzzle puzzle, Tile tile, List<Tile> tilesToSwap) {
    final whitespaceTile = puzzle.whitespaceTile;
    final deltaX = whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final deltaY = whitespaceTile.currentPosition.y - tile.currentPosition.y;
    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final shiftPointX = tile.currentPosition.x + deltaX.sign;
      final shiftPointY = tile.currentPosition.y + deltaY.sign;
      final tileToSwapWith = puzzle
          .tileWithCurrentPosition(Position(x: shiftPointX, y: shiftPointY))!;

      tilesToSwap.add(tile);

      return _moveTiles(puzzle, tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return _swapTiles(puzzle, tilesToSwap);
    }
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  Puzzle _swapTiles(Puzzle puzzle, List<Tile> tilesToSwap) {
    final tiles = puzzle.tiles.toList();

    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = tiles.singleWhere((tile) => tile.isWhitespace);
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      // Swap current board positions of the moving tile and the whitespace.
      tiles[tileIndex] = tile.copyWith(
        currentPosition: whitespaceTile.currentPosition,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: tile.currentPosition,
      );
    }

    return Puzzle(tiles: tiles, previousPuzzle: puzzle);
  }

  @override
  Future<Either<Failure, Puzzle>> solvePuzzle({
    required Puzzle puzzle,
  }) async {
    final messageLog = MessageLog(
      id: '$PuzzleService-solvePuzzle',
      data: <String, dynamic>{'puzzle': puzzle.completedTilesCount},
    );

    final isSolvableResult = await isPuzzleSolvable(puzzle: puzzle);

    final isSolvable = isSolvableResult.getRight();

    if (!isSolvable) {
      throw ArgumentError('Puzzle is not solvable');
    }

    if (puzzle.isCompleted) {
      throw ArgumentError('Puzzle is not solvable');
    }

    final solvedPuzzle = await PuzzleSolver.solve(
      PuzzleSolverParams(puzzleService: this, puzzle: puzzle),
    );

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['numberOfSteps'] = solvedPuzzle.history.length,
    );

    return Right(solvedPuzzle);
  }
}
