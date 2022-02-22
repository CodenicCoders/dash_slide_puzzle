import 'dart:math';

import 'package:flutter/material.dart';

/// {@template SyncedAnimatedRotation}
///
/// A widget with support for animating its rotation that smoothly syncs with
/// changing [Animation]s.
///
/// {@endtemplate}
class SyncedAnimatedRotation extends AnimatedWidget {
  /// {@macro SyncedAnimatedRotation}
  const SyncedAnimatedRotation({
    required this.child,
    required this.minRotation,
    required this.maxRotation,
    required this.anchorPoint,
    required Animation<double> animation,
    this.curve = Curves.linear,
    Key? key,
  }) : super(key: key, listenable: animation);

  /// The max rotation in degrees.
  final double maxRotation;

  /// The min rotation in degrees.
  final double minRotation;

  /// See [AnimatedContainer.transformAlignment].
  final AlignmentGeometry anchorPoint;

  final Curve curve;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    final newRotation = Tween(begin: minRotation, end: maxRotation)
        .transform(curve.transform(animation.value));

    // final newRotation =
    //     Tween(begin: minRotation, end: maxRotation).evaluate(animation);

    return AnimatedContainer(
      transformAlignment: anchorPoint,
      transform: Matrix4.rotationZ(newRotation * pi / 180),
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
