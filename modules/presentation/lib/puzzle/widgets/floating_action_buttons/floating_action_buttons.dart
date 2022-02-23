import 'package:flutter/material.dart';
import 'package:presentation/puzzle/page/puzzle_page.dart';
import 'package:presentation/puzzle/widgets/floating_action_buttons/puzzle_preview_button.dart';
import 'package:presentation/puzzle/widgets/floating_action_buttons/theme_button.dart';

/// {@template FloatingActionButtons}
///
/// A widget containing all the floating action buttons for the [PuzzlePage].
///
/// {@endtemplate}
class FloatingActionButtons extends StatelessWidget {
  /// {@macro FloatingActionButtons}
  const FloatingActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        Padding(
          padding: EdgeInsets.all(16),
          child: PuzzlePreviewButton(),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: ThemeButton(),
        ),
      ],
    );
  }
}
