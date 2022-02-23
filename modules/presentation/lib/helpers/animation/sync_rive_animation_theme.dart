import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';
import 'package:rive/rive.dart';

/// Syncs the theme of the tile to the current theme of the app.
Future<void> syncRiveAnimationTheme(
  State state,
  SMIInput<double> themeSMIInput,
) async {
  if (!state.mounted) {
    return;
  }

  final context = state.context;

  final currentTheme = context.read<app.SwitchThemeUseCase>().rightValue;

  final currentThemeIndex = app.ThemeOption.values.indexOf(currentTheme);

  final smiValue = themeSMIInput.value;

  if (smiValue != currentThemeIndex) {
    themeSMIInput.value = (smiValue + 1) % app.ThemeOption.values.length;

    await Future.delayed(
      const Duration(milliseconds: 300).randomInBetween(
        const Duration(milliseconds: 320),
      ),
      () => syncRiveAnimationTheme(state, themeSMIInput),
    );
  }
}
