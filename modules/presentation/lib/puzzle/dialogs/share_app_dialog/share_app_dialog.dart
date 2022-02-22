import 'dart:math';

import 'package:application/application.dart' as app;
import 'package:presentation/presentation.dart';
import 'package:presentation/puzzle/dialogs/share_app_dialog/share_button.dart';

class ShareAppDialog {
  ShareAppDialog._();

  static void show({required BuildContext context}) {
    showGlassDialog(
      context: context,
      builder: (context) {
        final watchGameStateUseCase = context.read<app.WatchGameStateUseCase>();
        final gameStatus = watchGameStateUseCase.rightEvent?.status;

        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (gameStatus == app.GameStatus.playerWon ||
                  gameStatus == app.GameStatus.botWon)
                const Flexible(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: DashAnimatorGroupControl(
                      areDashAttireCustomizable: false,
                    ),
                  ),
                )
              else
                Flexible(
                  child: SizedBox(
                    width: 256,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: const DashAnimator(
                        animationState: DashAnimationState.wave,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                _headline(gameStatus),
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Share this puzzle to challenge your friends and see if they '
                'have what it takes to beat Dash.',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Theme.of(context).textTheme.caption?.color,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ShareButton(shareButtonType: ShareButtonType.twitter),
                  SizedBox(width: 16),
                  ShareButton(shareButtonType: ShareButtonType.facebook),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static String _headline(app.GameStatus? gameStatus) {
    switch (gameStatus) {
      case app.GameStatus.playerWon:
        return 'You won!';
      case app.GameStatus.botWon:
        return 'Better luck next time!';
      case app.GameStatus.notStarted:
      case app.GameStatus.initializing:
      case app.GameStatus.shuffling:
      case app.GameStatus.playing:
      case null:
        return 'Need help?';
    }
  }
}
