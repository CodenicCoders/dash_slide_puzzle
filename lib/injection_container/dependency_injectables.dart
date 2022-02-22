part of 'injection_container.dart';

/// Registers all external dependencies in the [serviceLocator] as a lazy
/// singleton.
Future<void> _injectDependencies(GetIt serviceLocator) async {
  void _register<T extends Object>(FactoryFunc<T> factoryFunc) =>
      serviceLocator.registerLazySingleton<T>(factoryFunc);

  _register<CodenicLogger>(CodenicLogger.new);
}
