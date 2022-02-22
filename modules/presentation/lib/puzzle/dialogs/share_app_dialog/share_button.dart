import 'package:application/application.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:url_launcher/url_launcher.dart';

enum ShareButtonType { twitter, facebook }

/// {@template ShareButton}
///
/// A button for sharing the app to select social media platforms via HTTPs.
///
/// {@endtemplate}
class ShareButton extends StatelessWidget {
  /// {@macro ShareButton}
  const ShareButton({required this.shareButtonType, Key? key})
      : super(key: key);

  static const _appUrl = 'https://dominicorga.codenic.dev/dash-slide-puzzle';

  final ShareButtonType shareButtonType;

  @override
  Widget build(BuildContext context) {
    return FlutterSocialButton(
      buttonType: _buttonType(),
      mini: true,
      onTap: () async {
        final watchGameStateUseCase = context.read<app.WatchGameStateUseCase>();
        final gameStatus = watchGameStateUseCase.rightEvent?.status;

        final shareUrl = _shareUrl(gameStatus);

        if (await canLaunch(shareUrl)) {
          await launch(shareUrl);
        }
      },
    );
  }

  ButtonType _buttonType() {
    switch (shareButtonType) {
      case ShareButtonType.twitter:
        return ButtonType.twitter;
      case ShareButtonType.facebook:
        return ButtonType.facebook;
    }
  }

  String _shareUrl(app.GameStatus? gameStatus) {
    final shareText = _message(gameStatus);
    final shareTextEncoded = Uri.encodeComponent(shareText);

    switch (shareButtonType) {
      case ShareButtonType.twitter:
        return 'https://twitter.com/intent/tweet?url=$_appUrl&text=$shareTextEncoded';
      case ShareButtonType.facebook:
        return 'https://www.facebook.com/sharer.php?u=$_appUrl&quote=$shareTextEncoded';
    }
  }

  String _message(app.GameStatus? gameStatus) {
    switch (gameStatus) {
      case app.GameStatus.playerWon:
        return 'Just beat Dash in this Slide Puzzle game from '
            '#FlutterPuzzleHack! Check it out ↓';
      case app.GameStatus.botWon:
        return "I can't beat Dash in this Slide Puzzle game from "
            '#FlutterPuzzleHack! Maybe you can? ↓';
      case app.GameStatus.notStarted:
      case app.GameStatus.initializing:
      case app.GameStatus.shuffling:
      case app.GameStatus.playing:
      case null:
        return 'Can you beat Dash in this Slide Puzzle game from '
            '#FlutterPuzzleHack? ↓';
    }
  }
}
