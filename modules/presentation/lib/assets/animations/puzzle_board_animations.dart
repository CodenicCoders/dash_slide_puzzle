import 'package:application/application.dart';
import 'package:presentation/presentation.dart';

/// A class for accessing Rive animations for the puzzle board tiles.
class PuzzleBoardAnimations {
  PuzzleBoardAnimations._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'animations']);

  /// The path to the puzzle board Rive file.
  static final riveFilePath = join([_root, 'puzzle_board.riv']);

  /// The main artboard of the puzzle board Rive file.
  static const String mainArtboard = 'main';

  /// Returns the artboard of the tile at the specified [position].
  static String tileArtboard(Position position) =>
      'tile_x${position.x}y${position.y}';
}
