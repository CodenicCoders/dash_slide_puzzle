import 'package:application/application.dart';
import 'package:application/use_cases/audio/audio.dart';
import 'package:domain/domain.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:presentation/presentation.dart';

part 'dependency_injectables.dart';
part 'service_injectables.dart';
part 'use_case_injectables.dart';

/// Injects all service components to the [serviceLocator].

Future<void> initializeInjectionContainer() async {
  await Future.wait([
    _injectDependencies(serviceLocator),
    _injectServices(serviceLocator),
    _injectUseCases(serviceLocator),
  ]);
}
