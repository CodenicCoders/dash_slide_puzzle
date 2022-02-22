import 'package:domain/domain.dart';

/// {@template ResetGameUseCase}
///
/// A use case for resetting the game.
///
/// See [GameService.resetGame].
///
/// {@endtemplate}
class ResetGameUseCase extends Runner<void, Failure, void> {
  /// {@macro ResetGameUseCase}
  ResetGameUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, void>> onCall(void params) => _gameService.resetGame();
}
