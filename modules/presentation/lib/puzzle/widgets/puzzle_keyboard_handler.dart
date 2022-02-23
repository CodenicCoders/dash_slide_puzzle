import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/dash_animator/dash_animator.dart';

/// {@template PuzzleKeyboardHandler}
///
/// Listens for keyboard events for moving the player's tiles.
///
/// {@endtemplate}
class PuzzleKeyboardHandler extends StatefulWidget {
  /// {@macro PuzzleKeyboardHandler}
  const PuzzleKeyboardHandler({required this.child, Key? key})
      : super(key: key);

  /// The nested widget.
  final Widget child;

  @override
  State<PuzzleKeyboardHandler> createState() => _PuzzleKeyboardHandlerState();
}

class _PuzzleKeyboardHandlerState extends State<PuzzleKeyboardHandler> {
  final _focusScope = FocusNode();

  @override
  void dispose() {
    _focusScope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: _focusScope,
      onKey: _onKey,
      child: widget.child,
    );
  }

  /// Moves the appropriate [app.Tile] if any whenever the user pressed a
  /// keyboard arrow (←, →, ↑, ↓).
  void _onKey(RawKeyEvent keyEvent) {
    if (keyEvent is RawKeyDownEvent) {
      final physicalKey = keyEvent.data.physicalKey;

      final moveTileKeys = {
        PhysicalKeyboardKey.arrowUp,
        PhysicalKeyboardKey.arrowDown,
        PhysicalKeyboardKey.arrowLeft,
        PhysicalKeyboardKey.arrowRight,
      };

      if (moveTileKeys.contains(physicalKey)) {
        _moveTile(physicalKey);
      } else if (physicalKey == PhysicalKeyboardKey.space) {
        _castSpell();
      } else if (physicalKey == PhysicalKeyboardKey.comma) {
        _changePlayerDashAttire();
      } else if (physicalKey == PhysicalKeyboardKey.period) {
        _changeBotDashAttire();
      } else if (physicalKey == PhysicalKeyboardKey.slash) {
        _switchTheme();
      } else if (physicalKey == PhysicalKeyboardKey.keyZ) {
        _previewCompletedPuzzle();
      } else if (physicalKey == PhysicalKeyboardKey.enter) {
        _startOrResetGame();
      } else if (physicalKey == PhysicalKeyboardKey.keyM) {
        _muteOrUnmute();
      }
      
    }
  }

  void _moveTile(PhysicalKeyboardKey physicalKey) {
    final gameState = context.read<app.WatchGameStateUseCase>().rightEvent;

    if (gameState.status != app.GameStatus.playing) {
      return;
    }

    final playerPuzzle = gameState.playerPuzzle;

    final app.Tile? tileToMove;

    if (physicalKey == PhysicalKeyboardKey.arrowUp) {
      tileToMove = playerPuzzle
          .tileRelativeToWhitespaceTile(const app.Position(x: 0, y: 1));
    } else if (physicalKey == PhysicalKeyboardKey.arrowDown) {
      tileToMove = playerPuzzle
          .tileRelativeToWhitespaceTile(const app.Position(x: 0, y: -1));
    } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
      tileToMove = playerPuzzle
          .tileRelativeToWhitespaceTile(const app.Position(x: -1, y: 0));
    } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
      tileToMove = playerPuzzle
          .tileRelativeToWhitespaceTile(const app.Position(x: 1, y: 0));
    } else {
      tileToMove = null;
    }

    if (tileToMove != null) {
      context.read<app.MovePlayerTileUseCase>().run(
            params: app.MovePlayerTileParams(
              tileCurrentPosition: tileToMove.currentPosition,
            ),
          );
    }
  }

  void _castSpell() {
    final gameState = context.read<app.WatchGameStateUseCase>().rightEvent;

    if (gameState.status != app.GameStatus.playing) {
      return;
    }

    context.read<app.CastAvailableSpellUseCase>().run(params: null);
  }

  void _changePlayerDashAttire() =>
      context.read<DashAnimatorGroupCubit>().changePlayerDashAttire();

  void _changeBotDashAttire() =>
      context.read<DashAnimatorGroupCubit>().changeBotDashAttire();

  void _switchTheme() =>
      context.read<app.SwitchThemeUseCase>().run(params: null);

  void _previewCompletedPuzzle() =>
      context.read<app.PreviewCompletedPuzzleUseCase>().run(params: null);

  void _startOrResetGame() {
    final gameState = context.read<app.WatchGameStateUseCase>().rightEvent;
    final gameStatus = gameState.status;

    if (gameStatus == app.GameStatus.initializing) {
      return;
    }

    if (gameStatus == app.GameStatus.notStarted) {
      context.read<app.StartGameUseCase>().run(params: null);
    } else {
      context.read<app.ResetGameUseCase>().run(params: null);
    }
  }

  void _muteOrUnmute() {
    final isAllAudioMuted =
        context.read<app.WatchAllAudioMutedStateUseCase>().rightEvent;

    if (isAllAudioMuted) {
      context.read<app.UnmuteAllAudioUseCase>().run(params: null);
    } else {
      context.read<app.MuteAllAudioUseCase>().run(params: null);
    }
  }
}
