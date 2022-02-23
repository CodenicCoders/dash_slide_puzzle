import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/helpers/helpers.dart';

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

  /// Dictates the animated pose of the wand.
  final DashAnimationState animationState;

  /// The [Animation] for moving the wand.
  final Animation<double> animation;

  /// The bounding box of Dash.
  ///
  /// This is used to determine the proportion of the wand.
  final double boundingSize;

  @override
  Widget build(BuildContext context) {
    const alignment = FractionalOffset(-7 / 12, 4 / 12);
    const anchorPoint = Alignment.bottomRight;

    final bool showWand;
    final double minRotation;
    final double maxRotation;
    final Curve rotationCurve;

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
        break;
      case DashAnimationState.spellcast:
        showWand = true;
        minRotation = -30.0;
        maxRotation = 0.0;
        rotationCurve = Curves.easeInOutBack;
        break;
      case DashAnimationState.wizardTaunt:
        showWand = true;
        minRotation = 0;
        maxRotation = 30;
        rotationCurve = const McDonaldCurve();
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
                ? Image.asset(
                    DashSpriteAssets.wand,
                    key: ValueKey(DashSpriteAssets.wand),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
