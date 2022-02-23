import 'package:application/application.dart';
import 'package:presentation/presentation.dart';

/// A class for fetching the day cycle assets (day, prevening, evening).
class DayCycleAssets {
  const DayCycleAssets._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'images', 'day_cycles']);

  /// Returns the file path to a day cycle asset respective to the given
  /// [themeOption].
  static String dayCycle(ThemeOption themeOption) {
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

    return join([_root, fileName]);
  }
}
