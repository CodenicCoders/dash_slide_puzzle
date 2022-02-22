import 'package:flutter/material.dart';

/// {@template SyncedAnimatedScale}
///
/// A widget with support for animating its scale that smoothly syncs with
/// changing [Animation]s.
///
/// {@endtemplate}
class SyncedAnimatedScale extends AnimatedWidget {
  /// {@macro SyncedAnimatedScale}
  const SyncedAnimatedScale({
    required this.startScale,
    required this.endScale,
    required this.child,
    required Animation<double> animation,
    this.curve = Curves.linear,
    Key? key,
  }) : super(key: key, listenable: animation);

  final double startScale;
  final double endScale;
  final Widget child;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    final newScale = Tween(begin: startScale, end: endScale)
        .transform(curve.transform(animation.value));

    return AnimatedScale(
      scale: newScale,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
