import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/helpers/helpers.dart';

/// {@template DashLeftWingAnimator}
///
/// A widget for animating Dash's left wing.
///
/// {@endtemplate}
class DashLeftWingAnimator extends StatefulWidget {
  /// {@macro DashLeftWingAnimator}
  const DashLeftWingAnimator({
    required this.animationState,
    required this.animation,
    required this.boundingSize,
    Key? key,
  }) : super(key: key);

  final DashAnimationState animationState;
  final Animation<double> animation;
  final double boundingSize;

  @override
  State<DashLeftWingAnimator> createState() => DashLeftWingAnimatorState();
}

class DashLeftWingAnimatorState extends State<DashLeftWingAnimator> {
  final wingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Alignment alignment;
    final double minRotation;
    final double maxRotation;
    final Curve curve;

    switch (widget.animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.happy:
      case DashAnimationState.wave:
      case DashAnimationState.toss:
      case DashAnimationState.spellcast:
        alignment = const FractionalOffset(13 / 12, 10.25 / 12);
        minRotation = 0;
        maxRotation = -15;
        curve = const ArcCurve();
        break;
      case DashAnimationState.taunt:
      case DashAnimationState.wizardTaunt:
      case DashAnimationState.excited:
        alignment = const FractionalOffset(13 / 12, 9.5 / 12);
        minRotation = -90;
        maxRotation = -60;
        curve = const McDonaldCurve();
        break;
      case DashAnimationState.wtf:
        alignment = const FractionalOffset(13 / 12, 10.25 / 12);
        minRotation = 0;
        maxRotation = -15;
        curve = const ArcCurve();
        break;
      case DashAnimationState.wtfff:
        alignment = const FractionalOffset(13 / 12, 9.5 / 12);
        minRotation = -90;
        maxRotation = -30;
        curve = const McDonaldCurve();
        break;
      case DashAnimationState.loser:
        alignment = const FractionalOffset(13 / 12, 12 / 12);
        minRotation = 0;
        maxRotation = 15;
        curve = const ArcCurve();
        break;
    }

    return SyncedAnimatedAlign(
      startAlignment: alignment,
      endAlignment: alignment,
      animation: widget.animation,
      child: SizedBox.square(
        dimension: widget.boundingSize * 0.31,
        child: SyncedAnimatedRotation(
          animation: widget.animation,
          curve: curve,
          minRotation: minRotation,
          maxRotation: maxRotation,
          anchorPoint: const FractionalOffset(1.5 / 4, 1 / 4),
          child: Image.asset(DashSpriteAssets.leftWing, key: wingKey),
        ),
      ),
    );
  }
}
