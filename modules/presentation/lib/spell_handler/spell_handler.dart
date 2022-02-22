import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/constants/breakpoints.dart';
import 'package:presentation/spell_handler/available_spell_indicator.dart';
import 'package:presentation/spell_handler/spell_banner.dart';

class SpellHandler extends StatefulWidget {
  const SpellHandler();

  @override
  State<SpellHandler> createState() => _SpellHandlerState();
}

class _SpellHandlerState extends State<SpellHandler> {
  final _spellBannerKey = UniqueKey();

  app.Spell? _recentlyCastedSpell;

  void _onSpellCasted(app.Spell spell) {
    setState(() => _recentlyCastedSpell = spell);

    Future<void>.delayed(
      const Duration(milliseconds: 4000),
      () {
        if (mounted) {
          setState(() => _recentlyCastedSpell = null);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableSpellState = context.select<
        app.WatchAvailableSpellStateUseCase,
        app.AvailableSpellState?>((useCase) => useCase.rightEvent);

    final showEnergyIndicator = availableSpellState != null;

    return BlocListener<app.CastAvailableSpellUseCase, app.RunnerState>(
      listener: (context, state) {
        if (state is app.RunSuccess<app.Spell>) {
          _onSpellCasted(state.rightValue);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              reverseDuration: const Duration(milliseconds: 300),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeOutQuart,
              transitionBuilder: (child, animation) {
                final screenWidth = MediaQuery.of(context).size.width;

                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0,
                    end: child.key == _spellBannerKey &&
                            screenWidth > Breakpoints.small
                        ? 1.5
                        : 1,
                  ).animate(animation),
                  child: child,
                );
              },
              child: _recentlyCastedSpell != null
                  ? Transform.scale(
                      key: _spellBannerKey,
                      scale: 1.2,
                      child: SpellBanner(spell: _recentlyCastedSpell!),
                    )
                  : showEnergyIndicator
                      ? AvailableSpellIndicator(
                          spellEnergy: availableSpellState.energy,
                        )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
