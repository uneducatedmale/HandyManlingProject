import 'package:flutter/material.dart';

ThemeData customTheme = ThemeData(
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        Color(0xff1679ab),
      ),
      foregroundColor: WidgetStatePropertyAll(
        Colors.white,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  dialogTheme: const DialogTheme(
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Color(0xff5debd7),
  ),
  colorSchemeSeed: const Color(0xff1679ab),
);
