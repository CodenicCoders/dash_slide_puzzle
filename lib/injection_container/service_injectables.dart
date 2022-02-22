part of 'injection_container.dart';

/// Registers all services in the [serviceLocator] as a lazy singleton.
Future<void> _injectServices(GetIt serviceLocator) async {
  void _register<T extends Object>(FactoryFunc<T> factoryFunc) =>
      serviceLocator.registerLazySingleton<T>(factoryFunc);

  _register<AudioService>(() => AudioServiceImpl(logger: serviceLocator()));

  _register<GameService>(
    () => GameServiceImpl(
      logger: serviceLocator(),
      puzzleService: serviceLocator(),
    ),
  );

  _register<PuzzleService>(() => PuzzleServiceImpl(logger: serviceLocator()));
}
