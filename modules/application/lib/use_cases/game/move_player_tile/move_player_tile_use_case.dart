import 'package:domain/domain.dart';

/// {@template MovePlayerTileUseCase}
///
/// A use case for moving the player's puzzle tile.
///
/// See [GameService.movePlayerTile].
///
/// {@endtemplate}
class MovePlayerTileUseCase
    extends Runner<MovePlayerTileParams, Failure, void> {
  /// {@macro MovePlayerTileUseCase}
  MovePlayerTileUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, void>> onCall(MovePlayerTileParams params) =>
      _gameService.movePlayerTile(
        tileCurrentPosition: params.tileCurrentPosition,
      );
}

/// {@template MovePlayerTileParams}
///
/// The parameter for [MovePlayerTileUseCase].
///
/// {@endtemplate}
class MovePlayerTileParams with EquatableMixin {
  /// {@macro MovePlayerTileParams}
  const MovePlayerTileParams({required this.tileCurrentPosition});

  /// The current [Position] of the tile to move.
  final Position tileCurrentPosition;

  @override
  List<Object?> get props => [tileCurrentPosition];
}
