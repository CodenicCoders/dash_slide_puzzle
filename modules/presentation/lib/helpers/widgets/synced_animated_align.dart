import 'package:flutter/material.dart';

/// {@template SyncedAnimatedAlign}
///
/// A widget with support for animating its aligned position that smoothly
/// syncs with changing [Animation]s.
///
/// {@endtemplate}
class SyncedAnimatedAlign extends AnimatedWidget {
  /// {@macro SyncedAnimatedAlign}
  const SyncedAnimatedAlign({
    required this.startAlignment,
    required this.endAlignment,
    required this.child,
    required Animation<double> animation,
    this.curve = Curves.linear,
    Key? key,
  }) : super(key: key, listenable: animation);

  final Alignment startAlignment;

  final Alignment endAlignment;

  final Widget child;

  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    final newAlignment = Tween(begin: startAlignment, end: endAlignment)
        .transform(curve.transform(animation.value));

    return AnimatedAlign(
      alignment: newAlignment,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
