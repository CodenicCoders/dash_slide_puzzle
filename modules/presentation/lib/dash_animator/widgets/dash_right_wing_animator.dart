import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/helpers/helpers.dart';

/// {@template DashRightWingAnimator}
///
/// A widget for animating Dash's right wing.
///
/// {@endtemplate}
class DashRightWingAnimator extends StatefulWidget {
  /// {@macro DashRightWingAnimator}
  const DashRightWingAnimator({
    required this.animationState,
    required this.animation,
    required this.boundingSize,
    Key? key,
  }) : super(key: key);

  final DashAnimationState animationState;
  final Animation<double> animation;
  final double boundingSize;

  @override
  State<DashRightWingAnimator> createState() => DashRightWingAnimatorState();
}

class DashRightWingAnimatorState extends State<DashRightWingAnimator> {
  final wingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const rightWingAlignment = FractionalOffset(-2 / 12, 8 / 12);

    final double minRotation;
    final double maxRotation;
    final Curve curve;

    switch (widget.animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.happy:
        minRotation = 0;
        maxRotation = 30;
        curve = const ArcCurve();
        break;
      case DashAnimationState.spellcast:
        minRotation = -30;
        maxRotation = 0;
        curve = Curves.easeInOutBack;
        break;
      case DashAnimationState.taunt:
      case DashAnimationState.wizardTaunt:
        minRotation = 0;
        maxRotation = 30;
        curve = const McDonaldCurve();
        break;
      case DashAnimationState.excited:
        minRotation = 30;
        maxRotation = 30;
        curve = const McDonaldCurve();
        break;
      case DashAnimationState.wtf:
        minRotation = 0;
        maxRotation = 15;
        curve = const ArcCurve();
        break;
      case DashAnimationState.wtfff:
        minRotation = 30;
        maxRotation = -30;
        curve = const McDonaldCurve();
        break;
      case DashAnimationState.loser:
        minRotation = -30;
        maxRotation = -45;
        curve = const ArcCurve();
        break;
      case DashAnimationState.wave:
        minRotation = 60;
        maxRotation = 30;
        curve = const ArcCurve();
        break;
      case DashAnimationState.toss:
        minRotation = -45;
        maxRotation = -45;
        curve = const McDonaldCurve();
        break;
    }

    return Align(
      alignment: rightWingAlignment,
      child: SizedBox.square(
        dimension: widget.boundingSize * 0.31,
        child: SyncedAnimatedRotation(
          animation: widget.animation,
          curve: curve,
          minRotation: minRotation,
          maxRotation: maxRotation,
          anchorPoint: const FractionalOffset(3.5 / 4, 1.75 / 4),
          child: Image.asset(DashSpriteAssets.rightWing, key: wingKey),
        ),
      ),
    );
  }
}
