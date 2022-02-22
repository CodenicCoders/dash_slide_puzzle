import 'package:application/application.dart';
import 'package:path/path.dart' as p;

class SpellAssets {
  const SpellAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'images', 'spells');

  static String image(Spell spell) {
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

    return p.join(_root, fileName);
  }
}
