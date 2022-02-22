import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/constants/breakpoints.dart';
import 'package:presentation/dash_animator/dash_animator.dart';
import 'package:presentation/presentation.dart';

/// {@template DashAnimatorGroupControl}
///
/// Renders the [DashAnimator] widgets appropriately with respect to the
/// current screen size.
///
/// {@endtemplate}
class DashAnimatorGroupControl extends StatefulWidget {
  /// {@macro DashAnimatorGroupControl}
  const DashAnimatorGroupControl({
    this.areDashAttireCustomizable = true,
    Key? key,
  }) : super(key: key);

  final bool areDashAttireCustomizable;

  @override
  State<DashAnimatorGroupControl> createState() =>
      _DashAnimatorGroupControlState();
}

class _DashAnimatorGroupControlState extends State<DashAnimatorGroupControl> {
  final playerDashAnimatorKey = GlobalKey<DashAnimatorState>();
  final botDashAnimatorKey = GlobalKey<DashAnimatorState>();

  app.Spell? _recentSpellCasted;

  @override
  Widget build(BuildContext context) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final gameStatus =
              context.select<app.WatchGameStateUseCase, app.GameStatus?>(
            (useCase) => useCase.rightEvent?.status,
          );

          final activeSpell =
              context.select<app.WatchActiveSpellStateUseCase, app.Spell?>(
            (useCase) => useCase.rightEvent?.spell,
          );

          final dashAnimatorGroupState =
              context.select<DashAnimatorGroupCubit, DashAnimatorGroupState>(
            (cubit) => cubit.state,
          );

          final playerDashAttire = dashAnimatorGroupState.playerDashAttire;
          final botDashAttire = dashAnimatorGroupState.botDashAttire;

          final DashAnimationState playerAnimationState;
          final DashAnimationState botAnimationState;

          switch (gameStatus) {
            case app.GameStatus.notStarted:
            case app.GameStatus.initializing:
            case app.GameStatus.shuffling:
            case null:
              playerAnimationState = DashAnimationState.idle;
              botAnimationState = DashAnimationState.idle;
              break;
            case app.GameStatus.playing:
              if (_recentSpellCasted != null) {
                playerAnimationState =
                    _mapRecentlyCastedSpellToDashCasterAnimation(
                  _recentSpellCasted,
                );
                botAnimationState = DashAnimationState.idle;
              } else {
                playerAnimationState =
                    _mapActiveSpellToDashCasterAnimation(activeSpell);
                botAnimationState =
                    _mapActiveSpellToDashVictimAnimation(activeSpell);
              }

              break;
            case app.GameStatus.playerWon:
              playerAnimationState = DashAnimationState.taunt;
              botAnimationState = DashAnimationState.loser;
              break;
            case app.GameStatus.botWon:
              playerAnimationState = DashAnimationState.loser;
              botAnimationState = DashAnimationState.taunt;
              break;
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width <= Breakpoints.small ? 0 : 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: GestureDetector(
                      onTap: widget.areDashAttireCustomizable
                          ? _onPlayerDashTapped
                          : null,
                      child: DashAnimator(
                        key: playerDashAnimatorKey,
                        animationState: playerAnimationState,
                        dashBody: playerDashAttire.dashBody,
                        dashDevice: playerDashAttire.dashDevice,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.areDashAttireCustomizable
                        ? _onBotDashTapped
                        : null,
                    child: DashAnimator(
                      key: botDashAnimatorKey,
                      animationState: botAnimationState,
                      dashBody: botDashAttire.dashBody,
                      dashDevice: botDashAttire.dashDevice,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onPlayerDashTapped() =>
      context.read<DashAnimatorGroupCubit>().changePlayerDashAttire();

  void _onBotDashTapped() =>
      context.read<DashAnimatorGroupCubit>().changeBotDashAttire();

  void _onCastAvailableSpell(BuildContext context, app.RunnerState state) {
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
    if (state is app.WatchDataReceived) {
      setState(() => _recentSpellCasted = null);
    }
  }

  DashAnimationState _mapRecentlyCastedSpellToDashCasterAnimation(
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

  DashAnimationState _mapActiveSpellToDashCasterAnimation(app.Spell? spell) {
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

  DashAnimationState _mapActiveSpellToDashVictimAnimation(app.Spell? spell) {
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
