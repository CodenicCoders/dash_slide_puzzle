import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:presentation/spell_handler/spell_button.dart';

/// {@template AvailableSpellIndicator}
///
/// An animated widget that renders the available spell and energy of the
/// player.
///
/// {@endtemplate}
class AvailableSpellIndicator extends StatelessWidget {
  /// {@macro AvailableSpellIndicator}
  const AvailableSpellIndicator({required this.spellEnergy, Key? key})
      : super(key: key);

  final double spellEnergy;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(108),
          ),
          constraints: const BoxConstraints(maxWidth: 512, maxHeight: 24),
          child: LiquidLinearProgressIndicator(
            value: spellEnergy,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).primaryColorDark,
            ),
            borderColor: Colors.transparent,
            borderWidth: 0,
            borderRadius: 108,
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(108),
              color: Colors.white54,
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(108),
                color: Theme.of(context).primaryColorDark,
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: const [SpellButton()],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
