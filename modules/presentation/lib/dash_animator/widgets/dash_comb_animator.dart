import 'package:presentation/presentation.dart';

/// {@template DashCombAnimator}
///
/// A widget for animating Dash's comb.
///
/// {@endtemplate}
class DashCombAnimator extends StatelessWidget {
  /// {@macro DashCombAnimator}
  const DashCombAnimator({
    required this.animationState,
    required this.animation,
    required this.boundingSize,
    Key? key,
  }) : super(key: key);

  /// Dictates the animated pose of the comb.
  final DashAnimationState animationState;

  /// The [Animation] for moving the comb.
  final Animation<double> animation;

  /// The bounding box of Dash.
  ///
  /// This is used to determine the proportion of the comb.
  final double boundingSize;

  @override
  Widget build(BuildContext context) {
    const anchorPoint = FractionalOffset(0.5 / 12, 10 / 12);
    const alignment = FractionalOffset(5.9 / 12, 0.5 / 12);
    const maxRotation = 0.0;

    final Curve curve;
    final double minRotation;

    switch (animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.happy:
      case DashAnimationState.wave:
      case DashAnimationState.loser:
      case DashAnimationState.spellcast:
      case DashAnimationState.toss:
        curve = Curves.easeInOutSine;
        minRotation = -15;
        break;
      case DashAnimationState.excited:
        curve = Curves.easeInOutBack;
        minRotation = -20;
        break;
      case DashAnimationState.taunt:
      case DashAnimationState.wizardTaunt:
        curve = const McDonaldCurve();
        minRotation = -30;
        break;
      case DashAnimationState.wtf:
        curve = Curves.easeInOutSine;
        minRotation = 0;
        break;
      case DashAnimationState.wtfff:
        curve = Curves.easeOutBack;
        minRotation = -30;
        break;
    }

    return Align(
      alignment: alignment,
      child: SizedBox.square(
        dimension: boundingSize * 0.28,
        child: SyncedAnimatedRotation(
          animation: animation,
          curve: curve,
          minRotation: minRotation,
          maxRotation: maxRotation,
          anchorPoint: anchorPoint,
          child: Image.asset(DashSpriteAssets.comb),
        ),
      ),
    );
  }
}
