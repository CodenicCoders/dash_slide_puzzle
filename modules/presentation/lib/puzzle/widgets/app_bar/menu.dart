import 'package:application/application.dart' as app;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presentation/presentation.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:url_launcher/url_launcher.dart';

/// Represents all the available app bar menu buttons in the [PuzzlePage].
enum MenuItem {
  /// A menu item identifier for viewing the keyboard shortcuts.
  keyboardShortcuts,

  /// A menu item identifier for viewing the Dash animator state machine.
  stateMachinePreview,

  /// A menu item identifier for showing a tutorial.
  tutorial,
}

/// {@template Menu}
///
/// The menu botton for the [PuzzlePage].
///
/// {@endtemplate}
class Menu extends StatelessWidget {
  /// {@macro Menu}
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      tooltip: AppLocalizations.of(context).showMenuTooltip,
      color: Colors.white.withOpacity(0.87),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: SimpleShadow(
        offset: Offset.zero,
        child: const Icon(FontAwesomeIcons.ellipsisV, color: Colors.white),
      ),
      onSelected: (menuItem) {
        context.read<app.PlayLocalAudioUseCase>().run(
              params: app.PlayLocalAudioParams(
                audioFilePath: SFXAssets.click,
                audioPlayerChannel: AudioPlayerChannel.click,
              ),
            );

        switch (menuItem) {
          case MenuItem.keyboardShortcuts:
            KeyboardShortcutDialog.show(context: context);
            break;
          case MenuItem.stateMachinePreview:
            DashAnimatorPreviewDialog.show(context: context);
            break;
          case MenuItem.tutorial:
            _launchTutorialVideo();
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<MenuItem>(
            value: MenuItem.keyboardShortcuts,
            child: _menuItemContent(
              context,
              AppLocalizations.of(context).keyboardShortcutsMenuItem,
              Icons.keyboard_alt_outlined,
            ),
          ),
          PopupMenuItem<MenuItem>(
            value: MenuItem.stateMachinePreview,
            child: _menuItemContent(
              context,
              AppLocalizations.of(context).dashAnimatorPreviewMenuItem,
              Icons.flutter_dash,
            ),
          ),
          PopupMenuItem<MenuItem>(
            value: MenuItem.tutorial,
            child: _menuItemContent(
              context,
              AppLocalizations.of(context).tutorialMenuItem,
              Icons.play_circle_outline,
            ),
          ),
        ];
      },
    );
  }

  Future<void> _launchTutorialVideo() async {
    const tutorialLink = 'https://youtu.be/BU6dAVheuns';

    if (await canLaunch(tutorialLink)) {
      await launch(tutorialLink);
    }
  }

  Widget _menuItemContent(
    BuildContext context,
    String title,
    IconData iconData,
  ) {
    return Row(
      children: [
        Icon(iconData, color: Colors.black54),
        const SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }
}
