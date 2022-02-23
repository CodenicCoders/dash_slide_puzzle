import 'package:flutter/material.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/helpers/helpers.dart';

/// {@template DashHoverAnimator}
///
/// A widget for animating Dash hovering.
///
/// {@endtemplate}
class DashHoverAnimator extends StatelessWidget {
  /// {@macro DashHoverAnimator}
  const DashHoverAnimator({
    required this.animationState,
    required this.animation,
    required this.child,
    Key? key,
  }) : super(key: key);

  /// Dictates the animated pose of the body.
  final DashAnimationState animationState;

  /// The [Animation] for moving the body.
  final Animation<double> animation;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const startHoverOffset = Alignment.bottomCenter;

    final Alignment endHoverOffset;
    final Curve hoverCurve;
    final double minRotation;
    final double maxRotation;

    switch (animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.happy:
      case DashAnimationState.wave:
        endHoverOffset = Alignment.center;
        hoverCurve = Curves.easeInOutSine;
        minRotation = 0;
        maxRotation = 0;
        break;
      case DashAnimationState.taunt:
      case DashAnimationState.wizardTaunt:
        endHoverOffset = Alignment.topCenter;
        hoverCurve = const McDonaldCurve();
        minRotation = -10;
        maxRotation = 10;
        break;
      case DashAnimationState.excited:
        endHoverOffset = Alignment.topCenter;
        hoverCurve = Curves.easeInOutBack;
        minRotation = 0;
        maxRotation = 0;
        break;
      case DashAnimationState.wtf:
        endHoverOffset = Alignment.bottomCenter;
        hoverCurve = Curves.easeInOutSine;
        minRotation = 0;
        maxRotation = 0;
        break;
      case DashAnimationState.wtfff:
        endHoverOffset = Alignment.topCenter;
        hoverCurve = Curves.easeOutBack;
        minRotation = 0;
        maxRotation = 0;
        break;
      case DashAnimationState.loser:
      case DashAnimationState.toss:
      case DashAnimationState.spellcast:
        endHoverOffset = Alignment.center;
        hoverCurve = Curves.easeInOutSine;
        minRotation = -10;
        maxRotation = -10;
        break;
    }

    return SyncedAnimatedRotation(
      animation: animation,
      minRotation: minRotation,
      maxRotation: maxRotation,
      anchorPoint: Alignment.center,
      child: SyncedAnimatedAlign(
        startAlignment: startHoverOffset,
        endAlignment: endHoverOffset,
        animation: animation,
        curve: hoverCurve,
        child: child,
      ),
    );
  }
}
