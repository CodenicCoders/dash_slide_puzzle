import 'package:application/application.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTheme {
  static ThemeData option(ThemeOption themeOption) {
    final Color primaryColor;
    final Color primaryColorDark;
    final Color scaffoldBackgroundColor;

    switch (themeOption) {
      case ThemeOption.day:
        primaryColor = Colors.lightBlue;
        primaryColorDark = const Color(0xff007ac1);
        scaffoldBackgroundColor = const Color(0xff67daff);
        break;
      case ThemeOption.prevening:
        primaryColor = Colors.amber;
        primaryColorDark = const Color(0xffc79100);
        scaffoldBackgroundColor = Colors.amber.shade400;
        break;
      case ThemeOption.night:
        primaryColor = Colors.indigo;
        primaryColorDark = const Color(0xff002984);
        scaffoldBackgroundColor = const Color(0xff757de8);
        break;
    }

    return ThemeData.light().copyWith(
      typography: Typography.material2018(),
      colorScheme: const ColorScheme.light().copyWith(primary: primaryColor),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      textTheme: GoogleFonts.bangersTextTheme(),
    );
  }
}
