import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

/// {@template AudioHandler}
///
/// A widget for playing most of the audio.
///
/// {@endtemplate}
class AudioHandler extends StatelessWidget {
  /// {@macro AudioHandler}
  const AudioHandler({required this.child, Key? key}) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<app.CastAvailableSpellUseCase, app.RunnerState>(
          listener: _onCastAvailableSpell,
        ),
        BlocListener<app.MovePlayerTileUseCase, app.RunnerState>(
          listener: _onMovePlayerTile,
        ),
        BlocListener<app.PreviewCompletedPuzzleUseCase, app.RunnerState>(
          listener: _onPreviewCompletedPuzzle,
        ),
        BlocListener<app.ResetGameUseCase, app.RunnerState>(
          listener: _onResetGame,
        ),
        BlocListener<app.StartGameUseCase, app.RunnerState>(
          listener: _onStartGame,
        ),
        BlocListener<app.UnmuteAllAudioUseCase, app.RunnerState>(
          listener: _onUnmuteAllAudio,
        ),
        BlocListener<app.WatchAvailableSpellStateUseCase, app.WatcherState>(
          listener: _onWatchAvailableSpellState,
        ),
        BlocListener<app.WatchGameStateUseCase, app.WatcherState>(
          listener: _onWatchGameState,
        ),
        BlocListener<DashAnimatorGroupCubit, DashAnimatorGroupState>(
          listener: _onDashAnimatorGroupState,
        ),
        BlocListener<app.SwitchThemeUseCase, app.RunnerState>(
          listener: _onSwitchTheme,
        ),
      ],
      child: child,
    );
  }

  void _onCastAvailableSpell(BuildContext context, app.RunnerState state) {
    if (state is app.RunSuccess<app.Spell>) {
      final castedSpell = state.rightValue;

      switch (castedSpell) {
        case app.Spell.slow:
          _playAudio(
            context,
            SFXAssets.toss,
            AudioPlayerChannel.playerDash,
          );

          Future.delayed(
            const Duration(seconds: 1),
            () {
              _playAudio(
                context,
                SFXAssets.dashSound(DashSound.dashSound2),
                AudioPlayerChannel.botDash,
              );
            },
          );
          break;
        case app.Spell.stun:
          _playAudio(
            context,
            SFXAssets.toss,
            AudioPlayerChannel.playerDash,
          );

          Future.delayed(
            const Duration(milliseconds: 1200),
            () {
              _playAudio(
                context,
                SFXAssets.deviceFall,
                AudioPlayerChannel.botDash,
              );
            },
          );
          break;
        case app.Spell.timeReversal:
          _playAudio(
            context,
            SFXAssets.magic,
            AudioPlayerChannel.playerDash,
          );

          Future.delayed(
            const Duration(seconds: 1),
            () {
              _playAudio(
                context,
                SFXAssets.dashSound(DashSound.dashSound1),
                AudioPlayerChannel.botDash,
              );
            },
          );
          break;
      }
    }
  }

  void _onMovePlayerTile(BuildContext context, app.RunnerState state) {
    final String audioFile;

    if (state is app.RunFailed) {
      audioFile = SFXAssets.tileUnmovable;
    } else if (state is app.RunSuccess) {
      audioFile = SFXAssets.tileMove;
    } else {
      return;
    }

    _playAudio(
      context,
      audioFile,
      AudioPlayerChannel.puzzleTile,
    );
  }

  void _onPreviewCompletedPuzzle(BuildContext context, app.RunnerState state) {
    if (state is app.RunSuccess) {
      _playAudio(
        context,
        SFXAssets.click,
        AudioPlayerChannel.click,
      );
    }
  }

  void _onResetGame(BuildContext context, app.RunnerState state) {
    if (state is app.RunSuccess) {
      _playAudio(
        context,
        SFXAssets.click,
        AudioPlayerChannel.click,
      );
    }
  }

  void _onStartGame(BuildContext context, app.RunnerState state) {
    if (state is app.Running) {
      _playAudio(
        context,
        SFXAssets.click,
        AudioPlayerChannel.click,
      );
    } else if (state is app.RunSuccess) {
      _playAudio(
        context,
        SFXAssets.shuffled,
        AudioPlayerChannel.game,
      );
    }
  }

  void _onSwitchTheme(BuildContext context, app.RunnerState state) {
    if (state is app.RunSuccess) {
      _playAudio(
        context,
        SFXAssets.click,
        AudioPlayerChannel.click,
      );
    }
  }

  void _onUnmuteAllAudio(BuildContext context, app.RunnerState state) {
    if (state is app.RunSuccess) {
      _playAudio(
        context,
        SFXAssets.click,
        AudioPlayerChannel.click,
      );
    }
  }

  void _onWatchAvailableSpellState(
    BuildContext context,
    app.WatcherState state,
  ) {
    if (state is app.WatchDataReceived<app.AvailableSpellState?>) {
      final availableSpellState = state.rightEvent;
      final spell = availableSpellState?.spell;

      if (availableSpellState == null ||
          spell == null ||
          !availableSpellState.isRecentSpell) {
        return;
      }

      final SpellAvailableSound spellAvailableSound;

      switch (spell) {
        case app.Spell.slow:
        case app.Spell.stun:
          spellAvailableSound = SpellAvailableSound.spellAvailableSound1;
          break;
        case app.Spell.timeReversal:
          spellAvailableSound = SpellAvailableSound.spellAvailableSound2;
          break;
      }

      _playAudio(
        context,
        SFXAssets.spellAvailableSound(spellAvailableSound),
        AudioPlayerChannel.spellAvailable,
      );
    }
  }

  void _onWatchGameState(BuildContext context, app.WatcherState state) {
    if (state is app.WatchDataReceived<app.GameState>) {
      final gameStatus = state.rightEvent.status;

      if (gameStatus == app.GameStatus.shuffling) {
        _playAudio(
          context,
          SFXAssets.shuffling,
          AudioPlayerChannel.game,
        );
      } else if (gameStatus == app.GameStatus.playerWon ||
          gameStatus == app.GameStatus.botWon) {
        _playAudio(
          context,
          SFXAssets.complete,
          AudioPlayerChannel.game,
        );
      }
    }
  }

  void _onDashAnimatorGroupState(
    BuildContext context,
    DashAnimatorGroupState state,
  ) {
    _playAudio(
      context,
      SFXAssets.randomDashSound(),
      AudioPlayerChannel.dashAnimatorGroup,
    );
  }

  void _playAudio(
    BuildContext context,
    String audioFilePath,
    dynamic audioPlayerChannel,
  ) {
    context.read<app.PlayLocalAudioUseCase>().run(
          params: app.PlayLocalAudioParams(
            audioFilePath: audioFilePath,
            audioPlayerChannel: audioPlayerChannel,
          ),
        );
  }
}
