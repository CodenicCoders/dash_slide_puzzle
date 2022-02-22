import 'dart:math';

extension NumExtension on num {
  num minMax(num a, num b) => max(min(this, b), a);
}
