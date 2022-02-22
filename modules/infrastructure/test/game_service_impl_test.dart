import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/helpers.dart';

class MockLogger extends Mock implements CodenicLogger {}

class MockPuzzleService extends Mock implements PuzzleService {}

class FakePuzzle extends Fake implements Puzzle {}

void main() {
  setUpAll(
    () {
      registerFallbackValue(FakePuzzle());
      registerFallbackValue(const Position(x: 0, y: 0));
    },
  );

  group(
    '$GameServiceImpl',
    () {
      late GameService gameService;
      late PuzzleService puzzleService;

      setUp(() {
        final logger = MockLogger();
        puzzleService = MockPuzzleService();

        gameService =
            GameServiceImpl(logger: logger, puzzleService: puzzleService);

        // Stub puzzle with history
        final unsolvedPuzzle1 = createPuzzle(
          4,
          whitespaceTileCurrentPosition: const Position(x: 0, y: 0),
        );

        final unsolvedPuzzle2 = createPuzzle(
          4,
          whitespaceTileCurrentPosition: const Position(x: 1, y: 0),
        ).copyWith(previousPuzzle: unsolvedPuzzle1);

        final unsolvedPuzzle3 = createPuzzle(
          4,
          whitespaceTileCurrentPosition: const Position(x: 2, y: 0),
        ).copyWith(previousPuzzle: unsolvedPuzzle2);

        final unsolvedPuzzle4 = createPuzzle(
          4,
          whitespaceTileCurrentPosition: const Position(x: 3, y: 0),
        ).copyWith(previousPuzzle: unsolvedPuzzle3);

        final unsolvedPuzzle5 = createPuzzle(
          4,
          whitespaceTileCurrentPosition: const Position(x: 0, y: 1),
        ).copyWith(previousPuzzle: unsolvedPuzzle4);

        final unsolvedPuzzle6 = createPuzzle(
          4,
          whitespaceTileCurrentPosition: const Position(x: 1, y: 1),
        ).copyWith(previousPuzzle: unsolvedPuzzle5);

        when(() => puzzleService.createPuzzle(dimension: 4))
            .thenAnswer((_) async => Right(unsolvedPuzzle1));

        final solvedPuzzle =
            createPuzzle(4).copyWith(previousPuzzle: unsolvedPuzzle6);

        when(() => puzzleService.solvePuzzle(puzzle: any(named: 'puzzle')))
            .thenAnswer((_) async => Right(solvedPuzzle));
      });

      group(
        'setPuzzleSize',
        () {
          test(
            'should throw an [ArgumentError] when the size is less than 2',
            () {
              // When the puzzle size is set to less than 2
              // Then throw an [ArgumentError]
              expect(
                gameService.setPuzzleSize(dimension: 1),
                throwsArgumentError,
              );
            },
          );

          test(
            'should return a [GameAlreadyStartedFailure] when the game is in '
            'progress',
            () async {
              // Given that the game has started
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
              );

              // When the puzzle size is set
              final setPuzzleSizeResult =
                  await gameService.setPuzzleSize(dimension: 2);

              // Then return a [GameAlreadyStartedFailure]
              final failure = setPuzzleSizeResult.getLeft();

              expect(failure, isA<GameAlreadyStartedFailure>());
            },
          );

          test(
            'should set puzzle size to 5 for the player and bot',
            () async {
              // When the puzzle size is set to 5
              const dimension = 5;
              final puzzle = createPuzzle(dimension);

              when(() => puzzleService.createPuzzle(dimension: dimension))
                  .thenAnswer((_) async => Right(puzzle));

              await gameService.setPuzzleSize(dimension: dimension);

              // Then set the player and bot puzzle dimensions to 5

              final watchGameStateResult = await gameService.watchGameState();
              final verboseStream = watchGameStateResult.getRight();

              final expectedGameState = GameState(
                playerPuzzle: puzzle,
                botPuzzle: puzzle,
              );

              expect(verboseStream.stream, emits(expectedGameState));
            },
          );
        },
      );

      group(
        'startGame',
        () {
          test(
            'should return a [Failure] when the game is currently in progress',
            () async {
              // Given that the game has been started
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
              );

              // When the start game is called again
              final startGameResult = await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
              );

              // Then return a [GameAlreadyStartedFailure]
              expect(
                startGameResult.fold((l) => l, (r) => null),
                isA<GameAlreadyStartedFailure>(),
              );
            },
          );

          test(
            'should return a shuffled player and bot puzzles when game start '
            'completes',
            () async {
              // When the game starting completes
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
              );

              // Then player and bot puzzles should be shuffled

              final watchGameStateResult = await gameService.watchGameState();
              final watchGameState = watchGameStateResult.getRight();

              var isPuzzleShuffled = false;
              late StreamSubscription streamSubscription;

              streamSubscription = watchGameState.listen(
                expectAsyncUntil1(
                  (gameState) => isPuzzleShuffled =
                      !gameState.playerPuzzle.isCompleted &&
                          !gameState.botPuzzle.isCompleted,
                  () {
                    if (isPuzzleShuffled) {
                      streamSubscription.cancel();
                    }

                    return isPuzzleShuffled;
                  },
                ),
              );
            },
          );

          test(
            'should start bot when puzzle shuffling is completed',
            () async {
              // When the game has started

              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
              );

              // Then the bot should start solving its puzzle

              final watchGameStateResult = await gameService.watchGameState();
              final watchGameState = watchGameStateResult.getRight();

              var hasBotCompletedPuzzle = false;
              late StreamSubscription streamSubscription;

              streamSubscription = watchGameState.listen(
                expectAsyncUntil1(
                  (gameState) =>
                      hasBotCompletedPuzzle = gameState.botPuzzle.isCompleted,
                  () {
                    if (hasBotCompletedPuzzle) {
                      streamSubscription.cancel();
                    }

                    return hasBotCompletedPuzzle;
                  },
                ),
              );
            },
          );

          test(
            'should broadcast that the bot has won when its puzzle gets '
            'solved',
            () async {
              // When the game has started and the bot starts solving

              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
                gameSettings: const GameSettings().copyWith(
                  botMoveCooldownMinDuration: Duration.zero,
                  botMoveCooldownMaxDuration: Duration.zero,
                ),
              );

              // Then emit a game status of [GameStatus.botWon] once the bot
              // completes solving the puzzle
              final watchGameStateResult = await gameService.watchGameState();
              final watchGameState = watchGameStateResult.getRight();

              var hasPlayerWon = false;
              late StreamSubscription streamSubscription;

              streamSubscription = watchGameState.stream.listen(
                expectAsyncUntil1(
                  (gameState) =>
                      hasPlayerWon = gameState.status == GameStatus.botWon,
                  () {
                    if (hasPlayerWon) {
                      streamSubscription.cancel();
                    }
                    return hasPlayerWon;
                  },
                ),
              );
            },
          );
        },
      );

      group(
        'resetGame',
        () {
          test(
            'should return a [GameNotStartedFailure] when the game is not '
            'started',
            () async {
              // Given that the game has not started yet
              // When the game is reset
              final resetGameResult = await gameService.resetGame();

              // Then return a [GameNotStartedFailure]
              expect(
                resetGameResult.fold((l) => l, (r) => null),
                isA<GameNotStartedFailure>(),
              );
            },
          );

          test(
            'should reset game to its initial state',
            () async {
              // Given that the game is started
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
              );

              // When the game is reset
              await gameService.resetGame();

              // Then reset the game to its initial state
              final watchGameStateResult = await gameService.watchGameState();
              final watchGameState = watchGameStateResult.getRight();

              expect(watchGameState.stream, emitsThrough(GameState()));
            },
          );
        },
      );

      group(
        'movePlayerTile',
        () {
          test(
            'should return a [GameNotStartedFailure] when the game has not '
            'been started yet',
            () async {
              // Given that the game has not started yet
              // When the game is reset
              final movePlayerTileResult = await gameService.movePlayerTile(
                tileCurrentPosition: const Position(x: 0, y: 0),
              );

              // Then return a [GameNotStartedFailure]
              expect(
                movePlayerTileResult.fold((l) => l, (r) => null),
                isA<GameNotStartedFailure>(),
              );
            },
          );

          test(
            'should return a [TileNotMovableFailure] when the selected tile '
            'cannot be moved',
            () async {
              when(
                () => puzzleService.moveTile(
                  puzzle: any(named: 'puzzle'),
                  tileCurrentPosition: any(named: 'tileCurrentPosition'),
                ),
              ).thenAnswer((_) async => const Left(TileNotMovableFailure()));

              // Given that the game is in progress
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
              );

              // When the player moves a non-movable tile
              final movePlayerTileResult = await gameService.movePlayerTile(
                tileCurrentPosition: const Position(x: 0, y: 0),
              );

              // Then return a [TileNotMovableFailure]
              expect(
                movePlayerTileResult.fold((l) => l, (r) => null),
                isA<TileNotMovableFailure>(),
              );
            },
          );

          test(
            'should move tile of the player puzzle',
            () async {
              final expectedPuzzle = createPuzzle(6);

              when(
                () => puzzleService.moveTile(
                  puzzle: any(named: 'puzzle'),
                  tileCurrentPosition: any(named: 'tileCurrentPosition'),
                ),
              ).thenAnswer((_) async => Right(expectedPuzzle));

              // Given that the game is in progress
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
              );

              // When the player moves a movable tile
              await gameService.movePlayerTile(
                tileCurrentPosition: const Position(x: 0, y: 0),
              );

              // Then update the puzzle of the player
              final watchGameStateResult = await gameService.watchGameState();
              final watchGameState = watchGameStateResult.getRight();

              var hasPlayerPuzzleUpdated = false;
              late StreamSubscription streamSubscription;

              streamSubscription = watchGameState.stream.listen(
                expectAsyncUntil1(
                  (gameState) => hasPlayerPuzzleUpdated =
                      gameState.playerPuzzle == expectedPuzzle,
                  () {
                    if (hasPlayerPuzzleUpdated) {
                      streamSubscription.cancel();
                    }
                    return hasPlayerPuzzleUpdated;
                  },
                ),
              );
            },
          );

          test(
            'should broadcast that the player has won when the puzzle gets '
            'solved',
            () async {
              final solvedPuzzle = createPuzzle(6);

              when(
                () => puzzleService.moveTile(
                  puzzle: any(named: 'puzzle'),
                  tileCurrentPosition: any(named: 'tileCurrentPosition'),
                ),
              ).thenAnswer((_) async => Right(solvedPuzzle));

              // Given that the game is in progress

              await gameService.startGame(shuffleCooldownTime: Duration.zero);

              // When the player moves the last incomplete tile

              await gameService.movePlayerTile(
                tileCurrentPosition: const Position(x: 0, y: 0),
              );

              // Then emit a game status of [GameStatus.playerWon]
              final watchGameStateResult = await gameService.watchGameState();
              final watchGameState = watchGameStateResult.getRight();

              var hasPlayerWon = false;
              late StreamSubscription streamSubscription;

              streamSubscription = watchGameState.stream.listen(
                expectAsyncUntil1(
                  (gameState) =>
                      hasPlayerWon = gameState.status == GameStatus.playerWon,
                  () {
                    if (hasPlayerWon) {
                      streamSubscription.cancel();
                    }
                    return hasPlayerWon;
                  },
                ),
              );
            },
          );
        },
      );

      group(
        'castSpell',
        () {
          test(
            'should return a [GameNotStartedFailure] when the game is not in '
            'progress',
            () async {
              // When a spell is casted without an on-going game
              final castSpellResult = await gameService.castAvailableSpell();

              // Then return a [GameNotStartedFailure]
              expect(
                castSpellResult.fold((l) => l, (r) => null),
                isA<GameNotStartedFailure>(),
              );
            },
          );

          test(
            'should return a [NoAvailableSpellFailure] when no spell is '
            'available yet',
            () async {
              // Given that all spell cost is maxed out
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
                gameSettings: const GameSettings(
                  maxEnergyRecoveryDuration: Duration(seconds: 5),
                  slowSpellEnergyCost: 1,
                  stunSpellEnergyCost: 1,
                ),
              );

              // When a spell is casted immediately without the energy
              // recovering
              final castSpellResult = await gameService.castAvailableSpell();

              // Then return a [NoAvailableSpellFailure]
              expect(
                castSpellResult.fold((l) => l, (r) => null),
                isA<NoAvailableSpellFailure>(),
              );
            },
          );

          test(
            'should be able to detect when a spell has ended',
            () async {
              // Given that slow spell can be casted with zero energy and the
              // spell lasts for 100ms
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
                gameSettings: const GameSettings(
                  slowSpellEnergyCost: 0,
                  spellCastDelay: Duration.zero,
                  spellDuration: Duration(milliseconds: 100),
                ),
              );

              // When a spell is casted on the bot
              await Future<void>.delayed(const Duration(milliseconds: 100));

              await gameService.castAvailableSpell();

              // Then make sure that the [ActiveSpellState] is set to `null`
              // after it expires
              final watchActiveSpellStateResult =
                  await gameService.watchActiveSpellState();

              final watchActiveSpellState =
                  watchActiveSpellStateResult.getRight();

              late StreamSubscription streamSubscription;
              var hasActiveSpellStateExpired = false;

              streamSubscription = watchActiveSpellState.stream.listen(
                expectAsyncUntil1((activeSpellState) {
                  if (activeSpellState == null) {
                    hasActiveSpellStateExpired = true;
                  }
                }, () {
                  if (hasActiveSpellStateExpired) {
                    streamSubscription.cancel();
                  }

                  return hasActiveSpellStateExpired;
                }),
              );
            },
          );

          test(
            'should reset the [AvailableSpellState] to its original state '
            'when a spell has been casted',
            () async {
              // Given that slow spell that request max energy can be casted
              // after 100ms
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
                gameSettings: const GameSettings(
                  slowSpellEnergyCost: 1,
                  maxEnergyRecoveryDuration: Duration(milliseconds: 100),
                ),
              );

              // When a spell is casted on the bot
              await Future<void>.delayed(const Duration(milliseconds: 100));
              await gameService.castAvailableSpell();

              // Then make sure that the [AvailableSpellState] energy is reset
              // back to 0
              final watchAvailableSpellStateResult =
                  await gameService.watchAvailableSpellState();

              final watchAvailableSpellState =
                  watchAvailableSpellStateResult.getRight();

              var isEnergyBacktoZero = false;
              late StreamSubscription streamSubscription;

              streamSubscription = watchAvailableSpellState.stream.listen(
                expectAsyncUntil1(
                  (availableSpellState) {
                    isEnergyBacktoZero = availableSpellState?.energy == 0;
                  },
                  () {
                    if (isEnergyBacktoZero) {
                      streamSubscription.cancel();
                    }

                    return isEnergyBacktoZero;
                  },
                ),
              );
            },
          );

          test(
            "should slow down the bot's movement when slow spell is casted",
            () async {
              // Given that a slow spell lasts for 1s and slows down the bot's
              // speed by 100%
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
                gameSettings: const GameSettings(
                  slowSpellEnergyCost: 0,
                  botMoveCooldownMinDuration: Duration(milliseconds: 100),
                  botMoveCooldownMaxDuration: Duration(milliseconds: 100),
                  slowSpellCoefficient: 2,
                  spellCastDelay: Duration.zero,
                  spellDuration: Duration(seconds: 1),
                ),
              );

              // When a slow spell is casted on the bot
              await Future<void>.delayed(const Duration(milliseconds: 100));
              await gameService.castAvailableSpell();

              // Then make sure that the bot moves only once every 200ms
              final watchGameStateResult = await gameService.watchGameState();

              final watchGameState = watchGameStateResult.getRight();

              var isMoveSlowedDown = false;
              late StreamSubscription streamSubscription;
              DateTime? lastMoveTime;

              streamSubscription = watchGameState.stream.listen(
                expectAsyncUntil1(
                  (gameState) {
                    final now = DateTime.now();

                    if (lastMoveTime != null) {
                      isMoveSlowedDown =
                          now.difference(lastMoveTime!).inMilliseconds >= 200;
                    } else {
                      isMoveSlowedDown = false;
                    }

                    lastMoveTime = now;
                  },
                  () {
                    if (isMoveSlowedDown) {
                      streamSubscription.cancel();
                    }

                    return isMoveSlowedDown;
                  },
                ),
              );
            },
          );

          test(
            "should stop the bot's movement when stun spell is casted",
            () async {
              // Given that a stun spell lasts for 1s and the bot can move
              // without any cooldown
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
                gameSettings: const GameSettings(
                  stunSpellEnergyCost: 0,
                  spellCastDelay: Duration.zero,
                  botMoveCooldownMaxDuration: Duration(milliseconds: 100),
                  botMoveCooldownMinDuration: Duration(milliseconds: 100),
                  spellDuration: Duration(seconds: 1),
                ),
              );

              // When a stun spell is casted on the bot
              await Future<void>.delayed(const Duration(milliseconds: 100));
              await gameService.castAvailableSpell();

              // Then make sure that the bot does not move for 1 second
              final watchGameStateResult = await gameService.watchGameState();

              final watchGameState = watchGameStateResult.getRight();

              var isStunned = false;
              late StreamSubscription streamSubscription;
              DateTime? lastMoveTime;

              streamSubscription = watchGameState.stream.listen(
                expectAsyncUntil1(
                  (gameState) {
                    final now = DateTime.now();

                    if (lastMoveTime != null) {
                      isStunned =
                          now.difference(lastMoveTime!).inMilliseconds >= 1000;
                    } else {
                      isStunned = false;
                    }

                    lastMoveTime = now;
                  },
                  () {
                    if (isStunned) {
                      streamSubscription.cancel();
                    }

                    return isStunned;
                  },
                ),
              );
            },
          );

          test(
            "should reverse the bot's movement when time reversal spell is "
            'casted',
            () async {
              // Given that a reverse spell lasts for 1s and the bot can move
              // without any cooldown
              await gameService.startGame(
                shuffleCooldownTime: Duration.zero,
                botStartDelay: Duration.zero,
                gameSettings: const GameSettings(
                  timeReversalSpellEnergyCost: 0,
                  spellCastDelay: Duration.zero,
                  botMoveCooldownMinDuration:  Duration(milliseconds: 100),
                  botMoveCooldownMaxDuration: Duration(milliseconds: 100),
                  spellDuration: Duration(seconds: 2),
                ),
              );

              // When a reverse spell is casted
              await Future<void>.delayed(const Duration(milliseconds: 100));
              await gameService.castAvailableSpell();

              // Then ensure that the bot's puzzle depth reduces
              final watchGameStateResult = await gameService.watchGameState();

              final watchGameState = watchGameStateResult.getRight();

              var hasMovedBackward = false;
              late StreamSubscription streamSubscription;
              GameState? lastGameState;

              streamSubscription = watchGameState.stream.listen(
                expectAsyncUntil1(
                  (gameState) {
                    if (lastGameState != null) {
                      hasMovedBackward = gameState.botPuzzle.depth <
                          lastGameState!.botPuzzle.depth;
                    }

                    lastGameState = gameState;
                  },
                  () {
                    if (hasMovedBackward) {
                      streamSubscription.cancel();
                    }

                    return hasMovedBackward;
                  },
                ),
              );
            },
          );
        },
      );
    },
  );
}
