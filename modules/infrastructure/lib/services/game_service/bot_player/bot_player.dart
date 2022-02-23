import 'dart:async';
import 'dart:core';

import 'package:domain/domain.dart';
import 'package:rxdart/rxdart.dart';

/// The status of the [BotPlayer].
enum BotStatus {
  /// A status indicating that the bot player has not been started yet.
  notStarted,

  /// A status indicating that the bot player is currently playing.
  started,

  /// A status indicating the the bot player is disposed.
  closed,
}

/// {@template BotPlayer}
///
/// The bot player that traverses the [solvedPuzzle] to simulate bot play.
///
/// {@endtemplate}
class BotPlayer {
  /// {@macro BotPlayer}
  BotPlayer({required this.solvedPuzzle, required GameSettings gameSettings})
      : _gameSettings = gameSettings;

  /// The [Puzzle] traversed by the bot.
  final Puzzle solvedPuzzle;
  final GameSettings _gameSettings;

  /// Streams the current [Puzzle] state of the bot.
  final puzzleMoveSubject = BehaviorSubject<Puzzle>();

  /// Streams the active spell casted on the bot.
  final activeSpellStateSubject = BehaviorSubject<ActiveSpellState?>();

  /// The current status of the bot.
  BotStatus _botStatus = BotStatus.notStarted;

  /// An index for traversing the [solvedPuzzle]'s history;
  int _moveIndex = 0;

  /// Defines the next [DateTime] the bot can move through the
  /// [solvedPuzzle]'s history.
  DateTime _nextBotMoveTime = DateTime.now();

  /// Starts the bot movement.
  Future<void> start({required Puzzle puzzle}) async {
    if (_botStatus == BotStatus.closed) {
      throw StateError('Cannot start bot after closing');
    }

    if (_botStatus == BotStatus.started) {
      throw StateError('The bot has already been started');
    }

    _botStatus = BotStatus.started;

    unawaited(_onUpdate());
  }

  /// Closes the bot and all its streams.
  Future<void> close() async {
    if (_botStatus == BotStatus.closed) {
      return;
    }

    _botStatus = BotStatus.closed;

    await Future.wait<void>([
      puzzleMoveSubject.close(),
      activeSpellStateSubject.close(),
    ]);
  }

  /// A fixed interval for updating the bot's state while the [_botStatus] is
  /// equal to [BotStatus.started].
  Future<void> _onUpdate() async {
    while (_botStatus == BotStatus.started) {
      _updateActiveSpellState();
      _tryMovingBot();

      await Future<void>.delayed(const Duration(milliseconds: 8));
    }
  }

  /// Tries to move the bot with respect to the [ActiveSpellState] from
  /// [activeSpellStateSubject].
  ///
  /// If the [_nextBotMoveTime] has not been exceeded yet or the
  /// [ActiveSpellState] is [Spell.stun], then the bot will
  /// not be moved.
  ///
  /// If the [ActiveSpellState] is [Spell.timeReversal], then the bot will move
  /// on the opposite direction.
  ///
  /// Once the bot is moved, [_updateNextMoveTime] will be called.
  void _tryMovingBot() {
    final now = DateTime.now();

    if (now.isBefore(_nextBotMoveTime)) {
      return;
    }

    final activeSpell = activeSpellStateSubject.valueOrNull?.spell;

    if (activeSpell == Spell.stun) {
      return;
    }

    final newMoveIndex =
        activeSpell == Spell.timeReversal ? _moveIndex - 1 : _moveIndex + 1;

    if (newMoveIndex < 0 || newMoveIndex >= solvedPuzzle.history.length) {
      return;
    }

    final puzzle = solvedPuzzle.history[newMoveIndex];
    puzzleMoveSubject.add(puzzle);

    _moveIndex = newMoveIndex;

    _updateNextMoveTime();
  }

  /// Determines the upcoming [_nextBotMoveTime].
  ///
  /// If the [ActiveSpellState] is [Spell.slow], then the
  /// [GameSettings.slowSpellCoefficient] will be applied to extend the
  /// [_nextBotMoveTime].
  ///
  /// If the [ActiveSpellState] is [Spell.timeReversal], then the next move
  /// time will be determined using the
  /// [GameSettings.botMoveCooldownMinDuration].
  void _updateNextMoveTime() {
    final moveCooldownMinDuration = _gameSettings.botMoveCooldownMinDuration;
    final moveCooldownMaxDuration = _gameSettings.botMoveCooldownMaxDuration;

    final activeSpell = activeSpellStateSubject.valueOrNull?.spell;

    final Duration moveCooldownDuration;

    if (activeSpell == Spell.slow) {
      final slowSpellCoefficient = _gameSettings.slowSpellCoefficient;

      final moveCooldownMaxTimeInMillis =
          _gameSettings.botMoveCooldownMaxDuration.inMilliseconds;

      final moveCooldownTimeInMillis =
          moveCooldownMaxTimeInMillis * slowSpellCoefficient;

      moveCooldownDuration =
          Duration(milliseconds: moveCooldownTimeInMillis.toInt());
    } else if (activeSpell == Spell.timeReversal) {
      moveCooldownDuration = moveCooldownMinDuration;
    } else {
      moveCooldownDuration =
          moveCooldownMinDuration.randomInBetween(moveCooldownMaxDuration);
    }

    final now = DateTime.now();

    _nextBotMoveTime = now.add(moveCooldownDuration);
  }

  /// Updates the [ActiveSpellState] of [activeSpellStateSubject].
  void _updateActiveSpellState() {
    final activeSpellState = activeSpellStateSubject.valueOrNull;

    if (activeSpellState == null) {
      return;
    }

    final spellDuration = _gameSettings.spellDuration;
    final startTime = activeSpellState.startTime;
    final endTime = activeSpellState.startTime.add(spellDuration);
    final now = DateTime.now();

    // Determine the new remaining time from 1 to 0

    final newRemainingTime = (1 -
            now.difference(startTime).inMilliseconds /
                endTime.difference(startTime).inMilliseconds)
        .minMax(0, 1)
        .toDouble();

    if (newRemainingTime <= 0) {
      activeSpellStateSubject.add(null);
    } else {
      final newActiveSpellState =
          activeSpellState.copyWith(remainingTime: newRemainingTime);

      activeSpellStateSubject.add(newActiveSpellState);
    }
  }

  /// Casts a spell on this bot to affect its movement.
  ///
  /// A [StateError] will be thrown if the bot has not been started yet or has
  /// been closed.
  Future<void> castSpell({required Spell spell}) async {
    if (_botStatus == BotStatus.closed) {
      throw StateError('Cannot slow bot after closing');
    }

    if (_botStatus == BotStatus.notStarted) {
      throw StateError('The bot has not been started yet');
    }

    await Future<void>.delayed(
      _gameSettings.spellCastDelay,
      () {
        if (_botStatus == BotStatus.closed) {
          return;
        }

        final startTime = DateTime.now();

        activeSpellStateSubject.add(
          ActiveSpellState(
            spell: spell,
            startTime: startTime,
            remainingTime: 1,
          ),
        );
      },
    );
  }
}
