import 'package:application/application.dart';
import 'package:domain/domain.dart';

class MovePlayerTileUseCase
    extends Runner<MovePlayerTileParams, Failure, void> {
  MovePlayerTileUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, void>> onCall(MovePlayerTileParams params) =>
      _gameService.movePlayerTile(
        tileCurrentPosition: params.tileCurrentPosition,
      );
}

class MovePlayerTileParams with EquatableMixin {
  const MovePlayerTileParams({required this.tileCurrentPosition});

  final Position tileCurrentPosition;

  @override
  List<Object?> get props => [tileCurrentPosition];
}
