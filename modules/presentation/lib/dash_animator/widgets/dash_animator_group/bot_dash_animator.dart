import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';

/// {@template BotDashAnimator}
///
/// The [DashAnimator] for the bot.
///
/// {@endtemplate}
class BotDashAnimator extends StatelessWidget {
  /// {@macro BotDashAnimator}
  const BotDashAnimator({required this.dashAnimatorKey, Key? key})
      : super(key: key);

  /// The key assigned to the nested [DashAnimator].
  final GlobalKey<DashAnimatorState> dashAnimatorKey;

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
      (cubit) => cubit.state.botDashAttire,
    );

    final DashAnimationState animationState;

    switch (gameStatus) {
      case app.GameStatus.notStarted:
      case app.GameStatus.initializing:
      case app.GameStatus.shuffling:
        animationState = DashAnimationState.idle;
        break;
      case app.GameStatus.playing:
        animationState = _mapActiveSpellToDashAnimation(activeSpell);
        break;
      case app.GameStatus.playerWon:
        animationState = DashAnimationState.loser;
        break;
      case app.GameStatus.botWon:
        animationState = DashAnimationState.taunt;
        break;
    }

    return DashAnimator(
      key: dashAnimatorKey,
      animationState: animationState,
      dashAttire: dashAttire,
    );
  }

  DashAnimationState _mapActiveSpellToDashAnimation(app.Spell? spell) {
    switch (spell) {
      case app.Spell.slow:
        return DashAnimationState.excited;
      case app.Spell.stun:
        return DashAnimationState.wtf;
      case app.Spell.timeReversal:
        return DashAnimationState.wtfff;
      case null:
        return DashAnimationState.idle;
    }
  }
}
