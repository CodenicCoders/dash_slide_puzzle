import 'package:application/application.dart';
import 'package:domain/service_interfaces/game_service.dart';

/// {@template WatchAvailableSpellStateUseCase}
///
/// A use case for watching the [AvailableSpellState].
///
/// See [GameService.watchAvailableSpellState].
///
/// {@endtemplate}
class WatchAvailableSpellStateUseCase extends Watcher<
    void,
    Failure,
    VerboseStream<Failure, AvailableSpellState?>,
    Failure,
    AvailableSpellState?> {
  /// {@macro WatchAvailableSpellStateUseCase}
  WatchAvailableSpellStateUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, VerboseStream<Failure, AvailableSpellState?>>> onCall(
    void params,
  ) =>
      _gameService.watchAvailableSpellState();
}
