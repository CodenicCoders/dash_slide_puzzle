import 'dart:io' show Platform;

import 'package:application/application.dart' as app;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:presentation/presentation.dart';

/// {@template MainApp}
///
/// The root widget containing [MaterialApp].
///
/// {@endtemplate}
class MainApp extends StatelessWidget {
  /// {@macro MainApp}
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BeepSoundInhibitor(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                serviceLocator<app.WatchActiveSpellStateUseCase>()
                  ..watch(params: null),
          ),
          BlocProvider(
            create: (context) =>
                serviceLocator<app.WatchAllAudioMutedStateUseCase>()
                  ..watch(params: null),
          ),
          BlocProvider(
            create: (context) =>
                serviceLocator<app.WatchAvailableSpellStateUseCase>()
                  ..watch(params: null),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.WatchGameStateUseCase>()
              ..watch(params: null),
          ),
          BlocProvider(
            create: (context) =>
                serviceLocator<app.CastAvailableSpellUseCase>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.MovePlayerTileUseCase>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.MuteAllAudioUseCase>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.PlayLocalAudioUseCase>(),
          ),
          BlocProvider(
            create: (context) =>
                serviceLocator<app.PreviewCompletedPuzzleUseCase>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.ResetGameUseCase>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.StartGameUseCase>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.SwitchThemeUseCase>(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<app.UnmuteAllAudioUseCase>(),
          ),
          BlocProvider(create: (context) => DashAnimatorGroupCubit()),
        ],
        child: AudioHandler(
          child: Builder(
            builder: (context) {
              final theme =
                  context.select<app.SwitchThemeUseCase, app.ThemeOption>(
                (useCase) => useCase.rightValue,
              );

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Dash Slide Puzzle',
                theme: Themes.theme(theme),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const PuzzlePage(),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// {@template _BeepSoundInhibitor}
///
/// Prevents the beeping sound whenever a key is pressed on Mac OS.
///
/// For more info, see https://github.com/flutter/flutter/issues/74287#issuecomment-767031867
///
/// {@endtemplate}
class _BeepSoundInhibitor extends StatelessWidget {
  /// {@macro _BeepSoundInhibitor}
  const _BeepSoundInhibitor({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isMacOS) {
      return child;
    }

    return Focus(
      onKey: (node, event) => KeyEventResult.handled,
      child: child,
    );
  }
}
