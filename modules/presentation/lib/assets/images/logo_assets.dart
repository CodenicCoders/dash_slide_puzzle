import 'package:path/path.dart' as p;

class LogoAssets {
  const LogoAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'images', 'logos');

  static String get flutter => p.join(_root, 'flutter_mono.webp');
}
