import 'package:presentation/presentation.dart';

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

  /// Dictates the animated pose of the body.
  final DashAnimationState animationState;

  /// The [Animation] for moving the body.
  final Animation<double> animation;

  /// The bounding box of Dash.
  /// 
  /// This is used to determine the proportion of the body.
  final double boundingSize;

  /// The clothing for the body.
  final DashBody dashBody;

  @override
  Widget build(BuildContext context) {
    const alignment = FractionalOffset(5 / 12, 9 / 12);
    final DashBody preferredDashBody;

    switch (animationState) {
      case DashAnimationState.idle:
      case DashAnimationState.toss:
      case DashAnimationState.happy:
      case DashAnimationState.wtf:
      case DashAnimationState.wtfff:
      case DashAnimationState.loser:
      case DashAnimationState.wave:
        preferredDashBody = dashBody;
        break;
      case DashAnimationState.taunt:
      case DashAnimationState.excited:
        preferredDashBody = dashBody;
        break;
      case DashAnimationState.wizardTaunt:
        preferredDashBody = DashBody.wizardRobe;
        break;
      case DashAnimationState.spellcast:
        preferredDashBody = DashBody.wizardRobe;
        break;
    }

    return Align(
      alignment: alignment,
      child: SizedBox.square(
        dimension: boundingSize,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 600),
          switchOutCurve: Curves.easeOutExpo,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(sizeFactor: animation, child: child),
          ),
          child: Image.asset(
            DashSpriteAssets.body(preferredDashBody),
            key: ValueKey(preferredDashBody),
          ),
        ),
      ),
    );
  }
}
