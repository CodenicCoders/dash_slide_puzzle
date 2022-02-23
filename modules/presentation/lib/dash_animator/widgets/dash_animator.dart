import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation/dash_animator/dash_animator.dart';

/// Contains all the available animation states of Dash.
enum DashAnimationState {
  /// Dash's idle pose.
  idle,

  /// Dash's happy pose.
  happy,

  /// Dash's throwing pose.
  toss,

  /// Dash's taunting pose.
  taunt,

  /// Dash's excited pose.
  excited,

  /// Dash's skeptic pose.
  wtf,

  /// Dash's shocked pose.
  wtfff,

  /// Dash's pose when losing.
  loser,

  /// Dash's waving pose.
  wave,

  /// Dash's pose when casting a spell.
  spellcast,

  /// Dash's taunting pose in wizard uniform.
  wizardTaunt,
}

/// {@template DashAnimator}
///
/// The root animator of Dash.
///
/// {@endtemplate}
class DashAnimator extends StatefulWidget {
  /// {@macro DashAnimator}
  const DashAnimator({
    required this.dashAttire,
    this.animationLength = const Duration(seconds: 2),
    this.animationState = DashAnimationState.idle,
    Key? key,
  }) : super(key: key);

  /// The attire of Dash.
  final DashAttire dashAttire;

  /// The time it takes for the animation to interpolate from `0` to `1`.
  final Duration animationLength;

  /// The pose of Dash.
  final DashAnimationState animationState;

  @override
  State<DashAnimator> createState() => DashAnimatorState();
}

/// The state of [DashAnimator].
class DashAnimatorState extends State<DashAnimator>
    with SingleTickerProviderStateMixin {
  final _rightWingAnimatorKey = GlobalKey<DashRightWingAnimatorState>();
  final _leftWingAnimatorKey = GlobalKey<DashLeftWingAnimatorState>();

  late final _animation =
      AnimationController(duration: widget.animationLength, vsync: this)
        ..repeat(reverse: true);

  /// A key assigned to the right wing of this Dash animator.
  GlobalKey? get rightWingKey => _rightWingAnimatorKey.currentState?.wingKey;

  /// A key assigned to the left wing of this Dash animator.
  GlobalKey? get leftWingKey => _leftWingAnimatorKey.currentState?.wingKey;

  /// Dash throws a pizza precisely at the [target] widget.
  void throwPizza(GlobalKey target) {
    ObjectThrowAnimationOverlay.throwObject(
      context: context,
      throwableObject: ThrowableObject.pizza,
      startObject: _leftWingAnimatorKey,
      endObject: target,
    );
  }

  /// Dash throws a stone precisely at the [target] widget.
  void throwStone(GlobalKey target) {
    ObjectThrowAnimationOverlay.throwObject(
      context: context,
      throwableObject: ThrowableObject.stone,
      startObject: _leftWingAnimatorKey,
      endObject: target,
      postThrowDuration: Duration.zero,
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimension = min(constraints.maxWidth, constraints.maxHeight);

        // The size of Dash within the dimension
        // The bounding size should be less than the dimension to allow Dash to
        // hover
        final boundingSize = dimension * 0.75;

        return SizedBox.square(
          dimension: dimension,
          child: Stack(
            children: [
              DashHoverAnimator(
                animationState: widget.animationState,
                animation: _animation,
                child: SizedBox.square(
                  dimension: boundingSize,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      DashRightWingAnimator(
                        key: _rightWingAnimatorKey,
                        animationState: widget.animationState,
                        animation: _animation,
                        boundingSize: boundingSize,
                      ),
                      DashWandAnimator(
                        animationState: widget.animationState,
                        animation: _animation,
                        boundingSize: boundingSize,
                      ),
                      DashCombAnimator(
                        animationState: widget.animationState,
                        animation: _animation,
                        boundingSize: boundingSize,
                      ),
                      DashTailAnimator(
                        animationState: widget.animationState,
                        animation: _animation,
                        boundingSize: boundingSize,
                      ),
                      DashBodyAnimator(
                        animationState: widget.animationState,
                        animation: _animation,
                        boundingSize: boundingSize,
                        dashBody: widget.dashAttire.dashBody,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: DashFaceAnimator(
                          animationState: widget.animationState,
                          boundingSize: boundingSize,
                        ),
                      ),
                      DashLeftWingAnimator(
                        key: _leftWingAnimatorKey,
                        animationState: widget.animationState,
                        animation: _animation,
                        boundingSize: boundingSize,
                      ),
                      DashDeviceAnimator(
                        animationState: widget.animationState,
                        animation: _animation,
                        boundingSize: boundingSize,
                        dashDevice: widget.dashAttire.dashDevice,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
