import 'package:path/path.dart' as p;

/// The available faces of Dash.
enum DashFace {
  /// The plain look of Dash
  normal,

  /// The happy face of Dash
  happy,

  /// A cute face of Dash with dimples
  kawaii,

  /// The judging face of Dash
  wtf,

  /// Open mouthed Dash due to disbelief
  wtfff,

  sad,
  wizard,
  happyWizard,
}

enum DashDevice {
  purpleLaptop,
  cyanLaptop,
  greenLaptop,
  pinkLaptop,
}

enum DashBody {
  blueHoodie,
  bluePolo,
  blueRibbon,
  greenHoodie,
  greenPolo,
  nude,
  wizardRobe,
  yellowPolo,
  yellowTie,
}

/// Contains helper methods for fetching dash sprites.
class DashSpriteAssets {
  DashSpriteAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'images', 'dash_sprites');

  static final leftWing = p.join(_root, 'wings', 'left_wing.webp');
  static final rightWing = p.join(_root, 'wings', 'right_wing.webp');
  static final comb = p.join(_root, 'comb', 'comb.webp');
  static final tail = p.join(_root, 'tail', 'tail.webp');
  static final wand = p.join(_root, 'wand', 'wand.webp');

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

    final filePath = p.join(_root, 'faces', fileName);
    return filePath;
  }

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

    final filePath = p.join(_root, 'devices', fileName);
    return filePath;
  }

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

    final filePath = p.join(_root, 'body', fileName);
    return filePath;
  }
}
