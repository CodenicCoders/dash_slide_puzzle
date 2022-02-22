import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

/// A helper method for showing a white translucent dialog.
Future<T?> showGlassDialog<T extends Object?>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) =>
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      animationType: DialogTransitionType.slideFromBottomFade,
      duration: const Duration(milliseconds: 200),
      builder: (context) {
        return SafeArea(
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.87),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            content: builder(context),
          ),
        );
      },
    );
