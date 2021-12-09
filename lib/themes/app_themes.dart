import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/constants/constants.dart';

class MyThemes {
  static final ThemeData darkTheme = ThemeData(
    textTheme: GoogleFonts.nunitoSansTextTheme(),
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    scaffoldBackgroundColor: DarkTheme.backgroundColor,
    iconTheme: const IconThemeData(color: DarkTheme.iconColor),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Neutral.fabColor),
    primaryColor: DarkTheme.headingColor,
    bottomAppBarColor: DarkTheme.contentColor,
    backgroundColor: DarkTheme.borderColor,
    cardColor: DarkTheme.cardColor,
    colorScheme: const ColorScheme.dark(),
  );

  static final ThemeData lightTheme = ThemeData(
    fontFamily: GoogleFonts.nunitoSans().fontFamily,
    scaffoldBackgroundColor: LightTheme.backgroundColor,
    iconTheme: const IconThemeData(color: LightTheme.iconColor),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Neutral.fabColor),
    primaryColor: LightTheme.headingColor,
    bottomAppBarColor: LightTheme.contentColor,
    backgroundColor: LightTheme.borderColor,
    cardColor: LightTheme.cardColor,
    colorScheme: const ColorScheme.light(),
  );
}
