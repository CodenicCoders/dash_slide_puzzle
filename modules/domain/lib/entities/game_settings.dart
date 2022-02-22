import 'package:domain/domain.dart';

/// {@template GameSettings}
///
/// A model for holding the game settings of the [GameService].
///
/// {@endtemplate}
class GameSettings with EquatableMixin {
  /// {@macro GameSettings}
  const GameSettings({
    this.botMoveCooldownMinDuration = const Duration(milliseconds: 300),
    this.botMoveCooldownMaxDuration = const Duration(milliseconds: 1500),
    this.maxEnergyRecoveryDuration = const Duration(seconds: 21),
    this.slowSpellEnergyCost = 8 / 21,
    this.stunSpellEnergyCost = 13 / 21,
    this.timeReversalSpellEnergyCost = 21 / 21,
    this.slowSpellCoefficient = 1.5,
    this.spellCastDelay = const Duration(seconds: 1),
    this.spellDuration = const Duration(seconds: 4),
  })  : assert(
          slowSpellEnergyCost >= 0 && slowSpellEnergyCost <= 1,
          'Energy cost must have a value between 0 to 1 inclusively',
        ),
        assert(
          stunSpellEnergyCost >= 0 && stunSpellEnergyCost <= 1,
          'Energy cost must have a value between 0 to 1 inclusively',
        ),
        assert(
          timeReversalSpellEnergyCost >= 0 && timeReversalSpellEnergyCost <= 1,
          'Energy cost must have a value between 0 to 1 inclusively',
        ),
        assert(
          slowSpellCoefficient >= 1,
          'Slow spell coefficient must be greater than 1',
        );

  /// The minimum cooldown for the bot after every move.
  final Duration botMoveCooldownMinDuration;

  /// The maximum cooldown for the bot after every move.
  final Duration botMoveCooldownMaxDuration;

  /// The time it takes to for the player to reach their max energy.
  final Duration maxEnergyRecoveryDuration;

  /// The energy cost of casting a [Spell.slow] ranging from `0` to `1`
  /// inclusively.
  final double slowSpellEnergyCost;

  /// The energy cost of casting a [Spell.stun] ranging from `0` to `1`
  /// inclusively.
  final double stunSpellEnergyCost;

  /// The energy cost of casting a [Spell.timeReversal] ranging from `0` to `1`
  /// inclusively.
  final double timeReversalSpellEnergyCost;

  /// A multiplier for the [botMoveCooldownMinDuration] and
  /// [botMoveCooldownMaxDuration] to increase the bot move cooldown when it is
  /// under a [Spell.slow].
  ///
  /// This must have a value greater than or equal to 1.
  final double slowSpellCoefficient;

  /// The delay rendered before casting a spell.
  final Duration spellCastDelay;

  /// The duration for how long the spell takes effect.
  final Duration spellDuration;

  /// Creates a copy of this [GameSettings] but with the given fields replaced
  /// with the new values.
  GameSettings copyWith({
    Duration? botMoveCooldownMinDuration,
    Duration? botMoveCooldownMaxDuration,
    Duration? maxEnergyRecoveryDuration,
    double? slowSpellEnergyCost,
    double? stunSpellEnergyCost,
    double? timeReversalSpellEnergyCost,
    double? slowSpellCoefficient,
    Duration? spellCastDelay,
    Duration? spellDuration,
  }) {
    return GameSettings(
      botMoveCooldownMinDuration:
          botMoveCooldownMinDuration ?? this.botMoveCooldownMinDuration,
      botMoveCooldownMaxDuration:
          botMoveCooldownMaxDuration ?? this.botMoveCooldownMaxDuration,
      maxEnergyRecoveryDuration:
          maxEnergyRecoveryDuration ?? this.maxEnergyRecoveryDuration,
      slowSpellEnergyCost: slowSpellEnergyCost ?? this.slowSpellEnergyCost,
      stunSpellEnergyCost: stunSpellEnergyCost ?? this.stunSpellEnergyCost,
      timeReversalSpellEnergyCost:
          timeReversalSpellEnergyCost ?? this.timeReversalSpellEnergyCost,
      slowSpellCoefficient: slowSpellCoefficient ?? this.slowSpellCoefficient,
      spellCastDelay: spellCastDelay ?? this.spellCastDelay,
      spellDuration: spellDuration ?? this.spellDuration,
    );
  }

  @override
  List<Object?> get props => [
        botMoveCooldownMinDuration,
        botMoveCooldownMaxDuration,
        maxEnergyRecoveryDuration,
        slowSpellEnergyCost,
        stunSpellEnergyCost,
        timeReversalSpellEnergyCost,
        slowSpellCoefficient,
        spellCastDelay,
        spellDuration,
      ];
}
