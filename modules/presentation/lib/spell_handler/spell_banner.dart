import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:simple_shadow/simple_shadow.dart';

/// {@template SpellBanner}
///
/// A widget displayed to indicate that a spell has been casted.
///
/// {@endtemplate}
class SpellBanner extends StatelessWidget {
  /// {@macro SpelLBanner}
  const SpellBanner({required this.spell, Key? key}) : super(key: key);

  final app.Spell spell;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: SimpleShadow(
            offset: Offset.zero,
            child: Image.asset(SpellAssets.image(spell)),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FittedBox(
            child: Text(
              _spellDescription(spell),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                shadows: [const Shadow(blurRadius: 3)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _spellDescription(app.Spell spell) {
    switch (spell) {
      case app.Spell.slow:
        return 'You slowed down Dash by throwing a pizza';
      case app.Spell.stun:
        return "You skillfully knocked off Dash's device";
      case app.Spell.timeReversal:
        return 'You casted a time reversal spell on Dash';
    }
  }
}
