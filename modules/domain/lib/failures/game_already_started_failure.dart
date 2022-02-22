import 'package:domain/failures/failure.dart';

/// {@template GameAlreadyStartedFailure}
///
/// A [Failure] indicating that the game is currently in progress.
///
/// {@endtemplate}
class GameAlreadyStartedFailure extends Failure {
  /// {@macro GameAlreadyStartedFailure}
  const GameAlreadyStartedFailure({
    String message = 'The game has already started',
  }) : super(message: message);
}
