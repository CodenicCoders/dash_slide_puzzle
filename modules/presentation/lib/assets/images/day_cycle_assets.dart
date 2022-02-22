import 'package:application/application.dart';
import 'package:path/path.dart' as p;

class DayCycleAssets {
  const DayCycleAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'images', 'day_cycles');

  static String image(ThemeOption themeOption) {
    final String fileName;

    switch (themeOption) {
      case ThemeOption.day:
        fileName = 'day.webp';
        break;
      case ThemeOption.night:
        fileName = 'night.webp';
        break;
      case ThemeOption.prevening:
        fileName = 'prevening.webp';
    }

    return p.join(_root, fileName);
  }
}
