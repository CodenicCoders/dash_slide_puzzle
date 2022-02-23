import 'package:flutter/material.dart';
import 'package:presentation/assets/assets.dart';
import 'package:presentation/l10n/app_localizations.dart';
import 'package:presentation/puzzle/page/puzzle_page.dart';
import 'package:simple_shadow/simple_shadow.dart';

/// {@template AppBarTitle}
///
/// The app bar title for the [PuzzlePage].
///
/// {@endtemplate}
class AppBarTitle extends StatelessWidget {
  /// {@macro AppBarTitle}
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SimpleShadow(
            offset: Offset.zero,
            child: Image.asset(LogoAssets.flutter, scale: 6),
          ),
          const SizedBox(width: 8),
          SimpleShadow(
            offset: Offset.zero,
            child: Text(AppLocalizations.of(context).appTitle),
          ),
        ],
      ),
    );
  }
}
