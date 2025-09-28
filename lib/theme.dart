import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Couleurs — Charte MSM
const kMarine = Color(0xFF1692AD); // #1692AD
const kOutremer = Color(0xFFACBBE9); // #ACBBE9
const kJaune = Color(0xFFFFD660); // #FFD660
const kDore = Color(0xFFCB9D36); // #CB9D36
const kBlanc = Color(0xFFFFFFFF); // #FFFFFF
const kNoir = Color(0xFF000000); // #000000

// Text styles helpers
TextStyle leagueSpartanStyle({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? letterSpacing,
  double? height,
}) {
  return GoogleFonts.leagueSpartan(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

ThemeData buildAppTheme() {
  final baseTextTheme = GoogleFonts.leagueSpartanTextTheme();

  final colorScheme = ColorScheme.fromSeed(
    seedColor: kMarine,
    primary: kMarine,
    onPrimary: kBlanc,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: kBlanc,
    textTheme: baseTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: kMarine,
      foregroundColor: kBlanc,
      titleTextStyle: baseTextTheme.titleLarge?.copyWith(
        color: kBlanc,
        fontWeight: FontWeight.w700,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
