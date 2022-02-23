import 'package:application/application.dart';
import 'package:presentation/presentation.dart';

/// A class for fetching spell-related assets.
class SpellAssets {
  const SpellAssets._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'images', 'spells']);

  /// Returns the file path of the specified [spell].
  static String spell(Spell spell) {
    final String fileName;

    switch (spell) {
      case Spell.slow:
        fileName = 'pizza.webp';
        break;
      case Spell.stun:
        fileName = 'throw.webp';
        break;
      case Spell.timeReversal:
        fileName = 'magic.webp';
    }

    return join([_root, fileName]);
  }
}
