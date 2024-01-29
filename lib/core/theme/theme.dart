import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const mainColor = Color(0xFF508991);

final kScheme = ColorScheme.fromSwatch(
  primarySwatch: createMaterialColor(mainColor),
  accentColor: mainColor,
);

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

ThemeData getTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: kScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: kScheme.background,
      foregroundColor: kScheme.onBackground,
      titleTextStyle: TextStyle(
        color: kScheme.onBackground,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
