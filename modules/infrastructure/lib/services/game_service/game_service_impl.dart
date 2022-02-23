import 'dart:async';

import 'package:codenic_logger/codenic_logger.dart';
import 'package:domain/domain.dart';
import 'package:domain/failures/concurrent_method_call_failure.dart';
import 'package:infrastructure/services/game_service/bot_player/bot_player.dart';
import 'package:rxdart/subjects.dart';

/// {@template GameServiceImpl}
///
/// A service for managing the puzzle game behavior and states.
///
/// {@endtemplate}
class GameServiceImpl implements GameService {
  /// {@macro GameServiceImpl}
  GameServiceImpl({
    required CodenicLogger logger,
    required PuzzleService puzzleService,
  })  : _logger = logger,
        _puzzleService = puzzleService;

  final CodenicLogger _logger;
  final PuzzleService _puzzleService;

  final _gameStateSubject = BehaviorSubject<GameState>()..add(GameState());
  final _activeSpellStateSubject = BehaviorSubject<ActiveSpellState?>();
  final _availableSpellStateSubject = BehaviorSubject<AvailableSpellState?>();

  GameSettings _gameSettings = const GameSettings();

  /// The current bot instance.
  late BotPlayer _botPlayer;

  /// A token to prevent concurrent method calls.
  int _actionToken = 0;

  Puzzle _initialPuzzle = Puzzle.defaults();

  @override
  Future<Either<Failure, VerboseStream<Failure, GameState>>>
      watchGameState() async {
    final verboseStream = VerboseStream<Failure, GameState>(
      errorConverter: (error, stackTrace) {
        if (error is Error) {
          throw error;
        }

        return const Failure();
      },
      stream: _gameStateSubject,
    );

    return Right(verboseStream);
  }

  @override
  Future<Either<Failure, VerboseStream<Failure, ActiveSpellState?>>>
      watchActiveSpellState() async {
    final verboseStream = VerboseStream<Failure, ActiveSpellState?>(
      errorConverter: (error, stackTrace) {
        if (error is Error) {
          throw error;
        }

        return const Failure();
      },
      stream: _activeSpellStateSubject,
    );

    return Right(verboseStream);
  }

  @override
  Future<Either<Failure, VerboseStream<Failure, AvailableSpellState?>>>
      watchAvailableSpellState() async {
    final verboseStream = VerboseStream<Failure, AvailableSpellState?>(
      errorConverter: (error, stackTrace) {
        if (error is Error) {
          throw error;
        }

        return const Failure();
      },
      stream: _availableSpellStateSubject,
    );

    return Right(verboseStream);
  }

  @override
  Future<Either<Failure, void>> setPuzzleSize({required int dimension}) async {
    final actionToken = ++_actionToken;

    final messageLog = MessageLog(
      id: '$GameServiceImpl-setPuzzleSize',
      data: <String, dynamic>{
        'actionToken': actionToken,
        'dimension': dimension
      },
    );

    if (dimension < 2) {
      throw ArgumentError('size must be greater than 1');
    }

    final gameState = _gameStateSubject.value;

    if (gameState.status != GameStatus.notStarted) {
      return const Left(GameAlreadyStartedFailure());
    }

    final createPuzzleResult = await _puzzleService.createPuzzle(dimension: 5);

    if (actionToken != _actionToken) {
      _logger.warn(messageLog..message = 'Action token is stale');
      return const Left(ConcurrentMethodCallFailure());
    }

    _initialPuzzle = createPuzzleResult.getRight();

    final newGameState = _gameStateSubject.value.copyWith(
      playerPuzzle: _initialPuzzle,
      botPuzzle: _initialPuzzle,
    );

    _gameStateSubject.add(newGameState);

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['gameStatus'] = newGameState.status,
    );

    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> startGame({
    int shuffleCount = 3,
    Duration shuffleCooldownTime = const Duration(seconds: 1),
    Duration botStartDelay = const Duration(seconds: 1),
    GameSettings gameSettings = const GameSettings(),
  }) async {
    final actionToken = ++_actionToken;

    final messageLog = MessageLog(
      id: '$GameServiceImpl-startGame',
      data: <String, dynamic>{
        'shuffleCount': shuffleCount,
        'shuffleCooldownTime': shuffleCooldownTime,
        'gameSettings': gameSettings,
      },
    );

    var gameState = _gameStateSubject.value;

    if (gameState.status != GameStatus.notStarted) {
      _logger.warn(messageLog..message = 'Game is currently in progress');
      return const Left(GameAlreadyStartedFailure());
    }

    late final List<Puzzle> playerShuffledPuzzles;
    late final List<Puzzle> botShuffledPuzzles;
    late final Puzzle solvedBotPuzzle;

    gameState =
        _gameStateSubject.value.copyWith(status: GameStatus.initializing);

    _gameStateSubject.add(gameState);

    // Create shuffled puzzles for bot and player, and one solved puzzle for
    // the bot

    await Future.wait<void>(
      [
        Future(() async {
          playerShuffledPuzzles = await _createShuffledPuzzles(
            dimension: gameState.puzzleDimension,
            count: shuffleCount,
          );
        }),
        Future(() async {
          botShuffledPuzzles = await _createShuffledPuzzles(
            dimension: gameState.puzzleDimension,
            count: shuffleCount,
          );

          final solvedPuzzleResult =
              await _puzzleService.solvePuzzle(puzzle: botShuffledPuzzles.last);

          solvedBotPuzzle = solvedPuzzleResult.getRight();
        }),
      ],
    );

    // Start emitting new [GameState]s with the shuffled puzzles

    for (var i = 0; i < shuffleCount; i++) {
      if (actionToken != _actionToken) {
        _logger.warn(messageLog..message = 'Action token is stale');
        return const Left(ConcurrentMethodCallFailure());
      }

      final isLastShuffle = i == shuffleCount - 1;

      gameState = _gameStateSubject.value.copyWith(
        status: isLastShuffle ? GameStatus.playing : GameStatus.shuffling,
        playerPuzzle: playerShuffledPuzzles[i],
        botPuzzle: botShuffledPuzzles[i],
      );

      _gameStateSubject.add(gameState);

      if (!isLastShuffle) await Future<void>.delayed(shuffleCooldownTime);
    }

    // Save the game settings

    _gameSettings = gameSettings;

    // Start the bot

    unawaited(
      _startBot(solvedPuzzle: solvedBotPuzzle, botStartDelay: botStartDelay),
    );

    unawaited(_onUpdate());

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['gameStatus'] = gameState.status,
    );

