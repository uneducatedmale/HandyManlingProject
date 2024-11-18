import 'package:get/get.dart';
import 'package:handyapp/pages/home_page.dart';
import 'package:handyapp/pages/memo_page.dart';
import 'package:handyapp/pages/materials_page.dart';
import 'package:handyapp/pages/labor_page.dart';
import 'package:handyapp/pages/finances_page.dart';

/*
  File: routes.dart
  Purpose:
  - Defines the application's navigation routes and maps them to corresponding pages.

  How It Works:
  - The `Routes` class provides static string constants for route names.
  - The `getPages` list uses `GetPage` from `GetX` to associate each route with its respective page widget.

  Features:
  - Centralized management of app routes to simplify navigation.
  - Ensures type safety and eliminates the need for hardcoding route strings throughout the app.

  Routes and Associated Pages:
  - `/home_page`: Displays the `HomePage` for user authentication.
  - `/memo_page`: Displays the `MemoPage` for project memos.
  - `/materials_page`: Displays the `MaterialsPage` for managing materials associated with projects.
  - `/labor_page`: Displays the `LaborPage` for managing laborers tied to projects.
  - `/finances_page`: Displays the `FinancesPage` for tracking financial details of projects.

  Files It Interacts With:
  - `home_page.dart`: Provides the `HomePage` widget.
  - `memo_page.dart`: Provides the `MemoPage` widget.
  - `materials_page.dart`: Provides the `MaterialsPage` widget.
  - `labor_page.dart`: Provides the `LaborPage` widget.
  - `finances_page.dart`: Provides the `FinancesPage` widget.

  Notes:
  - This file serves as the primary navigation configuration for the app, leveraging `GetX` for route management.
*/

class Routes {
  static String homePage = '/home_page';
  static String memoPage = '/memo_page';
  static String materialsPage = '/materials_page';
  static String laborPage = '/labor_page';
  static String financesPage = '/finances_page';
}

final getPages = [
  GetPage(
    name: Routes.homePage,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.memoPage,
    page: () => const MemoPage(),
  ),
  GetPage(
    name: Routes.materialsPage,
    page: () => const MaterialsPage(),
  ),
  GetPage(
    name: Routes.laborPage,
    page: () => const LaborPage(),
  ),
  GetPage(
    name: Routes.financesPage,
    page: () => const FinancesPage(),
  ),
];
