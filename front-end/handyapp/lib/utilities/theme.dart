import 'package:flutter/material.dart';

/*
  File: theme.dart
  Purpose:
  - Defines the custom theme for the app, standardizing the appearance of widgets and UI components.

  How It Works:
  - The `customTheme` object is a `ThemeData` instance that customizes various UI elements.
  - Applies consistent colors, text styles, and shapes across the app.

  Features:
  - **Elevated Buttons**:
    - Background color: `Color(0xff1679ab)` (blue).
    - Foreground color: `Colors.white` (white text).
  - **Input Fields**:
    - Borders are rounded with a 30-pixel radius.
  - **Text Styles**:
    - Large titles (`titleLarge`) are bold with a font size of 22.
  - **Scaffold Background**:
    - Default background color is white.
  - **Dialog Themes**:
    - Surface tint is disabled for a flat appearance.
  - **Bottom Sheets**:
    - Background color: `Color(0xff5debd7)` (light teal).
  - **Color Scheme**:
    - Primary seed color is `Color(0xff1679ab)` (blue).

  Files It Interacts With:
  - Used across all pages and widgets in the app to maintain a unified visual style.
  - Supports pages such as `home_page.dart`, `memo_page.dart`, `materials_page.dart`, `labor_page.dart`, and `finances_page.dart`.

  Notes:
  - This file simplifies the process of updating the app's UI style by centralizing theme configuration.
  - Ensure to import this file in `main.dart` or other relevant files to apply the theme globally.
*/

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
