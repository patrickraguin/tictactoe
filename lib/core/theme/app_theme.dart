import 'package:flutter/material.dart';

/// Construit le thème clair Material 3 à partir de la couleur de graine bleue.
ThemeData buildLightTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6FEB)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

/// Construit le thème sombre Material 3 à partir de la même couleur de graine.
ThemeData buildDarkTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2F6FEB),
        brightness: Brightness.dark,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
