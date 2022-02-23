import 'dart:math';

import 'package:presentation/presentation.dart';

/// An identifier for the "hoot" sounds Dash makes.
enum DashSound {
  /// An identifier for the `dash_sound_1.mp3` asset.
  dashSound1,

  /// An identifier for the `dash_sound_2.mp3` asset.
  dashSound2,

  /// An identifier for the `dash_sound_3.mp3` asset.
  dashSound3,
}

/// An identifier for spell availability sounds.
enum SpellAvailableSound {
  /// An identifier for the `spell_available_1.mp3` asset.
  spellAvailableSound1,

  /// An identifier for `spell_available_2.mp3` asset.
  spellAvailableSound2,
}

/// Contains all sound effect assets.
class SFXAssets {
  SFXAssets._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'audio', 'sfx']);

  /// The file path to the `click.mp3` asset.
  static final click = join([_root, 'click.mp3']);

  /// The file path to the `shuffling.mp3` asset.
  static final shuffling = join([_root, 'shuffling.mp3']);

  /// The file path to the `shuffled.mp3` asset.
  static final shuffled = join([_root, 'shuffled.mp3']);

  /// The file path to the `tile_move.mp3` asset.
  static final tileMove = join([_root, 'tile_move.mp3']);

  /// The file path to the `tile_unmovable.mp3` asset.
  static final tileUnmovable = join([_root, 'tile_unmovable.mp3']);

  /// The file path to the `toss.mp3` asset.
  static final toss = join([_root, 'toss.mp3']);

  /// The file path to the `magic.mp3` asset.
  static final magic = join([_root, 'magic.mp3']);

  /// The file path to the `device_fall.mp3` asset.
  static final deviceFall = join([_root, 'device_fall.mp3']);

  /// The file path to the `complete.mp3` asset.
  static final complete = join([_root, 'complete.mp3']);

  /// Returns the file path for the specified [dashSound].
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

    final filePath = join([_root, fileName]);
    return filePath;
  }

  /// Returns the file path for a randomized Dash sound.
  static String randomDashSound() {
    const dashSounds = DashSound.values;
    final randomIndex = Random().nextInt(dashSounds.length);
    return dashSound(dashSounds[randomIndex]);
  }

  /// Returns the file path for the specified [spellAvailableSound].
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

    final filePath = join([_root, fileName]);
    return filePath;
  }
}
