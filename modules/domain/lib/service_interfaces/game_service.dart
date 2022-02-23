import 'package:domain/domain.dart';
import 'package:domain/failures/concurrent_method_call_failure.dart';

/// A service for managing the puzzle game.
abstract class GameService {
  /// Returns a [VerboseStream] that emits the current [GameState].
  Future<Either<Failure, VerboseStream<Failure, GameState>>> watchGameState();

  /// Returns a [VerboseStream] that emits the [ActiveSpellState], if any.
  Future<Either<Failure, VerboseStream<Failure, ActiveSpellState?>>>
      watchActiveSpellState();

  /// Returns a [VerboseStream] that emits the [AvailableSpellState], if any.
  ///
  /// This is `null` if the game state is not [GameStatus.playing].
  Future<Either<Failure, VerboseStream<Failure, AvailableSpellState?>>>
      watchAvailableSpellState();

  /// Changes the size of the player's and the bot's puzzles.
  ///
  /// If the [dimension] is less than `2`, then an [ArgumentError] will be
  /// thrown.
  ///
  /// A [Failure] may be returned:
  /// - [ConcurrentMethodCallFailure]
  /// - [GameAlreadyStartedFailure]
  Future<Either<Failure, void>> setPuzzleSize({required int dimension});

  /// Starts the game by initially shuffling the puzzles and setting a new
  /// [gameSettings].
  ///
  /// The [GameState] will change to [GameStatus.shuffling] followed by
  /// [GameStatus.playing].
  ///
  /// If successful, then this enables the bot after the given [botStartDelay]
  /// to start solving their puzzle.
  ///
  /// A [Failure] may be returned:
  /// - [ConcurrentMethodCallFailure]
  /// - [GameAlreadyStartedFailure]
  Future<Either<Failure, void>> startGame({
    int shuffleCount = 3,
    Duration shuffleCooldownTime = const Duration(seconds: 1),
    Duration botStartDelay = const Duration(seconds: 1),
    GameSettings gameSettings = const GameSettings(),
  });

  /// Stops an on-going game.
  ///
  /// The [GameState] will change to [GameStatus.notStarted].
  ///
  /// A [Failure] may be returned:
  /// - [ConcurrentMethodCallFailure]
  /// - [GameNotStartedFailure]
  Future<Either<Failure, void>> resetGame();

  /// Moves the player's puzzle [Tile] at the [tileCurrentPosition].
  ///
  /// A [Failure] may be returned:
  /// - [ConcurrentMethodCallFailure]
  /// - [GameNotStartedFailure]
  /// - [TileNotMovableFailure]
  Future<Either<Failure, void>> movePlayerTile({
    required Position tileCurrentPosition,
  });

  /// Casts the available [Spell] from the [AvailableSpellState] at the bot
  /// which lasts based on the current [GameSettings.spellDuration] then
  /// returns the casted spell.
  ///
  /// The casted spell takes effect after the [GameSettings.spellCastDelay].
  ///
  /// A [Failure] may be returned:
  /// - [ConcurrentMethodCallFailure]
  /// - [GameNotStartedFailure]
  /// - [NoAvailableSpellFailure]
  Future<Either<Failure, Spell>> castAvailableSpell();
}
