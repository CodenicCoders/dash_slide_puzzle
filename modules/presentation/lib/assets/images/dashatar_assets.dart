import 'package:domain/entities/position.dart';
import 'package:path/path.dart' as p;

/// All available Dashatar variants
enum DashatarVariant {
  blue1,
  blue2,
  indigo1,
  indigo2,
  yellow1,
  yellow2,
}

/// Contains helper methods for fetching dashatar assets.
class DashatarAssets {
  const DashatarAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'images', 'dashatars');

  /// Returns the path for the main image of the [dashatarVariant].
  static String mainImage(DashatarVariant dashatarVariant) {
    final variant = _stringVariant(dashatarVariant);
    final subvariant = _stringSubvariant(dashatarVariant);

    return p.join(
      _root,
      variant,
      subvariant,
      '${variant}_dashatar_$subvariant.webp',
    );
  }

  /// Returns the specific tile at the given [position] of the
  /// [dashatarVariant].
  static String tileImage(DashatarVariant dashatarVariant, Position position) {
    final variant = _stringVariant(dashatarVariant);
    final subvariant = _stringSubvariant(dashatarVariant);

    return p.join(
      _root,
      variant,
      subvariant,
      'tiles',
      '${variant}_dashatar_${subvariant}_x${position.x}y${position.y}.webp',
    );
  }

  static String _stringVariant(DashatarVariant dashatarVariant) {
    switch (dashatarVariant) {
      case DashatarVariant.blue1:
      case DashatarVariant.blue2:
        return 'blue';
      case DashatarVariant.indigo1:
      case DashatarVariant.indigo2:
        return 'indigo';
      case DashatarVariant.yellow1:
      case DashatarVariant.yellow2:
        return 'yellow';
    }
  }

  static String _stringSubvariant(DashatarVariant dashatarVariant) {
    switch (dashatarVariant) {
      case DashatarVariant.blue1:
      case DashatarVariant.indigo1:
      case DashatarVariant.yellow1:
        return '001';
      case DashatarVariant.blue2:
      case DashatarVariant.indigo2:
      case DashatarVariant.yellow2:
        return '002';
    }
  }
}
