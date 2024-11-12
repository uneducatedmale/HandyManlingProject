import 'package:get/get.dart';
import 'package:handyapp/pages/home_page.dart';
import 'package:handyapp/pages/memo_page.dart';
import 'package:handyapp/pages/materials_page.dart';
import 'package:handyapp/pages/labor_page.dart';
import 'package:handyapp/pages/finances_page.dart';

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
