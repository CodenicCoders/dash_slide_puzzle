import 'package:domain/domain.dart';

/// {@template StartGameUseCase}
///
/// A use case for starting the game.
///
/// See [GameService.startGame].
///
/// {@endtemplate}
class StartGameUseCase extends Runner<void, Failure, void> {
  /// {@macro StartGameUseCase}
  StartGameUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, void>> onCall(void params) => _gameService.startGame();
}
