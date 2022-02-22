import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

/// Renders the appropriate cloud background based on the layout width.
class BackgroundRenderer extends StatelessWidget {
  const BackgroundRenderer({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final theme = context.select<app.SwitchThemeUseCase, app.ThemeOption>(
          (useCase) => useCase.rightValue,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            const StarsRenderer(),
            const MoonAnimator(),
            const SunAnimator(),
            FittedBox(
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
              child: Image.asset(
                width <= Breakpoints.small
                    ? BackgroundAssets.portraitClouds
                    : BackgroundAssets.landscapeClouds,
              ),
            ),
            child,
          ],
        );
      },
    );
  }
}
