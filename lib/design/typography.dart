import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextStyle get pageTitle => GoogleFonts.lato(
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w800,
  );

  static TextStyle get pageSubtitle =>
      GoogleFonts.lato(fontSize: 16, height: 1.4, fontWeight: FontWeight.w400);

  static TextStyle get cardTitle =>
      GoogleFonts.lato(fontSize: 18, height: 1.33, fontWeight: FontWeight.w700);

  static TextStyle get badgeLabel => GoogleFonts.lato(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get buttonLabel =>
      GoogleFonts.lato(fontSize: 16, height: 1.5, fontWeight: FontWeight.w700);

  static TextStyle get navigationLabel => GoogleFonts.lato(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
  );

  static TextTheme textTheme(ColorScheme colorScheme) {
    return GoogleFonts.latoTextTheme()
        .copyWith(
          headlineSmall: pageTitle,
          titleMedium: cardTitle,
          bodyLarge: pageSubtitle,
        )
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        );
  }

  static double lineHeightOf(TextStyle style) =>
      style.fontSize! * style.height!;
}
