import 'dart:math';

/// An extension for the [num] class.
extension NumExtension on num {
  /// Constraints the num value between [a] and [b] inclusively.
  num minMax(num a, num b) => max(min(this, b), a);
}
