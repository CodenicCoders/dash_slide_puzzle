import 'package:path/path.dart' as p;

/// Contains helper methods for fetching background assets.
class BackgroundAssets {
  BackgroundAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'images', 'background');

  static final portraitClouds = p.join(_root, 'clouds_portrait.webp');
  static final landscapeClouds = p.join(_root, 'clouds_landscape.webp');
  static final portraitStars = p.join(_root, 'stars_portrait.webp');
  static final landscapeStars = p.join(_root, 'stars_landscape.webp');
  static final sun = p.join(_root, 'sun.webp');
  static final moon = p.join(_root, 'moon.webp');
}
