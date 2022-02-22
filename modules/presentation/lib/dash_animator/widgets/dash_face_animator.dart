import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/widgets/widgets.dart';

/// {@template DashFaceAnimator}
///
/// A widget for animating Dash's plump face.
///
/// {@endtemplate}
class DashFaceAnimator extends StatelessWidget {
  /// {@macro DashFaceAnimator}
  const DashFaceAnimator({
    required this.animationState,
    required this.boundingSize,
    Key? key,
  }) : super(key: key);

  final DashAnimationState animationState;
  final double boundingSize;

  @override
  Widget build(BuildContext context) {
    const alignment = FractionalOffset(5 / 12, 8 / 12);

    final DashFace face;

    switch (animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.toss:
        face = DashFace.normal;
        break;
      case DashAnimationState.happy:
      case DashAnimationState.taunt:
      case DashAnimationState.wave:
        face = DashFace.happy;
        break;
      case DashAnimationState.wizardTaunt:
        face = DashFace.happyWizard;
        break;
      case DashAnimationState.excited:
        face = DashFace.kawaii;
        break;
      case DashAnimationState.wtf:
        face = DashFace.wtf;
        break;
      case DashAnimationState.wtfff:
        face = DashFace.wtfff;
        break;
      case DashAnimationState.loser:
        face = DashFace.sad;
        break;
      case DashAnimationState.spellcast:
        face = DashFace.wizard;
    }

    return Align(
      alignment: alignment,
      child: SizedBox.square(
        dimension: boundingSize * 0.6,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Image.asset(DashSpriteAssets.face(face), key: ValueKey(face)),
        ),
      ),
    );
  }
}
