import 'package:domain/entities/tile.dart';
import 'package:domain/failures/failure.dart';

/// {@template TileOutOfBoundsFailure}
///
/// A [Failure] indicating that the selected [Tile] cannot be moved.
///
/// {@endtemplate}
class TileNotMovableFailure extends Failure {
  /// {@macro TileOutOfBoundsFailure}
  const TileNotMovableFailure({
    String message = 'Selected tile cannot be moved',
  }) : super(message: message);
}
