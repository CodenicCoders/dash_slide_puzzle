import 'package:domain/domain.dart';

/// {@template WatchGameStateUseCase}
///
/// A use case for watching the active [GameState].
///
/// See [GameService.watchGameState].
/// 
/// {@endtemplate}
class WatchGameStateUseCase extends Watcher<void, Failure,
    VerboseStream<Failure, GameState>, Failure, GameState> {
  /// {@macro WatchGameStateUseCase}
  WatchGameStateUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, VerboseStream<Failure, GameState>>> onCall(
    void params,
  ) =>
      _gameService.watchGameState();
}
