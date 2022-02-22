import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/helpers/helpers.dart';
import 'package:simple_shadow/simple_shadow.dart';

/// {@template DashWandAnimator}
///
/// A widget for animating Dash's wand when casting a time-reversal spell.
///
/// {@endtemplate}
class DashWandAnimator extends StatelessWidget {
  /// {@macro DashWandAnimator}
  const DashWandAnimator({
    required this.animationState,
    required this.animation,
    required this.boundingSize,
    Key? key,
  }) : super(key: key);

  final DashAnimationState animationState;
  final Animation<double> animation;
  final double boundingSize;

  @override
  Widget build(BuildContext context) {
    const alignment = FractionalOffset(-7 / 12, 4 / 12);
    const anchorPoint = Alignment.bottomRight;

    final bool showWand;
    final double minRotation;
    final double maxRotation;
    final Curve rotationCurve;
    final Curve wandGlowCurve;

    switch (animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.toss:
      case DashAnimationState.happy:
      case DashAnimationState.taunt:
      case DashAnimationState.excited:
      case DashAnimationState.wtf:
      case DashAnimationState.wtfff:
      case DashAnimationState.loser:
      case DashAnimationState.wave:
        showWand = false;
        minRotation = -30.0;
        maxRotation = 0.0;
        rotationCurve = Curves.easeInOutBack;
        wandGlowCurve = const ArcCurve();
        break;
      case DashAnimationState.spellcast:
        showWand = true;
        minRotation = -30.0;
        maxRotation = 0.0;
        rotationCurve = Curves.easeInOutBack;
        wandGlowCurve = const ArcCurve();
        break;
      case DashAnimationState.wizardTaunt:
        showWand = true;
        minRotation = 0;
        maxRotation = 30;
        rotationCurve = const McDonaldCurve();
        wandGlowCurve = const McDonaldCurve();
        break;
    }

    return SyncedAnimatedAlign(
      startAlignment: alignment,
      endAlignment: alignment,
      animation: animation,
      child: SizedBox.square(
        dimension: boundingSize * 0.45,
        child: SyncedAnimatedRotation(
          animation: animation,
          curve: rotationCurve,
          minRotation: minRotation,
          maxRotation: maxRotation,
          anchorPoint: anchorPoint,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: SlideTransition(
                  position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(animation),
                  child: child,
                ),
              );
            },
            child: showWand
                ? _Wand(
                    animation: CurvedAnimation(
                      parent: animation,
                      curve: wandGlowCurve,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _Wand extends AnimatedWidget {
  const _Wand({required Animation<double> animation, Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return SimpleShadow(
      color: Colors.white,
      sigma: max(192 * (1 - animation.value), 2),
      opacity: 1,
      offset: Offset.zero,
      child: Image.asset(
        DashSpriteAssets.wand,
        key: ValueKey(DashSpriteAssets.wand),
      ),
    );
  }
}
