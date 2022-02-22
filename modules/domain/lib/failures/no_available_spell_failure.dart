import 'package:domain/failures/failure.dart';

/// {@template NoAvailableSpellFailure}
///
/// A [Failure] indicating that a spell is not available yet for casting.
///
/// {@endtemplate}
class NoAvailableSpellFailure extends Failure {
  /// {@macro NoAvailableSpellFailure}
  const NoAvailableSpellFailure({String message = 'Spells not ready'})
      : super(message: message);
}
