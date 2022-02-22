import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/helpers/helpers.dart';

/// {@template DashBodyAnimator}
///
/// A widget for animating Dash's plump body.
///
/// {@endtemplate}
class DashBodyAnimator extends StatelessWidget {
  /// {@macro DashBodyAnimator}
  const DashBodyAnimator({
    required this.animationState,
    required this.animation,
    required this.boundingSize,
    required this.dashBody,
    Key? key,
  }) : super(key: key);

  final DashAnimationState animationState;
  final Animation<double> animation;
  final double boundingSize;
  final DashBody dashBody;

  @override
  Widget build(BuildContext context) {
    const alignment = FractionalOffset(5 / 12, 9 / 12);
    const startScale = 1.0;
    const endScale = 0.96;

    final Curve curve;

    final DashBody preferredDashBody;

    switch (animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.toss:
      case DashAnimationState.happy:
      case DashAnimationState.wtf:
      case DashAnimationState.wtfff:
      case DashAnimationState.loser:
      case DashAnimationState.wave:
        curve = Curves.easeIn;
        preferredDashBody = dashBody;
        break;
      case DashAnimationState.taunt:
      case DashAnimationState.excited:
        curve = const McDonaldCurve();
        preferredDashBody = dashBody;
        break;
      case DashAnimationState.wizardTaunt:
        curve = const McDonaldCurve();
        preferredDashBody = DashBody.wizardRobe;
        break;
      case DashAnimationState.spellcast:
        curve = Curves.easeIn;
        preferredDashBody = DashBody.wizardRobe;
        break;
    }

    return Align(
      alignment: alignment,
      child: SizedBox.square(
        dimension: boundingSize,
        child: SyncedAnimatedScale(
          animation: animation,
          curve: curve,
          startScale: startScale,
          endScale: endScale,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 600),
            switchOutCurve: Curves.easeOutExpo,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, child: child),
              );
            },
            child: Image.asset(
              DashSpriteAssets.body(preferredDashBody),
              key: ValueKey(preferredDashBody),
            ),
          ),
        ),
      ),
    );
  }
}
