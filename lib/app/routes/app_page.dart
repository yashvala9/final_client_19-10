import 'package:get/get.dart';
import 'package:reel_ro/app/modules/auth/create_profile/create_profile_view.dart';
import 'package:reel_ro/app/modules/auth/forgot_password/forgot_password_view.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/app/modules/auth/reset_password/reset_password_view.dart';
import 'package:reel_ro/app/modules/auth/sign_up/signup_screen.dart';
import 'package:reel_ro/app/modules/auth/verify_email/verify_email.dart';
import 'package:reel_ro/app/modules/get_started/get_started_view.dart';
import 'package:reel_ro/app/modules/splash/splash_screen.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import '../modules/homepage/home_page.dart';

class AppPages {
  static const initial = AppRoutes.splash;

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
      name: AppRoutes.getStarted,
      page: () => const GetStarted(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordView(),
    ),
    // GetPage(
    //   name: AppRoutes.verifyEmail,
    //   page: () => VerifyEmailView(),
    // ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordView(),
    ),
    GetPage(
      name: AppRoutes.createProfile,
      page: () => CreateProfileView(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignupScreen(),
    ),
  ];
}
