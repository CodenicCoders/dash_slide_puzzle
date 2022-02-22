import 'package:flutter/material.dart';
import 'package:presentation/puzzle/widgets/floating_action_buttons/dash_preview_button.dart';
import 'package:presentation/puzzle/widgets/floating_action_buttons/theme_button.dart';

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        Padding(
          padding: EdgeInsets.all(16),
          child: DashPreviewButton(),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: ThemeButton(),
        ),
      ],
    );
  }
}
