part of 'injection_container.dart';

/// Registers all use cases in the [serviceLocator] as a factory.
Future<void> _injectUseCases(GetIt serviceLocator) async {
  void _register<T extends Object>(FactoryFunc<T> factoryFunc) =>
      serviceLocator.registerFactory<T>(factoryFunc);

  /// CCC

  _register(() => CastAvailableSpellUseCase(gameService: serviceLocator()));

  /// MMM

  _register(() => MovePlayerTileUseCase(gameService: serviceLocator()));

  _register(() => MuteAllAudioUseCase(audioService: serviceLocator()));

  /// PPP

  _register(() => PlayLocalAudioUseCase(audioService: serviceLocator()));

  _register(PreviewCompletedPuzzleUseCase.new);

  /// RRR
  _register(() => ResetGameUseCase(gameService: serviceLocator()));

  /// SSS

  _register(() => StartGameUseCase(gameService: serviceLocator()));

  _register(SwitchThemeUseCase.new);

  /// UUU

  _register(() => UnmuteAllAudioUseCase(audioService: serviceLocator()));

  /// WWW

  _register(
    () => WatchActiveSpellStateUseCase(gameService: serviceLocator()),
  );

  _register(
    () => WatchAllAudioMutedStateUseCase(audioService: serviceLocator()),
  );

  _register(
    () => WatchAvailableSpellStateUseCase(gameService: serviceLocator()),
  );

  _register(() => WatchGameStateUseCase(gameService: serviceLocator()));
}