    return const Right(null);
  }

  Future<List<Puzzle>> _createShuffledPuzzles({
    required int dimension,
    required int count,
  }) {
    return Future.wait<Puzzle>([
      for (var i = 0; i < count; i++)
        Future(
          () async {
            final createPuzzleResult =
                await _puzzleService.createPuzzle(dimension: dimension);

            return createPuzzleResult.getRight();
          },
        ),
    ]);
  }

  /// Enables the bot to start solving the puzzle.
  ///
  /// The bot automatically stops when it detects that the game has ended.
  Future<void> _startBot({
    required Puzzle solvedPuzzle,
    required Duration botStartDelay,
  }) async {
    // Create a bot instance
    _botPlayer =
        BotPlayer(solvedPuzzle: solvedPuzzle, gameSettings: _gameSettings);

    // Enable the bot to solve its puzzle

    await Future<void>.delayed(botStartDelay);
    await _botPlayer.start(puzzle: solvedPuzzle);

    late StreamSubscription<Puzzle> puzzleMoveSubscription;
    late StreamSubscription<ActiveSpellState?> activeSpellStateSubscription;
    late StreamSubscription<GameState> gameStateSubscription;

    // Set up new [ActiveSpellState] listener

    activeSpellStateSubscription = _botPlayer.activeSpellStateSubject.listen(
      (newActiveSpellState) {
        final gameState = _gameStateSubject.value;

        if (gameState.status == GameStatus.playing) {
          _activeSpellStateSubject.add(newActiveSpellState);
        }
      },
      onDone: () {
        _activeSpellStateSubject.add(null);
        activeSpellStateSubscription.cancel();
      },
    );

    // Set up new bot [Puzzle] move listener

    puzzleMoveSubscription = _botPlayer.puzzleMoveSubject.listen(
      (newBotPuzzle) {
        final gameState = _gameStateSubject.value;

        if (gameState.status == GameStatus.playing) {
          final newGameState = gameState.copyWith(
            botPuzzle: newBotPuzzle,
            status: newBotPuzzle.isCompleted ? GameStatus.botWon : null,
          );

          _gameStateSubject.add(newGameState);
        }
      },
      onDone: () => puzzleMoveSubscription.cancel(),
    );

    // Close the bot when the game has ended

    gameStateSubscription = _gameStateSubject.listen(
      (gameState) {
        if (gameState.status != GameStatus.playing) {
          _botPlayer.close();
        }
      },
      onDone: () => gameStateSubscription.cancel(),
    );
  }

  /// A fixed interval for updating the services's state while the game status
  /// is equal to [GameStatus.playing].
  Future<void> _onUpdate() async {
    while (_gameStateSubject.value.status == GameStatus.playing) {
      _updateAvailableSpellState();
      await Future<void>.delayed(const Duration(milliseconds: 8));
    }

    _availableSpellStateSubject.add(null);
  }

  /// Updates the [AvailableSpellState] of [_availableSpellStateSubject].
  void _updateAvailableSpellState() {
    final oldAvailableSpellState = _availableSpellStateSubject.valueOrNull;

    // If the available spell state is null, then emit an initial value
    if (oldAvailableSpellState == null) {
      _availableSpellStateSubject.add(AvailableSpellState.initial());
      return;
    }

    // Compute new energy value

    final spellDuration = _gameSettings.maxEnergyRecoveryDuration;
    final lastSpellCastedTime = oldAvailableSpellState.lastSpellCastedTime;

    final maxEnergyRecoveryTime = lastSpellCastedTime.add(spellDuration);

    final now = DateTime.now();

    final newEnergy = (now.difference(lastSpellCastedTime).inMilliseconds /
            maxEnergyRecoveryTime
                .difference(lastSpellCastedTime)
                .inMilliseconds)
        .minMax(0, 1)
        .toDouble();

    // Determine the new available spell

    final Spell? newAvailableSpell;

    if (newEnergy >= _gameSettings.timeReversalSpellEnergyCost) {
      newAvailableSpell = Spell.timeReversal;
    } else if (newEnergy >= _gameSettings.stunSpellEnergyCost) {
      newAvailableSpell = Spell.stun;
    } else if (newEnergy >= _gameSettings.slowSpellEnergyCost) {
      newAvailableSpell = Spell.slow;
    } else {
      newAvailableSpell = null;
    }

    // Determine if recent spell

    final isRecentSpell = newAvailableSpell != null &&
        oldAvailableSpellState.spell != newAvailableSpell;

    // Emit the new available spell state

    final newAvailableSpellState = AvailableSpellState(
      energy: newEnergy,
      spell: newAvailableSpell,
      isRecentSpell: isRecentSpell,
      lastSpellCastedTime: lastSpellCastedTime,
    );

    _availableSpellStateSubject.add(newAvailableSpellState);
  }

  @override
  Future<Either<Failure, void>> resetGame() async {
    ++_actionToken;

    final messageLog = MessageLog(id: '$GameServiceImpl-resetGame');

    final gameState = _gameStateSubject.value;

    if (gameState.status == GameStatus.notStarted) {
      _logger.warn(messageLog..message = 'Game has not started yet');
      return const Left(GameNotStartedFailure());
    }

    final newGameState = gameState.copyWith(
      status: GameStatus.notStarted,
      botPuzzle: _initialPuzzle,
      playerPuzzle: _initialPuzzle,
    );

    _gameStateSubject.add(newGameState);

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['gameStatus'] = gameState.status,
    );

    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> movePlayerTile({
    required Position tileCurrentPosition,
  }) async {
    final actionToken = ++_actionToken;

    final messageLog = MessageLog(
      id: '$GameServiceImpl-movePlayerTile',
      data: <String, dynamic>{'tileCurrentPosition': tileCurrentPosition},
    );

    final gameState = _gameStateSubject.value;

    if (gameState.status == GameStatus.notStarted) {
      _logger.warn(messageLog..message = 'Game has not started yet');
      return const Left(GameNotStartedFailure());
    }

    final moveTileResult = await _puzzleService.moveTile(
      puzzle: gameState.playerPuzzle,
      tileCurrentPosition: tileCurrentPosition,
    );

    if (actionToken != _actionToken) {
      _logger.warn(messageLog..message = 'Action token is stale');
      return const Left(ConcurrentMethodCallFailure());
    }

    if (moveTileResult.isLeft()) {
      _logger.warn(
        messageLog
          ..message = 'Move tile failed'
          ..data['failure'] = moveTileResult,
      );

      return moveTileResult;
    }

    final newPuzzle = moveTileResult.getRight();
    final newGameState = gameState.copyWith(
      playerPuzzle: newPuzzle,
      status: newPuzzle.isCompleted ? GameStatus.playerWon : null,
    );

    _gameStateSubject.add(newGameState);

    _logger.info(
      messageLog
        ..message = 'Success'
        ..data['puzzle'] = newPuzzle.tiles,
    );

    return const Right(null);
  }

  @override
  Future<Either<Failure, Spell>> castAvailableSpell() async {
    final messageLog = MessageLog(id: '$GameServiceImpl-castSpell');

    final gameState = _gameStateSubject.value;

    if (gameState.status != GameStatus.playing) {
      _logger.warn(messageLog..message = 'Game has not started yet');
      return const Left(GameNotStartedFailure());
    }

    final availableSpellState = _availableSpellStateSubject.valueOrNull;
    final spell = availableSpellState?.spell;

    messageLog.data['availableSpellState'] = availableSpellState;

    if (spell == null) {
      _logger.warn(messageLog..message = 'No available spell yet');
      return const Left(NoAvailableSpellFailure());
    }

    unawaited(_botPlayer.castSpell(spell: spell));

    // Once a spell has been casted, reset the available spell state to its
    // initial state

    _availableSpellStateSubject.add(AvailableSpellState.initial());

    _logger.info(messageLog..message = 'Success');
    return Right(spell);
  }
}
