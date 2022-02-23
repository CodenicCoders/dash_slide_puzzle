import 'package:presentation/presentation.dart';

/// A class for fetching throwable assets.
class ThrowableAssets {
  const ThrowableAssets._();

  static final _root =
      join(['packages', 'presentation', 'assets', 'images', 'throwables']);

  /// Returns the file path of the specified [throwable] object.
  static String throwable(ThrowableObject throwable) {
    final String fileName;

    switch (throwable) {
      case ThrowableObject.pizza:
        fileName = 'pizza.webp';
        break;
      case ThrowableObject.stone:
        fileName = 'stone.webp';
    }

    return join([_root, fileName]);
  }
}
