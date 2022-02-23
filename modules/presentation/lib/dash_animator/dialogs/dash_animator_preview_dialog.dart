import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:presentation/presentation.dart';

/// A pop-up dialog for viewing and playing around with the Dash animator.
class DashAnimatorPreviewDialog {
  DashAnimatorPreviewDialog._();

  /// Shows the dialog.
  static void show({required BuildContext context}) {
    final focusNode = FocusNode();

    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 200),
      builder: (context) {
        var dashAttire = DashAttire.generate([DashBody.wizardRobe]);
        var animationState = DashAnimationState.idle;

        return StatefulBuilder(
          builder: (context, setState) {
            return RawKeyboardListener(
              autofocus: true,
              focusNode: focusNode,
              onKey: (keyEvent) {
                if (keyEvent is RawKeyDownEvent) {
                  final physicalKey = keyEvent.data.physicalKey;

                  if (physicalKey == PhysicalKeyboardKey.space) {
                    setState(
                      () => dashAttire = DashAttire.generate(
                        [dashAttire.dashBody, DashBody.wizardRobe],
                      ),
                    );
                  } else if (physicalKey == PhysicalKeyboardKey.backquote) {
                    setState(() => animationState = DashAnimationState.idle);
                  } else if (physicalKey == PhysicalKeyboardKey.digit1) {
                    setState(() => animationState = DashAnimationState.happy);
                  } else if (physicalKey == PhysicalKeyboardKey.digit2) {
                    setState(() => animationState = DashAnimationState.toss);
                  } else if (physicalKey == PhysicalKeyboardKey.digit3) {
                    setState(() => animationState = DashAnimationState.taunt);
                  } else if (physicalKey == PhysicalKeyboardKey.digit4) {
                    setState(() => animationState = DashAnimationState.excited);
                  } else if (physicalKey == PhysicalKeyboardKey.digit5) {
                    setState(() => animationState = DashAnimationState.wtf);
                  } else if (physicalKey == PhysicalKeyboardKey.digit6) {
                    setState(() => animationState = DashAnimationState.wtfff);
                  } else if (physicalKey == PhysicalKeyboardKey.digit7) {
                    setState(() => animationState = DashAnimationState.loser);
                  } else if (physicalKey == PhysicalKeyboardKey.digit8) {
                    setState(() => animationState = DashAnimationState.wave);
                  } else if (physicalKey == PhysicalKeyboardKey.digit9) {
                    setState(
                      () => animationState = DashAnimationState.spellcast,
                    );
                  } else if (physicalKey == PhysicalKeyboardKey.digit0) {
                    setState(
                      () => animationState = DashAnimationState.wizardTaunt,
                    );
                  }
                }
              },
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    const dashAnimationStates = DashAnimationState.values;

                    final oldDashAnimationStateIndex =
                        dashAnimationStates.indexOf(animationState);

                    final newDashAnimationStateIndex =
                        (oldDashAnimationStateIndex + 1) %
                            dashAnimationStates.length;

                    final newDashAnimationState =
                        dashAnimationStates[newDashAnimationStateIndex];

                    setState(() => animationState = newDashAnimationState);
                  },
                  child: SizedBox.square(
                    dimension: 400,
                    child: DashAnimator(
                      animationState: animationState,
                      dashAttire: dashAttire,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
