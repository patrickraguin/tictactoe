import 'package:flutter/material.dart';

const _seed = Color(0xFF2F6FEB);
const _cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(20)),
);
const _buttonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
);

ThemeData buildLightTheme() => _base(ColorScheme.fromSeed(seedColor: _seed));

ThemeData buildDarkTheme() => _base(
      ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
    );

ThemeData _base(ColorScheme colorScheme) => ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: const CardThemeData(elevation: 0, shape: _cardShape),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: _buttonShape),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: _buttonShape),
      ),
    );
