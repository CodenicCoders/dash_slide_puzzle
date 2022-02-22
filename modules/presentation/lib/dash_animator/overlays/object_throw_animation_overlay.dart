import 'package:application/application.dart';
import 'package:flutter/material.dart';
import 'package:presentation/dash_animator/widgets/widgets.dart';

/// Renders the [ObjectThrowAnimator] widget in an overlay.
class ObjectThrowAnimationOverlay {
  ObjectThrowAnimationOverlay._();

  /// See [ObjectThrowAnimator].
  static void throwObject({
    required BuildContext context,
    required ThrowableObject throwableObject,
    required GlobalKey startObject,
    required GlobalKey endObject,
    Duration throwDuration = const Duration(milliseconds: 900),
    Duration preThrowDuration = Duration.zero,
    Duration postThrowDuration = const Duration(milliseconds: 3850),
    Duration inOutAnimationDuration = const Duration(milliseconds: 100),
  }) {
    final overlayEntry = OverlayEntry(
      builder: (context) => ObjectThrowAnimator(
        throwableObject: throwableObject,
        startObject: startObject,
        endObject: endObject,
        preThrowDuration: preThrowDuration,
        throwDuration: throwDuration,
        postThrowDuration: postThrowDuration,
        inOutAnimationDuration: inOutAnimationDuration,
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);

    final totalDuration = throwDuration.addAll([
      preThrowDuration,
      postThrowDuration,
      inOutAnimationDuration,
      inOutAnimationDuration, // Add this twice for the in and out animation
    ]);

    Future.delayed(totalDuration, overlayEntry.remove);
  }
}
