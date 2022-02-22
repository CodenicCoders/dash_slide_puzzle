import 'package:domain/failures/failure.dart';

/// {@template ConcurrentMethodCallFailure}
///
/// A [Failure] indicating that one or more method calls are running
/// concurrently.
///
/// {@endtemplate}
class ConcurrentMethodCallFailure extends Failure {
  /// {@macro ConcurrentMethodCallFailure}
  const ConcurrentMethodCallFailure({
    String message = 'Concurrent method call detected',
  }) : super(message: message);
}
