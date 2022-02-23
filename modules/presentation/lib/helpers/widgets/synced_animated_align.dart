import 'package:flutter/material.dart';

/// {@template SyncedAnimatedAlign}
///
/// A widget with support for animating its aligned position that smoothly
/// syncs with a new [startAlignment] or [endAlignment].
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

  /// The start alignment of the [child].
  final Alignment startAlignment;

  /// The end alignment of the [child].
  final Alignment endAlignment;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The animation curve.
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
