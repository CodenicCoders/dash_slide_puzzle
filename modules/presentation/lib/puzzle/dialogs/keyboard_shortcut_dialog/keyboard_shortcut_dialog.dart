import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:presentation/constants/breakpoints.dart';
import 'package:presentation/helpers/dialogs/dialogs.dart';
import 'package:presentation/l10n/app_localizations.dart';

/// A dialog for showing all the available keyboard shortcuts in the app.
class KeyboardShortcutDialog {
  KeyboardShortcutDialog._();

  /// Shows the dialog.
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
                  children: [
                    _KeyboardShortcut.icon(
                      title: AppLocalizations.of(context)
                          .customizeDashKeyboardShortcutTitle,
                      keyboardIcon: FontAwesomeIcons.chevronLeft,
                    ),
                    _KeyboardShortcut.icon(
                      title: AppLocalizations.of(context)
                          .customizeEnemyDashKeyboardShortcutTitle,
                      keyboardIcon: FontAwesomeIcons.chevronRight,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .changeThemeKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .changeThemeKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .volumeKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .volumeKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .viewPuzzleReferenceKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .viewPuzzleReferenceKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .gameActionKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .gameActionKeyboardShortcutKey,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context).inGameKeyboardShortcutsTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: [
                    _KeyboardShortcut.icon(
                      title: AppLocalizations.of(context)
                          .moveTileUpwardKeyboardShortcutTitle,
                      keyboardIcon: FontAwesomeIcons.arrowUp,
                    ),
                    _KeyboardShortcut.icon(
                      title: AppLocalizations.of(context)
                          .moveTileDownwardKeyboardShortcutTitle,
                      keyboardIcon: FontAwesomeIcons.arrowDown,
                    ),
                    _KeyboardShortcut.icon(
                      title: AppLocalizations.of(context)
                          .moveTileToTheLeftKeyboardShortcutTitle,
                      keyboardIcon: FontAwesomeIcons.arrowLeft,
                    ),
                    _KeyboardShortcut.icon(
                      title: AppLocalizations.of(context)
                          .moveTileToTheRightKeyboardShortcutTitle,
                      keyboardIcon: FontAwesomeIcons.arrowRight,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: [
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .castSpellKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .castSpellKeyboardShortcutKey,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context)
                      .inDashAnimatorPreviewKeyboardShortcutsTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: [
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashIdlePoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashIdlePoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashHappyPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashHappyPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashTossPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashTossPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashTauntPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashTauntPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashExcitedPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashExcitedPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashSkepticismPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashSkepticismPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashShockedPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashShockedPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashLostPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashLostPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashWavePoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashWavePoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashCastSpellPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashCastSpellPoseKeyboardShortcutKey,
                    ),
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .dashWizardTauntPoseKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .dashWizardTauntPoseKeyboardShortcutKey,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  runSpacing: 8,
                  spacing: 32,
                  children: [
                    _KeyboardShortcut.text(
                      title: AppLocalizations.of(context)
                          .customizeDashAttireKeyboardShortcutTitle,
                      text: AppLocalizations.of(context)
                          .customizeDashAttireKeyboardShortcutKey,
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

class _KeyboardShortcut extends StatelessWidget {
  const _KeyboardShortcut.icon({
    required this.title,
    required this.keyboardIcon,
    Key? key,
  })  : text = null,
        super(key: key);

  const _KeyboardShortcut.text({
    required this.title,
    required this.text,
    Key? key,
  })  : keyboardIcon = null,
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
