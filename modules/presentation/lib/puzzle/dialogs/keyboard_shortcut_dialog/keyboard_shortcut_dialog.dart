import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:presentation/constants/breakpoints.dart';
import 'package:presentation/helpers/dialogs/dialogs.dart';

class KeyboardShortcutDialog {
  KeyboardShortcutDialog._();

  static void show({required BuildContext context}) {
    showGlassDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;

        final dialogWidth = screenWidth >= Breakpoints.medium
            ? 712.0
            : screenWidth >= Breakpoints.small
                ? 472.0
                : double.minPositive;

        return SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: const [
                    KeyboardShortcut.icon(
                      title: 'Customize Dash',
                      keyboardIcon: FontAwesomeIcons.chevronLeft,
                    ),
                    KeyboardShortcut.icon(
                      title: 'Customize enemy Dash',
                      keyboardIcon: FontAwesomeIcons.chevronRight,
                    ),
                    KeyboardShortcut.text(
                      title: 'Change theme',
                      text: '/',
                    ),
                    KeyboardShortcut.text(
                      title: 'On/Off Volume',
                      text: 'M',
                    ),
                    KeyboardShortcut.text(
                      title: 'View puzzle reference',
                      text: 'Z',
                    ),
                    KeyboardShortcut.text(
                      title: 'Start/restart game',
                      text: 'ENTER',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'In Game',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: const [
                    KeyboardShortcut.icon(
                      title: 'Move tile upward',
                      keyboardIcon: FontAwesomeIcons.arrowUp,
                    ),
                    KeyboardShortcut.icon(
                      title: 'Move tile downward',
                      keyboardIcon: FontAwesomeIcons.arrowDown,
                    ),
                    KeyboardShortcut.icon(
                      title: 'Move tile to the left',
                      keyboardIcon: FontAwesomeIcons.arrowLeft,
                    ),
                    KeyboardShortcut.icon(
                      title: 'Move tile to the rght',
                      keyboardIcon: FontAwesomeIcons.arrowRight,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: const [
                    KeyboardShortcut.text(
                      title: 'Cast spell',
                      text: 'SPACE',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'In Dash Animator Preview',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: const [
                    KeyboardShortcut.text(
                      title: 'Idle',
                      text: '`',
                    ),
                    KeyboardShortcut.text(
                      title: 'Happy',
                      text: '1',
                    ),
                    KeyboardShortcut.text(
                      title: 'Toss',
                      text: '2',
                    ),
                    KeyboardShortcut.text(
                      title: 'Taunt',
                      text: '3',
                    ),
                    KeyboardShortcut.text(
                      title: 'Excited',
                      text: '4',
                    ),
                    KeyboardShortcut.text(
                      title: 'Skepticism',
                      text: '5',
                    ),
                    KeyboardShortcut.text(
                      title: 'Bewildered',
                      text: '6',
                    ),
                    KeyboardShortcut.text(
                      title: 'Loser',
                      text: '7',
                    ),
                    KeyboardShortcut.text(
                      title: 'Wave',
                      text: '8',
                    ),
                    KeyboardShortcut.text(
                      title: 'Spellcast',
                      text: '9',
                    ),
                    KeyboardShortcut.text(
                      title: 'Wizard taunt',
                      text: '0',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: const [
                    KeyboardShortcut.text(
                      title: 'Customize Dash',
                      text: 'SPACE',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class KeyboardShortcut extends StatelessWidget {
  const KeyboardShortcut.icon({
    required this.title,
    required this.keyboardIcon,
    Key? key,
  })  : text = null,
        super(key: key);

  const KeyboardShortcut.text(
      {required this.title, required this.text, Key? key})
      : keyboardIcon = null,
        super(key: key);

  final String title;
  final IconData? keyboardIcon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 216,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black54),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 4),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.all(8),
            child: keyboardIcon != null
                ? Icon(keyboardIcon, color: Colors.black54, size: 16)
                : Text(
                    text!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black54),
                  ),
          ),
        ],
      ),
    );
  }
}
