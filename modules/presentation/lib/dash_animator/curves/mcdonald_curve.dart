import 'dart:math';

import 'package:flutter/material.dart';

/// {@template McDonaldCurve}
///
/// An animation curve that moves in a double arc pattern which mimics the `M`
/// logo of McDonalds.
///
/// **NOTE:**
///
/// This curve interpolates the `t` value from `0`->`1`->`0`->`1`->`0`. Hence,
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
class McDonaldCurve extends Curve {
  /// {@macro McDonaldCurve}
  const McDonaldCurve();

  @override
  double transform(double t) => sin(t * pi * 2).abs();
}
