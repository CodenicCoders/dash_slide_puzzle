import 'package:codenic_bloc_use_case/codenic_bloc_use_case.dart';
import 'package:domain/entities/position.dart';
import 'package:domain/entities/puzzle.dart';
import 'package:domain/entities/tile.dart';
import 'package:domain/failures/failure.dart';
import 'package:domain/failures/tile_not_movable_failure.dart';

/// {@template PuzzleService}
///
/// A service that generates a sliding puzzle with available controls to
/// interact with it.
///
/// {@endtemplate}
abstract class PuzzleService {
  /// {@macro PuzzleService}
  const PuzzleService();

  /// Creates a solvable slider [Puzzle] with the given [dimension].
  ///
  /// If [shuffle] is `true`, then the generated puzzle will be shuffled.
  /// Otherwise, the returned [Puzzle] will be in its completed state.
  ///
  /// A [puzzleId] can be assigned to the generated [Puzzle] for identification
  /// purposes.
  ///
  /// The [dimension] must be greater than `1`.
  Future<Either<Failure, Puzzle>> createPuzzle({
    required int dimension,
    bool shuffle = true,
    String? puzzleId,
  });

  /// Returns `true` if the [puzzle] can be solved. Otherwise, `false` is
  /// returned.
  Future<Either<Failure, bool>> isPuzzleSolvable({required Puzzle puzzle});

  /// Checks whether the [Tile] with [tileCurrentPosition] within [puzzle] can
  /// be moved in the direction of the whitespace [Tile].
  ///
  /// Throws an [ArgumentError] if the [tileCurrentPosition] is not within the
  /// [puzzle] dimension.
  Future<Either<Failure, bool>> isTileMovable({
    required Puzzle puzzle,
    required Position tileCurrentPosition,
  });

  /// Moves the tile with [tileCurrentPosition] within the [puzzle] then
  /// returns a new updated [Puzzle] containing the previous state.
  ///
  /// A [Failure] may be returned:
  /// - [TileNotMovableFailure]
  Future<Either<Failure, Puzzle>> moveTile({
    required Puzzle puzzle,
    required Position tileCurrentPosition,
  });

  /// Accepts an incomplete [puzzle] then returns a new solved [Puzzle]
  /// containing all its previous states leading to its completion.
  ///
  /// Throws an [ArgumentError] if the given [puzzle] is not solvable or is
  /// already completed.
  Future<Either<Failure, Puzzle>> solvePuzzle({required Puzzle puzzle});
}
