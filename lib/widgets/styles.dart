import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double defaultPadding = 8;
const double defaultRadius = 16;

class Palette {
  static const primary500 = Color(0xFFDEC7FF);
  static const secondary500 = Color(0xFF686AB7);
  static const error = Color(0xFFEF476F);
  static const neutral900 = Color(0xFF000000);
  static const neutral300 = Color(0xFFEBEBEB);
  static const neutral100 = Color(0xFFFFFFFF);
}

final themeConfig = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Palette.primary500,
    onPrimary: Palette.neutral900,
    secondary: Palette.secondary500,
    onSecondary: Palette.neutral900,
    error: Palette.error,
    onError: Palette.neutral900,
    background: Palette.neutral300,
    onBackground: Palette.neutral900,
    surface: Palette.neutral300,
    onSurface: Palette.neutral900,
  ),
  brightness: Brightness.light,
  fontFamily: GoogleFonts.poppins().fontFamily,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: const MaterialStatePropertyAll(Palette.secondary500),
      foregroundColor: const MaterialStatePropertyAll(Palette.neutral100),
    ),
  ),
  textTheme: const TextTheme().copyWith(
    headlineLarge: GoogleFonts.redHatDisplay().copyWith(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
    titleLarge: GoogleFonts.redHatDisplay().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.redHatDisplay().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: GoogleFonts.redHatDisplay().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.poppins().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.poppins().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
  ),
);
