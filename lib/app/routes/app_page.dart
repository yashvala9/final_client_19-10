import 'package:get/get.dart';
import 'package:reel_ro/app/modules/entry_count/views/entry_count_view.dart';
import 'package:reel_ro/app/modules/giveaway/views/giveaway_view.dart';
import 'package:reel_ro/app/modules/navigation_bar/navigation_bar_screen.dart';
import 'package:reel_ro/app/modules/referrals/views/referrals_view.dart';
import 'package:reel_ro/app/modules/send_invite/views/send_invite_view.dart';
import 'package:reel_ro/app/modules/splash/splash_screen.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import '../modules/ContestDates/views/contest_dates_view.dart';
import '../modules/ContestRules/views/contest_rules_view.dart';
import '../modules/homepage/homepage_screen.dart';
import 'package:reel_ro/app/modules/auth/create_profile/create_profile_view.dart';
import 'package:reel_ro/app/modules/auth/forgot_password/forgot_password_view.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/app/modules/auth/reset_password/reset_password_view.dart';
import 'package:reel_ro/app/modules/auth/sign_up/signup_screen.dart';
import 'package:reel_ro/app/modules/get_started/get_started_view.dart';

import '../modules/profile/profile_screen.dart';
import '../modules/winners/views/winners_view.dart';

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
      page: () => HomePageScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordView(),
    ),
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
    GetPage(
      name: AppRoutes.navigationBar,
      page: () => NavigationBarScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.entryCount,
      page: () => EntryCountView(),
    ),
    GetPage(
      name: AppRoutes.sendInvite,
      page: () => SendInviteView(),
    ),
    GetPage(
      name: AppRoutes.referrals,
      page: () => ReferralsView(),
    ),
    GetPage(
      name: AppRoutes.giveaway,
      page: () => GiveawayView(),
    ),
    GetPage(
      name: AppRoutes.winners,
      page: () => WinnersView(),
    ),
    GetPage(
      name: AppRoutes.contestDates,
      page: () => ContestDatesView(),
    ),
    GetPage(
      name: AppRoutes.contestRules,
      page: () => ContestRulesView(),
    ),
  ];
}
