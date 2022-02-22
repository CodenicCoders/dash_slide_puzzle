import 'dart:math';

import 'package:path/path.dart' as p;

enum DashSound {
  dashSound1,
  dashSound2,
  dashSound3,
}

enum SpellAvailableSound {
  spellAvailableSound1,
  spellAvailableSound2,
}

/// Contains all sound effect assets.
class SFXAssets {
  SFXAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'audio', 'sfx');

  static final click = p.join(_root, 'click.mp3');
  static final shuffling = p.join(_root, 'shuffling.mp3');
  static final shuffled = p.join(_root, 'shuffled.mp3');
  static final tileMove = p.join(_root, 'tile_move.mp3');
  static final tileUnmovable = p.join(_root, 'tile_unmovable.mp3');
  static final toss = p.join(_root, 'toss.mp3');
  static final magic = p.join(_root, 'magic.mp3');
  static final deviceFall = p.join(_root, 'device_fall.mp3');
  static final complete = p.join(_root, 'complete.mp3');

  static String dashSound(DashSound dashSound) {
    final String fileName;

    switch (dashSound) {
      case DashSound.dashSound1:
        fileName = 'dash_sound_1.mp3';
        break;
      case DashSound.dashSound2:
        fileName = 'dash_sound_2.mp3';
        break;
      case DashSound.dashSound3:
        fileName = 'dash_sound_3.mp3';
        break;
    }

    final filePath = p.join(_root, fileName);
    return filePath;
  }

  static String randomDashSound() {
    final dashSounds = DashSound.values;
    final randomIndex = Random().nextInt(dashSounds.length);

    return dashSound(dashSounds[randomIndex]);
  }

  static String spellAvailableSound(SpellAvailableSound spellAvailableSound) {
    final String fileName;

    switch (spellAvailableSound) {
      case SpellAvailableSound.spellAvailableSound1:
        fileName = 'spell_available_1.mp3';
        break;
      case SpellAvailableSound.spellAvailableSound2:
        fileName = 'spell_available_2.mp3';
        break;
    }

    final filePath = p.join(_root, fileName);
    return filePath;
  }
}
