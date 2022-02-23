import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

/// {@template PlayerDashAnimator}
///
/// The [DashAnimator] for the bot.
///
/// {@endtemplate}
class PlayerDashAnimator extends StatefulWidget {
  /// {@macro PlayerDashAnimator}
  const PlayerDashAnimator({required this.dashAnimatorKey, Key? key})
      : super(key: key);

  /// The key assigned to the nested [DashAnimator].
  final GlobalKey<DashAnimatorState> dashAnimatorKey;

  @override
  State<PlayerDashAnimator> createState() => _PlayerDashAnimatorState();
}

class _PlayerDashAnimatorState extends State<PlayerDashAnimator> {
  final playerDashAnimatorKey = GlobalKey<DashAnimatorState>();

  app.Spell? _recentSpellCasted;

  @override
  Widget build(BuildContext context) {
    final gameStatus =
        context.select<app.WatchGameStateUseCase, app.GameStatus>(
      (useCase) => useCase.rightEvent.status,
    );

    final activeSpell =
        context.select<app.WatchActiveSpellStateUseCase, app.Spell?>(
      (useCase) => useCase.rightEvent?.spell,
    );

    final dashAttire = context.select<DashAnimatorGroupCubit, DashAttire>(
      (cubit) => cubit.state.playerDashAttire,
    );

    final DashAnimationState animationState;

    switch (gameStatus) {
      case app.GameStatus.notStarted:
      case app.GameStatus.initializing:
      case app.GameStatus.shuffling:
        animationState = DashAnimationState.idle;
        break;
      case app.GameStatus.playing:
        if (_recentSpellCasted != null) {
          animationState =
              _mapRecentlyCastedSpellToDashAnimation(_recentSpellCasted);
        } else {
          animationState = _mapActiveSpellToDashAnimation(activeSpell);
        }

        break;
      case app.GameStatus.playerWon:
        animationState = DashAnimationState.taunt;
        break;
      case app.GameStatus.botWon:
        animationState = DashAnimationState.loser;
        break;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<app.CastAvailableSpellUseCase, app.RunnerState>(
          listenWhen: (oldState, newState) => newState is app.RunSuccess,
          listener: _onCastAvailableSpell,
        ),
        BlocListener<app.WatchActiveSpellStateUseCase, app.WatcherState>(
          listenWhen: (oldState, newState) => newState is app.WatchDataReceived,
          listener: _onWatchActiveSpellState,
        ),
      ],
      child: DashAnimator(
        key: playerDashAnimatorKey,
        dashAttire: dashAttire,
        animationState: animationState,
      ),
    );
  }

  void _onCastAvailableSpell(BuildContext context, app.RunnerState state) {
    final botDashAnimatorKey = widget.dashAnimatorKey;

    if (state is app.RunSuccess<app.Spell>) {
      final castedSpell = state.rightValue;

      if (castedSpell == app.Spell.slow) {
        final botDashRightWingKey =
            botDashAnimatorKey.currentState?.rightWingKey;

        if (botDashRightWingKey == null) {
          return;
        }

        playerDashAnimatorKey.currentState?.throwPizza(botDashRightWingKey);
      } else if (castedSpell == app.Spell.stun) {
        final botDashLeftWingKey = botDashAnimatorKey.currentState?.leftWingKey;

        if (botDashLeftWingKey == null) {
          return;
        }

        playerDashAnimatorKey.currentState?.throwStone(botDashLeftWingKey);
      }

      setState(() => _recentSpellCasted = state.rightValue);
    }
  }

  void _onWatchActiveSpellState(BuildContext context, app.WatcherState state) {
    if (state is app.WatchDataReceived && _recentSpellCasted != null) {
      setState(() => _recentSpellCasted = null);
    }
  }

  DashAnimationState _mapRecentlyCastedSpellToDashAnimation(
    app.Spell? spell,
  ) {
    switch (spell) {
      case app.Spell.slow:
        return DashAnimationState.toss;
      case app.Spell.stun:
        return DashAnimationState.toss;
      case app.Spell.timeReversal:
      case null:
        return DashAnimationState.spellcast;
    }
  }

  DashAnimationState _mapActiveSpellToDashAnimation(app.Spell? spell) {
    switch (spell) {
      case app.Spell.slow:
        return DashAnimationState.happy;
      case app.Spell.stun:
        return DashAnimationState.taunt;
      case app.Spell.timeReversal:
        return DashAnimationState.wizardTaunt;
      case null:
        return DashAnimationState.idle;
    }
  }
}
