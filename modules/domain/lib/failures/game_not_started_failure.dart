import 'package:domain/failures/failure.dart';

/// {@template GameNotStartedFailure}
///
/// A [Failure] indicating that the game has not started yet.
///
/// {@endtemplate}
class GameNotStartedFailure extends Failure {
  /// {@macro GameNotStartedFailure}
  const GameNotStartedFailure({
    String message = 'The game has not started yet',
  }) : super(message: message);
}
