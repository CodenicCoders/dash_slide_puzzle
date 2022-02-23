import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';

/// Contains all the throwable objects that can be thrown by Dash.
enum ThrowableObject {
  /// Dash throws a pizza.
  pizza,

  /// Dash throws a stone.
  stone,
}

/// {@template ObjectThrowAnimator}
///
/// A widget for rendering an object throw animation.
///
/// {@endtemplate}
class ObjectThrowAnimator extends StatefulWidget {
  /// {@macro ObjectThrowAnimator}
  const ObjectThrowAnimator({
    required this.startObject,
    required this.endObject,
    required this.throwableObject,
    required this.preThrowDuration,
    required this.throwDuration,
    required this.postThrowDuration,
    required this.inOutAnimationDuration,
    this.trajectoryCoefficient = 0.75,
    Key? key,
  })  : assert(
          trajectoryCoefficient >= 0 && trajectoryCoefficient <= 1,
          'The trajectory coefficient must be between the values of 0 and 1',
        ),
        super(key: key);

  /// The duration wherein the objects stays in the [startObject] before it
  /// is thrown.
  final Duration preThrowDuration;

  /// The duration wherein the object stays in the [endObject] before it
  /// disappears.
  final Duration postThrowDuration;

  /// The time it takes for the object to travel from the [startObject] to
  /// the [endObject].
  final Duration throwDuration;

  /// The [Duration] for the throwable object's appearing or disappearing
  /// animation.
  final Duration inOutAnimationDuration;

  /// The start position of the [throwableObject].
  final GlobalKey startObject;

  /// The end position of the [throwableObject].
  final GlobalKey endObject;

  /// The object to throw.
  final ThrowableObject throwableObject;

  /// A value for adjusting the trajectory of the object as it moves from the
  /// [startObject] to the [endObject].
  ///
  /// This must contain a value between `0` and `1` inclusively.
  ///
  /// A value of `1` represents the highest allowable trajectory.
  ///
  /// A value of `0` implies that there is no trajectory and the object will
  /// move in a linear path.
  final double trajectoryCoefficient;

  @override
  State<ObjectThrowAnimator> createState() => _ObjectThrowAnimatorState();
}

class _ObjectThrowAnimatorState extends State<ObjectThrowAnimator>
    with TickerProviderStateMixin {
  late final AnimationController _inOutAnimation;
  late final AnimationController _preThrowAnimation;
  late final AnimationController _throwAnimation;
  late final AnimationController _postThrowAnimation;

  // The position of the throwable object in the X-plane.
  double _throwableObjectDx = 0;

  /// The position of the throwable object in the Y-plane.
  double _throwableObjectDy = 0;

  /// The size of the throwable object.
  double _throwableObjectSize = 0;

  /// Calculates the new [_throwableObjectDx] and [_throwableObjectDy]
  /// properties based on the [t] animation value.
  void _updateStates({required double t, bool callSetState = true}) {
    final startRenderBox =
        widget.startObject.currentContext?.findRenderObject() as RenderBox?;

    final endRenderBox =
        widget.endObject.currentContext?.findRenderObject() as RenderBox?;

    if (startRenderBox == null || endRenderBox == null) {
      return;
    }

    // Determine the size of the throwable object proportional to the start
    // object
    _throwableObjectSize = startRenderBox.size.shortestSide * 0.4;

    final startPosition = startRenderBox.localToGlobal(Offset.zero);
    final endPosition = endRenderBox.localToGlobal(Offset.zero);

    /// The offset for the throwable object to center it in its bounding box
    final offset = _throwableObjectSize / 2.2;

    final x1 = startPosition.dx;
    final y1 = startPosition.dy;

    final x2 = endPosition.dx;
    final y2 = endPosition.dy;

    final midY = y2 + y1 / 2;

    final baseHeight = midY - midY * widget.trajectoryCoefficient;

    final leftHeight = y1 - baseHeight;
    final rightHeight = y2 - baseHeight;

    _throwableObjectDx = (x2 - x1) * t + x1 - offset;

    final leftAligned = _throwableObjectDx - x1 <= x2 - _throwableObjectDx;
    final preferredHeight =
        leftAligned ? leftHeight + offset : rightHeight - offset;

    final dy = preferredHeight * (1 - sin(pi * t));

    _throwableObjectDy = dy + baseHeight;

    if (callSetState) setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _inOutAnimation = AnimationController(
      vsync: this,
      duration: widget.inOutAnimationDuration,
    )
      ..addListener(
        () {
          if (_inOutAnimation.status == AnimationStatus.forward) {
            _updateStates(t: 0);
          } else if (_inOutAnimation.status == AnimationStatus.reverse) {
            _updateStates(t: 1);
          }
        },
      )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _preThrowAnimation.forward();
        }
      })
      ..forward();

    _preThrowAnimation = AnimationController(
      vsync: this,
      duration: widget.preThrowDuration,
    )
      ..addListener(() => _updateStates(t: 0))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _throwAnimation.forward();
        }
      });

    _throwAnimation = AnimationController(
      vsync: this,
      duration: widget.throwDuration,
    )
      ..addListener(() => _updateStates(t: _throwAnimation.value))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _postThrowAnimation.forward();
        }
      });

    _postThrowAnimation = AnimationController(
      vsync: this,
      duration: widget.postThrowDuration,
    )
      ..addListener(() => _updateStates(t: 1))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _inOutAnimation.reverse();
        }
      });
  }

  @override
  void dispose() {
    _inOutAnimation.dispose();
    _preThrowAnimation.dispose();
    _throwAnimation.dispose();
    _postThrowAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _throwableObjectDx,
          top: _throwableObjectDy,
          child: Transform.scale(
            scale: _inOutAnimation.value,
            child: SizedBox.square(
              dimension: _throwableObjectSize,
              child: Image.asset(
                ThrowableAssets.throwable(widget.throwableObject),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
