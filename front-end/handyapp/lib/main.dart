import 'package:flutter/material.dart';
import 'utilities/theme.dart';
import 'package:get/get.dart';
import 'utilities/dependencies.dart' as dependencies;
import 'utilities/routes.dart' as routes;
import 'pages/home_page.dart';

/*
  File: main.dart
  Purpose:
  - Serves as the entry point for the Handyman App.
  - Configures the global theme, navigation, and initial dependencies.

  How It Works:
  - The `main()` function initializes the app and launches the `MyApp` widget.
  - The `MyApp` widget:
    - Uses `GetMaterialApp` for navigation and dependency management.
    - Applies the custom theme defined in `theme.dart`.
    - Disables the debug banner for a clean interface.
    - Sets up the initial dependency bindings using `dependencies.InitialBindings()`.
    - Registers app routes using `routes.getPages`.
    - Displays `HomePage` as the initial screen.

  Features:
  - Centralized routing with `routes.dart`.
  - Global theme application with `theme.dart`.
  - Dependency injection via `dependencies.dart`.
  - Provides a clean and scalable structure for managing the app.

  Files It Interacts With:
  - **`home_page.dart`**: Displays the initial Home Page.
  - **`theme.dart`**: Defines the visual style for the app.
  - **`routes.dart`**: Manages navigation between app pages.
  - **`dependencies.dart`**: Handles dependency injection and controller setup.

  Notes:
  - This file should remain minimal, delegating logic to specialized utilities and widgets.
  - Any changes to the app's initial configuration should be made here.
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Handyman App',
      theme: customTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: dependencies.InitialBindings(),
      getPages: routes.getPages,
      home: const HomePage(),
    );
  }
}
