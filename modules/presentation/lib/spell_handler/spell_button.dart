import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/assets/assets.dart';

class SpellButton extends StatelessWidget {
  const SpellButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableSpell =
        context.select<app.WatchAvailableSpellStateUseCase, app.Spell?>(
      (useCase) => useCase.rightEvent?.spell,
    );

    return GestureDetector(
      onTap: () =>
          context.read<app.CastAvailableSpellUseCase>().run(params: null),
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        reverseDuration: const Duration(milliseconds: 300),
        switchInCurve: Curves.elasticOut,
        switchOutCurve: Curves.easeOutQuart,
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: availableSpell == null
            ? null
            : Image.asset(
                SpellAssets.image(availableSpell),
                key: ValueKey(availableSpell),
              ),
      ),
    );
  }
}
