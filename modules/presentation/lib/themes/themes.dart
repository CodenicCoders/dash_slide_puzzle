import 'package:application/application.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Contains the available themes for the app.
class Themes {
  /// Returns the correct theme based on the given [themeOption].
  static ThemeData theme(ThemeOption themeOption) {
    final Color primaryColor;
    final Color primaryColorDark;
    final Color primaryColorLight;

    switch (themeOption) {
      case ThemeOption.day:
        primaryColor = Colors.blue.shade600;
        primaryColorLight = const Color(0xff69b6ff);
        primaryColorDark = const Color(0xff005bb2);
        break;
      case ThemeOption.prevening:
        primaryColor = Colors.purple;
        primaryColorLight = const Color(0xffc158dc);
        primaryColorDark = const Color(0xff5c007a);
        break;
      case ThemeOption.night:
        primaryColor = Colors.indigo;
        primaryColorLight = const Color(0xff6f74dd);
        primaryColorDark = const Color(0xff00227b);
        break;
    }

    return ThemeData(
      typography: Typography.material2018(),
      colorScheme: const ColorScheme.light().copyWith(primary: primaryColor),
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      textTheme: GoogleFonts.bangersTextTheme(),
    );
  }
}
