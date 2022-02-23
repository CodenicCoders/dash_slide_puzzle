import 'package:presentation/presentation.dart';

/// A class for fetching logo assets.
class LogoAssets {
  const LogoAssets._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'images', 'logos']);

  /// Returns the file path of the `flutter_mono.webp` asset.
  static String get flutter => join([_root, 'flutter_mono.webp']);
}
