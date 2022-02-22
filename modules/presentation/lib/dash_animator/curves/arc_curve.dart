import 'dart:math';

import 'package:flutter/material.dart';

/// {@template ArcCurve}
///
/// An animation curve that moves in an arc pattern.
///
/// **NOTE:**
///
/// This curve interpolates the `t` value from `0`->`1`->`0`. Hence,
/// it is advisable to avoid using this directly inside a `CurvedAnimation` or
/// risk receiving the exception `Invalid curve endpoint at 1.0`
/// (See: https://github.com/xPutnikx/flutter-passcode/issues/23).
/// Instead, use the `transform` method to convert the [Animation.value] to the
/// desired `t` value.
///
/// ```dart
/// final t = ArcCurve().transform(animation.value);
/// ```
///
/// {@endtemplate}
class ArcCurve extends Curve {
  /// {@macro ArcCurve}
  const ArcCurve();

  @override
  double transform(double t) => sin(t * pi);
}
