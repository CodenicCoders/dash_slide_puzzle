import 'package:path/path.dart' as p;
import 'package:presentation/dash_animator/widgets/widgets.dart';

class ThrowableAssets {
  const ThrowableAssets._();

  static final _root =
      p.join('packages', 'presentation', 'assets', 'images', 'throwables');

  static String image(ThrowableObject throwable) {
    final String fileName;

    switch (throwable) {
      case ThrowableObject.pizza:
        fileName = 'pizza.webp';
        break;
      case ThrowableObject.stone:
        fileName = 'stone.webp';
    }

    return p.join(_root, fileName);
  }
}
