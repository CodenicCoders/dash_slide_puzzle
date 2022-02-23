import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';

/// {@template StartGameButton}
///
/// A button for starting or resetting the game depending on the current
/// [app.GameStatus].
///
/// {@endtemplate}
class StartGameButton extends StatelessWidget {
  /// {@macro StartGameButton}
  const StartGameButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameStatus =
        context.select<app.WatchGameStateUseCase, app.GameStatus>(
      (state) => state.rightEvent.status,
    );

    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: gameStatus != app.GameStatus.initializing
                ? () => _onButtonClicked(context, gameStatus)
                : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: gameStatus == app.GameStatus.initializing ? 12 : 24,
              ),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: gameStatus == app.GameStatus.notStarted
                    ? const _StartButton()
                    : gameStatus == app.GameStatus.initializing
                        ? const _LoadingButton()
                        : const _ResetButton(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonClicked(BuildContext context, app.GameStatus gameStatus) {
    if (gameStatus == app.GameStatus.initializing) {
      return;
    }

    if (gameStatus == app.GameStatus.notStarted) {
      context.read<app.StartGameUseCase>().run(params: null);
    } else {
      context.read<app.ResetGameUseCase>().run(params: null);
    }
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          FontAwesomeIcons.play,
          color: Colors.white,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          'Start Game',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _LoadingButton extends StatelessWidget {
  const _LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child:
          LoadingBouncingGrid.square(backgroundColor: Colors.white, size: 24),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          FontAwesomeIcons.reply,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Reset Game',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
