import 'package:flutter/material.dart';

const Color _backgroundColor = Color(0xff9c27b0);

final tema = ThemeData(
  primaryColor: _backgroundColor,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: _backgroundColor
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(_backgroundColor)
    )
  )
);