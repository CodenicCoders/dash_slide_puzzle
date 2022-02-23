import 'package:presentation/presentation.dart';

/// A class for accessing Rive animations for the sky background.
class SkyAnimations {
  SkyAnimations._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'animations']);

  /// The path to the sky Rive file.
  static final riveFilePath = join([_root, 'sky.riv']);

  /// A sky artboard designed for wide layouts.
  static const String landscapeArtboard = 'sky_landscape';

  /// A sky artboard designed for narrow layouts.
  static const String portraitArtboard = 'sky_portrait';
}
