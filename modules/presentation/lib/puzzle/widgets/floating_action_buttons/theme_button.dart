import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/assets/assets.dart';

/// {@template ThemeButton}
///
/// A button for changing the app's theme.
///
/// {@endTemplate}
class ThemeButton extends StatelessWidget {
  /// {@macro ThemeButton}
  const ThemeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select<app.SwitchThemeUseCase, app.ThemeOption>(
      (useCase) => useCase.rightValue,
    );

    return Builder(builder: (context) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Material(
            color: Colors.transparent,
            elevation: 8,
            borderRadius: BorderRadius.circular(24),
            child: const SizedBox.square(dimension: 47),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              DayCycleAssets.image(theme),
              key: UniqueKey(),
              scale: 10.5,
            ),
          ),
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<app.SwitchThemeUseCase>().run(params: null);
                  
                },
                child: const SizedBox.square(dimension: 47),
              ),
            ),
          ),
        ],
      );
    });
  }
}
