import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/helpers.dart';

class MockLogger extends Mock implements CodenicLogger {}

void main() {
  group('$PuzzleServiceImpl', () {
    late PuzzleService puzzleService;

    setUp(() {
      final logger = MockLogger();
      puzzleService = PuzzleServiceImpl(logger: logger);
    });

    group('createPuzzle', () {
      test(
        'should create 3x3 puzzle when given a dimension of 3',
        () async {
          final createPuzzleResult =
              await puzzleService.createPuzzle(dimension: 3);

          expect(
            createPuzzleResult.fold(
              (failure) => failure,
              (puzzle) => puzzle.dimension,
            ),
            3,
          );
        },
      );

      test(
        'should create an unshuffled puzzle',
        () async {
          final createPuzzleResult = await puzzleService.createPuzzle(
            dimension: 3,
            shuffle: false,
          );

          expect(
            createPuzzleResult.fold(
              (failure) => failure,
              (puzzle) => puzzle.isCompleted,
            ),
            true,
          );
        },
      );

      test(
        'should create a shuffled puzzle',
        () async {
          final createPuzzleResult =
              await puzzleService.createPuzzle(dimension: 3);

          expect(
            createPuzzleResult.fold(
              (failure) => failure,
              (puzzle) => puzzle.isCompleted,
            ),
            false,
          );
        },
      );
    });

    group(
      'isPuzzleSolvable',
      () {
        test(
          'should determine a solvable 2x2 puzzle',
          () async {
            final puzzle = createPuzzle(
              2,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 1),
            );

            final isPuzzleSolvableResult =
                await puzzleService.isPuzzleSolvable(puzzle: puzzle);

            expect(
              isPuzzleSolvableResult.fold(
                (l) => l,
                (isSolvable) => isSolvable,
              ),
              true,
            );
          },
        );

        test(
          'should determine an unsolvable 3x3 puzzle',
          () async {
            final puzzle = createPuzzle(
              3,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 2),
            );

            final isPuzzleSolvableResult =
                await puzzleService.isPuzzleSolvable(puzzle: puzzle);

            expect(
              isPuzzleSolvableResult.fold(
                (l) => l,
                (isSolvable) => isSolvable,
              ),
              false,
            );
          },
        );

        test(
          'should determine a solvable 3x3 puzzle',
          () async {
            final puzzle = createPuzzle(
              3,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 1),
            );

            final isPuzzleSolvableResult =
                await puzzleService.isPuzzleSolvable(puzzle: puzzle);

            expect(
              isPuzzleSolvableResult.fold(
                (l) => l,
                (isSolvable) => isSolvable,
              ),
              true,
            );
          },
        );

        test(
          'should determine an unsolvable 4x4 puzzle',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 2, y: 0),
            );

            final isPuzzleSolvableResult =
                await puzzleService.isPuzzleSolvable(puzzle: puzzle);

            expect(
              isPuzzleSolvableResult.fold(
                (l) => l,
                (isSolvable) => isSolvable,
              ),
              false,
            );
          },
        );

        test(
          'should determine a solvable 4x4 puzzle',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 3, y: 2),
            );

            final isPuzzleSolvableResult =
                await puzzleService.isPuzzleSolvable(puzzle: puzzle);

            expect(
              isPuzzleSolvableResult.fold(
                (l) => l,
                (isSolvable) => isSolvable,
              ),
              true,
            );
          },
        );
      },
    );

    group(
      'isTileMovable',
      () {
        test(
          'should return true when selected tile is vertically aligned with '
          'whitespace tile',
          () async {
            final puzzle = createPuzzle(4);

            final isTileMovableResult = await puzzleService.isTileMovable(
              puzzle: puzzle,
              tileCurrentPosition: const Position(x: 3, y: 0),
            );

            expect(
              isTileMovableResult.fold((l) => l, (isMovable) => isMovable),
              true,
            );
          },
        );

        test(
          'should return true when selected tile is horizontally aligned with '
          'whitespace tile',
          () async {
            final puzzle = createPuzzle(4);

            final isTileMovableResult = await puzzleService.isTileMovable(
              puzzle: puzzle,
              tileCurrentPosition: const Position(x: 0, y: 3),
            );

            expect(
              isTileMovableResult.fold((l) => l, (isMovable) => isMovable),
              true,
            );
          },
        );

        test(
          'should return true false when selected tile is not aligned with '
          'with whitespace tile',
          () async {
            final puzzle = createPuzzle(4);

            final isTileMovableResult = await puzzleService.isTileMovable(
              puzzle: puzzle,
              tileCurrentPosition: const Position(x: 2, y: 2),
            );

            expect(
              isTileMovableResult.fold((l) => l, (isMovable) => isMovable),
              false,
            );
          },
        );

        test(
          'should return false when the selected tile is the whitespace tile',
          () async {
            final puzzle = createPuzzle(4);

            final isTileMovableResult = await puzzleService.isTileMovable(
              puzzle: puzzle,
              tileCurrentPosition: const Position(x: 3, y: 3),
            );

            expect(
              isTileMovableResult.fold((l) => l, (isMovable) => isMovable),
              false,
            );
          },
        );
      },
    );

    group(
      'moveTile',
      () {
        test(
          'should throw an [ArgumentError] if the selected tile is not '
          'within the puzzle',
          () async {
            final puzzle = createPuzzle(4);
            const outOfBoundsPositions = Position(x: 4, y: 4);

            expect(
              puzzleService.moveTile(
                puzzle: puzzle,
                tileCurrentPosition: outOfBoundsPositions,
              ),
              throwsArgumentError,
            );
          },
        );

        test(
          'should return a [TileNotMovableFailure] if the selected tile '
          'cannot be moved',
          () async {
            final puzzle = createPuzzle(4);
            const nonAdjacentTile = Position(x: 0, y: 0);

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: nonAdjacentTile,
            );

            expect(
              moveTileResult.fold((failure) => failure, (r) => r),
              isA<TileNotMovableFailure>(),
            );
          },
        );

        test(
          'should return a [TileNotMovableFailure] if the selected tile is the '
          'whitespace tile',
          () async {
            final puzzle = createPuzzle(4);
            const nonAdjacentTile = Position(x: 3, y: 3);

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: nonAdjacentTile,
            );

            expect(
              moveTileResult.fold((failure) => failure, (r) => r),
              isA<TileNotMovableFailure>(),
            );
          },
        );

        test(
          'should move selected tile when whitespace is top adjacent',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 0),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 0, y: 1))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => puzzle
                    .tileWithCurrentPosition(const Position(x: 0, y: 0))!
                    .targetPosition,
              ),
              tileToMove.targetPosition,
            );
          },
        );

        test(
          'should move selected tile when whitespace is bottom adjacent',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 1),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 0, y: 0))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => puzzle
                    .tileWithCurrentPosition(const Position(x: 0, y: 1))!
                    .targetPosition,
              ),
              tileToMove.targetPosition,
            );
          },
        );

        test(
          'should move selected tile when whitespace is left adjacent',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 0),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 1, y: 0))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => puzzle
                    .tileWithCurrentPosition(const Position(x: 0, y: 0))!
                    .targetPosition,
              ),
              tileToMove.targetPosition,
            );
          },
        );

        test(
          'should move selected tile when whitespace is right adjacent',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 1, y: 0),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 0, y: 0))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => puzzle
                    .tileWithCurrentPosition(const Position(x: 1, y: 0))!
                    .targetPosition,
              ),
              tileToMove.targetPosition,
            );
          },
        );

        test(
          'should move selected and blocking tiles when whitespace is on top',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 0),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 0, y: 3))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => [
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 1))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 2))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 3))!
                      .targetPosition,
                ],
              ),
              [
                const Position(x: 0, y: 1),
                const Position(x: 0, y: 2),
                tileToMove.targetPosition,
                puzzle.whitespaceTile.targetPosition,
              ],
            );
          },
        );

        test(
          'should move selected and blocking tiles when whitespace is at the '
          'bottom',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 3),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 0, y: 0))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => [
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 1))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 2))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 3))!
                      .targetPosition,
                ],
              ),
              [
                puzzle.whitespaceTile.targetPosition,
                const Position(x: 0, y: 0),
                const Position(x: 0, y: 1),
                const Position(x: 0, y: 2),
              ],
            );
          },
        );

        test(
          'should move selected and blocking tiles when whitespace is on the '
          'left',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 0, y: 0),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 3, y: 0))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => [
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 1, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 2, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 3, y: 0))!
                      .targetPosition,
                ],
              ),
              [
                const Position(x: 1, y: 0),
                const Position(x: 2, y: 0),
                const Position(x: 3, y: 0),
                puzzle.whitespaceTile.targetPosition,
              ],
            );
          },
        );

        test(
          'should move selected and blocking tiles when whitespace is on the '
          'right',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 3, y: 0),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 0, y: 0))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold(
                (l) => l,
                (puzzle) => [
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 0, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 1, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 2, y: 0))!
                      .targetPosition,
                  puzzle
                      .tileWithCurrentPosition(const Position(x: 3, y: 0))!
                      .targetPosition,
                ],
              ),
              [
                puzzle.whitespaceTile.targetPosition,
                const Position(x: 0, y: 0),
                const Position(x: 1, y: 0),
                const Position(x: 2, y: 0),
              ],
            );
          },
        );

        test(
          'should contain the previous state of the puzzle prior to moving '
          'the tile',
          () async {
            final puzzle = createPuzzle(
              4,
              whitespaceTileCurrentPosition: const Position(x: 3, y: 0),
            );

            final tileToMove =
                puzzle.tileWithTargetPosition(const Position(x: 0, y: 0))!;

            final moveTileResult = await puzzleService.moveTile(
              puzzle: puzzle,
              tileCurrentPosition: tileToMove.currentPosition,
            );

            expect(
              moveTileResult.fold((l) => l, (puzzle) => puzzle.previousPuzzle),
              puzzle,
            );
          },
        );
      },
    );

    group('solvePuzzle', () {
      test(
        'should throw an [ArgumentError] when the puzzle is not solvable',
        () async {
          final puzzle = createPuzzle(
            2,
            whitespaceTileCurrentPosition: const Position(x: 0, y: 0),
          );

          expect(
            puzzleService.solvePuzzle(puzzle: puzzle),
            throwsArgumentError,
          );
        },
      );

      test(
        'should throw an [ArgumentError] when the puzzle is already completed',
        () async {
          final puzzle = createPuzzle(2);

          expect(
            puzzleService.solvePuzzle(puzzle: puzzle),
            throwsArgumentError,
          );
        },
      );

      test(
        'should solve a basic 2x2 puzzle',
        () async {
          final puzzle = createPuzzle(
            2,
            whitespaceTileCurrentPosition: const Position(x: 0, y: 1),
          );

          final solvePuzzleResult =
              await puzzleService.solvePuzzle(puzzle: puzzle);

          expect(
            solvePuzzleResult.fold(
              (l) => l,
              (puzzle) {
                final puzzleHistory = puzzle.history;

                return [
                  puzzleHistory.first.isCompleted,
                  puzzleHistory.last.isCompleted
                ];
              },
            ),
            [false, true],
          );
        },
      );

      test(
        'should solve a basic 3x3 puzzle',
        () async {
          final puzzle = createPuzzle(
            3,
            whitespaceTileCurrentPosition: const Position(x: 0, y: 1),
          );

          final solvePuzzleResult =
              await puzzleService.solvePuzzle(puzzle: puzzle);

          expect(
            solvePuzzleResult.fold(
              (l) => l,
              (puzzle) {
                final puzzleHistory = puzzle.history;

                return [
                  puzzleHistory.first.isCompleted,
                  puzzleHistory.last.isCompleted
                ];
              },
            ),
            [false, true],
          );
        },
      );

      test(
        'should solve a basic 4x4 puzzle',
        () async {
          final puzzle = createPuzzle(
            4,
            whitespaceTileCurrentPosition: const Position(x: 3, y: 2),
          );

          final solvePuzzleResult =
              await puzzleService.solvePuzzle(puzzle: puzzle);

          expect(
            solvePuzzleResult.fold(
              (l) => l,
              (puzzle) {
                final puzzleHistory = puzzle.history;

                return [
                  puzzleHistory.first.isCompleted,
                  puzzleHistory.last.isCompleted
                ];
              },
            ),
            [false, true],
          );
        },
      );

      test(
        'should solve a complex 4x4 puzzle',
        () async {
          final puzzle = Puzzle(
            tiles: [
              const Tile(
                currentPosition: Position(x: 2, y: 3),
                targetPosition: Position(x: 0, y: 0),
              ),
              const Tile(
                currentPosition: Position(x: 0, y: 1),
                targetPosition: Position(x: 1, y: 0),
              ),
              const Tile(
                currentPosition: Position(x: 1, y: 3),
                targetPosition: Position(x: 2, y: 0),
              ),
              const Tile(
                currentPosition: Position(x: 0, y: 3),
                targetPosition: Position(x: 3, y: 0),
              ),
              const Tile(
                currentPosition: Position(x: 1, y: 0),
                targetPosition: Position(x: 0, y: 1),
              ),
              const Tile(
                targetPosition: Position(x: 1, y: 1),
                currentPosition: Position(x: 2, y: 2),
              ),
              const Tile(
                currentPosition: Position(x: 2, y: 1),
                targetPosition: Position(x: 2, y: 1),
              ),
              const Tile(
                currentPosition: Position(x: 2, y: 0),
                targetPosition: Position(x: 3, y: 1),
              ),
              const Tile(
                currentPosition: Position(x: 0, y: 2),
                targetPosition: Position(x: 0, y: 2),
              ),
              const Tile(
                currentPosition: Position(x: 3, y: 1),
                targetPosition: Position(x: 1, y: 2),
              ),
              const Tile(
                currentPosition: Position(x: 3, y: 2),
                targetPosition: Position(x: 2, y: 2),
              ),
              const Tile(
                currentPosition: Position(x: 1, y: 1),
                targetPosition: Position(x: 3, y: 2),
              ),
              const Tile(
                currentPosition: Position(x: 3, y: 0),
                targetPosition: Position(x: 0, y: 3),
              ),
              const Tile(
                currentPosition: Position(x: 3, y: 3),
                targetPosition: Position(x: 1, y: 3),
              ),
              const Tile(
                currentPosition: Position(x: 1, y: 2),
                targetPosition: Position(x: 2, y: 3),
              ),
              const Tile(
                currentPosition: Position(x: 0, y: 0),
                targetPosition: Position(x: 3, y: 3),
                isWhitespace: true,
              ),
            ],
          );

          final solvePuzzleResult =
              await puzzleService.solvePuzzle(puzzle: puzzle);

          expect(
            solvePuzzleResult.fold(
              (l) => l,
              (puzzle) {
                final puzzleHistory = puzzle.history;

                return [
                  puzzleHistory.first.isCompleted,
                  puzzleHistory.last.isCompleted
                ];
              },
            ),
            [false, true],
          );
        },
      );
    });

    group(
      'demo',
      () {
        // Un-comment the code below to run the test demo

        // test(
        //   'should print puzzle completion path of a solved 6x6 puzzle',
        //   () async {
        //     final createPuzzleResult =
        //         await puzzleService.createPuzzle(dimension: 6);

        //     final puzzle = createPuzzleResult.getRight();

        //     final solvePuzzleResult =
        //         await puzzleService.solvePuzzle(puzzle: puzzle);

        //     final puzzleHistory = solvePuzzleResult.getRight().history;

        //     for (var i = 0; i < puzzleHistory.length; i++) {
        //       final puzzle = puzzleHistory[i];
        //       final dimension = puzzle.dimension;

        //       final puzzleBoard = StringBuffer()
        //         ..writeln(
        //           'Depth: ${puzzle.depth}, '
        //           'Completed Tiles: ${puzzle.completedTilesCount}, '
        //           'IncompleteTiles: ${puzzle.incompleteTilesCount}',
        //         )
        //         ..write('  x ')
        //         ..writeln(
        //           [
        //             for (var d = 0; d < dimension; d++)
        //               d < 10
        //                   ? ' $d '
        //                   : '$d ' // ignore: lines_longer_than_80_chars
        //           ].reduce((value, element) => value + element),
        //         )
        //         ..write('y +')
        //         ..writeln(
        //           [for (var d = 0; d < dimension; d++) '––+']
        //               .reduce((value, element) => value + element),
        //         );

        //       for (var y = 0; y < dimension; y++) {
        //         puzzleBoard.write('$y | ');
        //         for (var x = 0; x < dimension; x++) {
        //           final tile =
        //               puzzle.tileWithCurrentPosition(Position(x: x, y: y))!;
        //           final targetPosition = tile.targetPosition;

        //           puzzleBoard.write(
        //             tile.isWhitespace
        //                 ? '   '
        //                 : ' ${targetPosition.x}${targetPosition.y}',
        //           );
        //         }
        //         puzzleBoard.writeln();
        //       }

        //       print(puzzleBoard.toString());
        //     }
        //   },
        // );
      },
    );
  });
}
