import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _primaryColor = Colors.orange;

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(double.infinity, 38),
      maximumSize: const Size(double.infinity, 48),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 38),
        maximumSize: const Size(double.infinity, 48),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        side: const BorderSide(color: _primaryColor)),
  ),
  colorScheme: const ColorScheme.light(
    primary: _primaryColor,
    secondary: Colors.orangeAccent,
    background: Colors.white,
  ),
);
