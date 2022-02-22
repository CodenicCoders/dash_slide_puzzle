import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
          create: (context) =>
              serviceLocator<app.WatchGameStateUseCase>()..watch(params: null),
        ),
        BlocProvider(
          create: (context) => serviceLocator<app.CastAvailableSpellUseCase>(),
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
              theme: MainTheme.option(theme),
              home: const PuzzlePage(),
            );
          },
        ),
      ),
    );
  }
}
