import 'package:application/application.dart';

/// The available theme options.
enum ThemeOption {
  day,
  night,
  prevening,
}

/// Switches the current theme to the next one.
class SwitchThemeUseCase extends Runner<void, Failure, ThemeOption> {
  @override
  ThemeOption get rightValue => super.rightValue ?? ThemeOption.day;

  @override
  Future<Either<Failure, ThemeOption>> onCall(void params) async {
    final oldThemeOption = rightValue;

    switch (oldThemeOption) {
      case ThemeOption.day:
        return const Right(ThemeOption.prevening);
      case ThemeOption.prevening:
        return const Right(ThemeOption.night);
      case ThemeOption.night:
        return const Right(ThemeOption.day);
    }
  }
}
