import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/dash_animator/dash_animator.dart';

enum DashAnimationState {
  idle,
  happy,
  toss,
  taunt,
  excited,
  wtf,
  wtfff,
  loser,
  wave,
  spellcast,
  wizardTaunt,
}

class DashAnimator extends StatefulWidget {
  const DashAnimator({
    this.animationLength = const Duration(seconds: 2),
    this.animationState = DashAnimationState.idle,
    this.dashBody = DashBody.nude,
    this.dashDevice = DashDevice.cyanLaptop,
    Key? key,
  }) : super(key: key);

  /// The time it takes for the animation to interpolate from `0` to `1`.
  final Duration animationLength;

  final DashAnimationState animationState;

  final DashBody dashBody;
  final DashDevice dashDevice;

  @override
  State<DashAnimator> createState() => DashAnimatorState();
}

class DashAnimatorState extends State<DashAnimator>
    with SingleTickerProviderStateMixin {
  final _rightWingAnimatorKey = GlobalKey<DashRightWingAnimatorState>();
  final _leftWingAnimatorKey = GlobalKey<DashLeftWingAnimatorState>();

  late final _animation =
      AnimationController(duration: widget.animationLength, vsync: this)
        ..repeat(reverse: true);

  GlobalKey? get rightWingKey => _rightWingAnimatorKey.currentState?.wingKey;

  GlobalKey? get leftWingKey => _leftWingAnimatorKey.currentState?.wingKey;

  void throwPizza(GlobalKey target) {
    ObjectThrowAnimationOverlay.throwObject(
      context: context,
      throwableObject: ThrowableObject.pizza,
      startObject: _leftWingAnimatorKey,
      endObject: target,
    );
  }

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
                        dashBody: widget.dashBody,
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
                        dashDevice: widget.dashDevice,
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
