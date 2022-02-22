import 'package:domain/domain.dart';

/// The spells that can be casted by the player to the bot.
enum Spell {
  /// Slows down the bot.
  slow,

  /// Stuns the bot.
  stun,

  /// Reverses the puzzle steps taken by the bot.
  timeReversal,
}

/// {@template SpellState}
///
/// A model for tracking the available spell and energy of the player.
///
/// {@endtemplate}
class AvailableSpellState with EquatableMixin {
  /// {@macro SpellState}
  const AvailableSpellState({
    required this.energy,
    required this.lastSpellCastedTime,
    this.isRecentSpell = false,
    this.spell,
  }) : assert(
          energy >= 0 && energy <= 1,
          'Energy must have a value between 0 and 1 inclusively',
        );

  /// {@macro SpellState}
  ///
  /// This returns an [AvailableSpellState] with initial values.
  factory AvailableSpellState.initial() => AvailableSpellState(
        energy: 0,
        lastSpellCastedTime: DateTime.now(),
      );

  /// The current energy level starting from `0` going up to `1` which defines
  /// what the available [spell] is.
  final double energy;

  /// The last time that a spell has been casted.
  final DateTime lastSpellCastedTime;

  /// This is `true` if the [spell] has just been added and is emitted for the
  /// first time. Once the [spell] has
  /// been emitted more than once, then this becomes `false`.
  final bool isRecentSpell;

  /// The spell that can be casted by the user.
  final Spell? spell;

  AvailableSpellState copyWith({
    double? energy,
    bool? isRecentSpell,
    Spell? spell,
    DateTime? lastSpellCastedTime,
  }) {
    return AvailableSpellState(
      energy: energy ?? this.energy,
      isRecentSpell: isRecentSpell ?? this.isRecentSpell,
      spell: spell ?? this.spell,
      lastSpellCastedTime: lastSpellCastedTime ?? this.lastSpellCastedTime,
    );
  }

  @override
  List<Object?> get props => [
        energy,
        spell,
        lastSpellCastedTime,
        isRecentSpell,
      ];
}
