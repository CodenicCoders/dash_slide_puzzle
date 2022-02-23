import 'package:application/application.dart' as app;
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:presentation/presentation.dart';
import 'package:presentation/spell_handler/spell_button.dart';

/// {@template AvailableSpellIndicator}
///
/// An animated widget that renders the available spell and energy of the
/// player.
///
/// {@endtemplate}
class AvailableSpellIndicator extends StatelessWidget {
  /// {@macro AvailableSpellIndicator}
  const AvailableSpellIndicator({Key? key}) : super(key: key);

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
          child: const _ProgressIndicator(),
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
                color: Theme.of(context).primaryColor,
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

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spellEnergy =
        context.select<app.WatchAvailableSpellStateUseCase, double>(
      (useCase) => useCase.rightEvent?.energy ?? 0,
    );

    return LiquidLinearProgressIndicator(
      value: spellEnergy,
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
      borderColor: Colors.transparent,
      borderWidth: 0,
      borderRadius: 108,
    );
  }
}
