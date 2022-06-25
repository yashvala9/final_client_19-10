import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/signup_screen.dart';
import 'package:reel_ro/app/modules/navigation_bar/navigation_bar_screen.dart';
import 'package:reel_ro/app/modules/splash/splash_screen.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import '../modules/auth/login_screen.dart';
import '../modules/homepage/homepage_screen.dart';

class AppPages {
  static const initial = AppRoutes.navigationBar;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePageScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(),
    ),
    GetPage(
      name: AppRoutes.navigationBar,
      page: () => NavigationBarScreen(),
    ),
  ];
}
