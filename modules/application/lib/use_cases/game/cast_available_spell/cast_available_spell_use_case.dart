import 'package:domain/domain.dart';

/// {@template CastAvailableSpellUseCase}
///
/// A use case for casting the available [Spell] the returns it.
///
/// See [GameService.castAvailableSpell].
///
/// {@endtemplate}
class CastAvailableSpellUseCase extends Runner<void, Failure, Spell> {
  /// {@macro CastAvailableSpellUseCase}
  CastAvailableSpellUseCase({required GameService gameService})
      : _gameService = gameService;

  final GameService _gameService;

  @override
  Future<Either<Failure, Spell>> onCall(void params) =>
      _gameService.castAvailableSpell();
}
