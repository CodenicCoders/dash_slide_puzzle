import 'package:application/application.dart';

/// The available theme options.
enum ThemeOption {
  /// The identifier for the day theme.
  day,

  /// The identifier for the prevening theme.
  ///
  /// See https://bit.ly/3HkobC5.
  prevening,

  /// The identifier for the evening theme.
  night,
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
