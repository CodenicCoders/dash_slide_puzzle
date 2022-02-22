import 'package:application/application.dart';
import 'package:domain/service_interfaces/game_service.dart';

/// {@template WatchActiveSpellStateUseCase}
///
/// A use case for watching the [ActiveSpellState].
///
/// See [GameService.watchActiveSpellState].
///
/// {@endtemplate}
class WatchActiveSpellStateUseCase extends Watcher<void, Failure,
    VerboseStream<Failure, ActiveSpellState?>, Failure, ActiveSpellState?> {
  /// {@macro WatchActiveSpellStateUseCase}
  WatchActiveSpellStateUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, VerboseStream<Failure, ActiveSpellState?>>> onCall(
    void params,
  ) =>
      _gameService.watchActiveSpellState();
}
