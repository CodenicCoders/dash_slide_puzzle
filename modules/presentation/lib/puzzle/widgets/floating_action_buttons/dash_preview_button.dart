import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/assets/assets.dart';

/// {@template FloatingPreviewButton}
///
/// A floating action button for previewing the player's puzzle in its
/// completed state.
///
/// {@endtemplate}
class DashPreviewButton extends StatefulWidget {
  /// {@macro FloatingPreviewButton}
  const DashPreviewButton({Key? key}) : super(key: key);

  @override
  State<DashPreviewButton> createState() => _DashPreviewButtonState();
}

class _DashPreviewButtonState extends State<DashPreviewButton> {
  @override
  Widget build(BuildContext context) {
    final theme = context.select<app.SwitchThemeUseCase, app.ThemeOption>(
      (useCase) => useCase.rightValue,
    );

    final DashatarVariant playerThemeVariant;

    switch (theme) {
      case app.ThemeOption.day:
        playerThemeVariant = DashatarVariant.blue1;
        break;
      case app.ThemeOption.prevening:
        playerThemeVariant = DashatarVariant.yellow1;
        break;
      case app.ThemeOption.night:
        playerThemeVariant = DashatarVariant.indigo1;
        break;
    }

    final shouldPreview =
        context.select<app.PreviewCompletedPuzzleUseCase, bool>(
      (useCase) => useCase.rightValue,
    );

    final size = shouldPreview ? 160.0 : 48.0;

    return Builder(
      builder: (context) {
        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              height: size,
              width: size,
              duration: const Duration(milliseconds: 200),
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      DashatarAssets.mainImage(playerThemeVariant),
                      key: UniqueKey(),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: _onTap),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTap() =>
      context.read<app.PreviewCompletedPuzzleUseCase>().run(params: null);
}
