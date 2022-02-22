import 'package:application/application.dart' as app;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presentation/presentation.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({required this.onPressed, required this.iconData, Key? key})
      : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      onPressed: onPressed,
      icon: SimpleShadow(offset: Offset.zero, child: Icon(iconData)),
    );
  }
}

/// {@template ShareActionItem}
///
/// An app bar action item for sharing the app.
///
/// {@endtemplate}
class ShareActionItem extends StatelessWidget {
  /// {@macro ShareActionItem}
  const ShareActionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionItem(
      onPressed: () {
        context.read<app.PlayLocalAudioUseCase>().run(
              params: app.PlayLocalAudioParams(
                audioFilePath: SFXAssets.click,
                audioPlayerChannel: AudioPlayerChannel.click,
              ),
            );

        ShareAppDialog.show(context: context);
      },
      iconData: FontAwesomeIcons.shareAlt,
    );
  }
}

/// {@template VolumeActionItem}
///
/// An app bar action item for enabling or disabling the audio.
///
/// {@endtemplate}
class VolumeActionItem extends StatelessWidget {
  /// {@macro VolumeActionItem}
  const VolumeActionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAllAudioMuted =
        context.select<app.WatchAllAudioMutedStateUseCase, bool>(
      (useCase) => useCase.rightEvent,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isAllAudioMuted
          ? ActionItem(
              key: ValueKey(isAllAudioMuted),
              onPressed: () =>
                  context.read<app.UnmuteAllAudioUseCase>().run(params: null),
              iconData: FontAwesomeIcons.volumeOff,
            )
          : ActionItem(
              key: ValueKey(isAllAudioMuted),
              onPressed: () =>
                  context.read<app.MuteAllAudioUseCase>().run(params: null),
              iconData: FontAwesomeIcons.volumeUp,
            ),
    );
  }
}
