import 'package:domain/domain.dart';

/// {@template SpellState}
///
/// A model for tracking the active spell casted on the bot.
///
/// {@endtemplate}
class ActiveSpellState with EquatableMixin {
  /// {@macro SpellState}
  const ActiveSpellState({
    required this.spell,
    required this.startTime,
    required this.remainingTime,
  }) : assert(
          remainingTime >= 0 && remainingTime <= 1,
          'Energy must have a value between 0 and 1 inclusively',
        );

  /// The spell casted on the bot.
  final Spell spell;

  /// The time the spell took effect.
  final DateTime startTime;

  /// The remaining time for the [spell] starting from `1.0` going down to
  /// `0.0`.
  final double remainingTime;

  ActiveSpellState copyWith({
    Spell? spell,
    DateTime? startTime,
    double? remainingTime,
  }) {
    return ActiveSpellState(
      spell: spell ?? this.spell,
      startTime: startTime ?? this.startTime,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }

  @override
  List<Object?> get props => [spell, startTime, remainingTime];
}
