import 'package:presentation/presentation.dart';

/// An indeifier for the available faces of Dash.
enum DashFace {
  /// An identifier for the `face_normal.webp` asset.
  normal,

  /// An identifier for the `face_happy.webp` asset.
  happy,

  /// An identifier for the 'face_kawaii.webp` asset.
  kawaii,

  /// An identifier for the `face_wtf.webp` asset.
  wtf,

  /// An identifier for the `face_wtfff.webp` asset.
  wtfff,

  /// An identifier for the `face_sad.webp` asset.
  sad,

  /// An identifier for the `face_wizard.webp` asset.
  wizard,

  /// An idenfifier for the `face_happy_wizard.webp` asset.
  happyWizard,
}

/// An identifier for Dash's laptop (Rich bird problems).
enum DashDevice {
  /// An identifier for the `purple_laptop.webp` asset.
  purpleLaptop,

  /// An identifier for the `cyan_laptop.webp` asset.
  cyanLaptop,

  /// An identifier for the `green_laptop.webp` asset.
  greenLaptop,

  /// An identifier for the `pink_laptop.webp` asset.
  pinkLaptop,
}

/// An identier for Dash's body attire.
enum DashBody {
  /// An identifier for the `blue_hoodie.webp` asset.
  blueHoodie,

  /// An identifier for the `blue_polo.webp` asset.
  bluePolo,

  /// An identifier for the `blue_ribbon.webp` asset.
  blueRibbon,

  /// An identifier for the `green_hoodie.webp` asset.
  greenHoodie,

  /// An identifier for the `green_polo.webp` asset.
  greenPolo,

  /// An identifier for the `nude.webp` asset.
  nude,

  /// An identifier for the `wizard_robe.webp` asset.
  wizardRobe,

  /// An identifier for the `yellow_polo.webp` asset.
  yellowPolo,

  /// An identifier for the `yellow_tie.webp` asset.
  yellowTie,
}

/// A class for fetching Dash related sprite assets.
class DashSpriteAssets {
  DashSpriteAssets._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'images', 'dash_sprites']);

  /// The file path to the Dash's `left_wing.webp` asset.
  static final leftWing = join([_root, 'wings', 'left_wing.webp']);

  /// The file path to the Dash's `right_wing.webp` asset.
  static final rightWing = join([_root, 'wings', 'right_wing.webp']);

  /// The file path to the Dash's `comb.webp` asset.
  static final comb = join([_root, 'comb', 'comb.webp']);

  /// The file path to the Dash's `tail.webp` asset.
  static final tail = join([_root, 'tail', 'tail.webp']);

  /// The file path to the Dash's `wand.webp` asset.
  static final wand = join([_root, 'wand', 'wand.webp']);

  /// Returns the file path of the specified [dashFace].
  static String face(DashFace dashFace) {
    final String fileName;

    switch (dashFace) {
      case DashFace.normal:
        fileName = 'face_normal.webp';
        break;
      case DashFace.happy:
        fileName = 'face_happy.webp';
        break;
      case DashFace.kawaii:
        fileName = 'face_kawaii.webp';
        break;
      case DashFace.wtf:
        fileName = 'face_wtf.webp';
        break;
      case DashFace.wtfff:
        fileName = 'face_wtfff.webp';
        break;
      case DashFace.sad:
        fileName = 'face_sad.webp';
        break;
      case DashFace.wizard:
        fileName = 'face_wizard.webp';
        break;
      case DashFace.happyWizard:
        fileName = 'face_happy_wizard.webp';
        break;
    }

    final filePath = join([_root, 'faces', fileName]);
    return filePath;
  }

  /// Returns the file path of the specified [dashDevice].
  static String device(DashDevice dashDevice) {
    final String fileName;

    switch (dashDevice) {
      case DashDevice.purpleLaptop:
        fileName = 'purple_laptop.webp';
        break;
      case DashDevice.pinkLaptop:
        fileName = 'pink_laptop.webp';
        break;
      case DashDevice.cyanLaptop:
        fileName = 'cyan_laptop.webp';
        break;
      case DashDevice.greenLaptop:
        fileName = 'green_laptop.webp';
        break;
    }

    final filePath = join([_root, 'devices', fileName]);
    return filePath;
  }

  /// Returns the file path of the specified [dashBody].
  static String body(DashBody dashBody) {
    final String fileName;

    switch (dashBody) {
      case DashBody.bluePolo:
        fileName = 'blue_polo.webp';
        break;
      case DashBody.nude:
        fileName = 'nude.webp';
        break;
      case DashBody.greenHoodie:
        fileName = 'green_hoodie.webp';
        break;
      case DashBody.greenPolo:
        fileName = 'green_polo.webp';
        break;
      case DashBody.yellowPolo:
        fileName = 'yellow_polo.webp';
        break;
      case DashBody.wizardRobe:
        fileName = 'wizard_robe.webp';
        break;
      case DashBody.blueHoodie:
        fileName = 'blue_hoodie.webp';
        break;
      case DashBody.blueRibbon:
        fileName = 'blue_ribbon.webp';
        break;
      case DashBody.yellowTie:
        fileName = 'yellow_tie.webp';
        break;
    }

    final filePath = join([_root, 'body', fileName]);
    return filePath;
  }
}
