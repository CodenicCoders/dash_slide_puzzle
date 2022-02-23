import 'package:presentation/presentation.dart';

/// {@template BackgroundHandler}
///
/// Renders the appropriate background based on the app's layout.
///
/// {@endtemplate}
class BackgroundHandler extends StatelessWidget {
  /// {@macro BackgroundHandler}
  const BackgroundHandler({required this.child, Key? key}) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: constraints.maxWidth <= Breakpoints.small
                  ? const SkyAnimator(
                      key: ValueKey(Orientation.portrait),
                      orientation: Orientation.portrait,
                    )
                  : const SkyAnimator(
                      key: ValueKey(Orientation.landscape),
                      orientation: Orientation.landscape,
                    ),
            );
          },
        ),
        const StarsHandler(),
        child,
      ],
    );
  }
}
