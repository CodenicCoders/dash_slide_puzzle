import 'package:application/application.dart' as app;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presentation/presentation.dart';
import 'package:simple_shadow/simple_shadow.dart';

enum MenuItem { keyboardShortcuts, stateMachinePreview }

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
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
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<MenuItem>(
            value: MenuItem.keyboardShortcuts,
            child: _menuItemContent(
              context,
              'Keyboard shortcuts',
              Icons.keyboard_alt_outlined,
            ),
          ),
          PopupMenuItem<MenuItem>(
            value: MenuItem.stateMachinePreview,
            child: _menuItemContent(
              context,
              'Dash animator preview',
              Icons.flutter_dash,
            ),
          ),
        ];
      },
    );
  }

  Widget _menuItemContent(
    BuildContext context,
    String title,
    IconData iconData,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(iconData, color: Colors.black54),
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
