import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/helpers/helpers.dart';

/// {@template DashDeviceAnimator}
///
/// A widget for animating Dash's device.
///
/// {@endtemplate}
class DashDeviceAnimator extends StatelessWidget {
  /// {@macro DashDeviceAnimator}
  const DashDeviceAnimator({
    required this.animationState,
    required this.animation,
    required this.boundingSize,
    required this.dashDevice,
    Key? key,
  }) : super(key: key);

  final DashAnimationState animationState;
  final Animation<double> animation;
  final double boundingSize;
  final DashDevice dashDevice;

  @override
  Widget build(BuildContext context) {
    final Alignment anchorPoint;
    final Alignment alignment;
    final double minRotation;
    final double maxRotation;
    final Curve curve;

    final bool showDevice;

    switch (animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.toss:
      case DashAnimationState.happy:
      case DashAnimationState.spellcast:
        showDevice = true;
        anchorPoint = const FractionalOffset(1.5 / 4, 1 / 4);
        alignment = const FractionalOffset(14.5 / 12, 8.5 / 12);
        minRotation = 7;
        maxRotation = -7;
        curve = const ArcCurve();
        break;
      case DashAnimationState.taunt:
      case DashAnimationState.wizardTaunt:
      case DashAnimationState.excited:
        showDevice = true;
        anchorPoint = Alignment.centerLeft;
        alignment = const FractionalOffset(16.5 / 12, 5 / 12);
        minRotation = -15;
        maxRotation = 15;
        curve = const McDonaldCurve();
        break;
      case DashAnimationState.wtf:
        showDevice = true;
        anchorPoint = const FractionalOffset(1.5 / 4, 1 / 4);
        alignment = const FractionalOffset(20 / 12, 12 / 12);
        minRotation = 0;
        maxRotation = 0;
        curve = const ArcCurve();
        break;
      case DashAnimationState.wtfff:
        showDevice = true;
        anchorPoint = const FractionalOffset(1.5 / 4, 1 / 4);
        alignment = const FractionalOffset(13 / 12, 9.5 / 12);
        minRotation = -90;
        maxRotation = -30;
        curve = const McDonaldCurve();
        break;
      case DashAnimationState.loser:
        showDevice = true;
        anchorPoint = const FractionalOffset(1 / 4, 3 / 4);
        alignment = const FractionalOffset(17 / 12, 10 / 12);
        minRotation = 75;
        maxRotation = 90;
        curve = const ArcCurve();
        break;
      case DashAnimationState.wave:
        showDevice = false;
        anchorPoint = Alignment.center;
        alignment = Alignment.center;
        minRotation = 0;
        maxRotation = 0;
        curve = const ArcCurve();
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
          curve: curve,
          minRotation: minRotation,
          maxRotation: maxRotation,
          anchorPoint: anchorPoint,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(animation),
                  child: child,
                ),
              );
            },
            child: showDevice
                ? Image.asset(
                    DashSpriteAssets.device(dashDevice),
                    key: ValueKey(dashDevice),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
