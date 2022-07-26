import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/auth/create_profile/create_profile_view.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/app/modules/homepage/homepage_screen.dart';
import 'package:reel_ro/app/routes/app_page.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/user_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/repositories/user_repository.dart';

import '../app/modules/navigation_bar/navigation_bar_screen.dart';
import '../utils/constants.dart';

class AuthService extends GetxService {
  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepository());
  final _profileRepo = Get.put(ProfileRepository());
  final _storage = GetStorage();
  UserModel? userModel;
  ProfileModel? profileModel;

  String? get token => _storage.read(Constants.token)['jwt'];
  int? get userId => _storage.read(Constants.token)[Constants.userId];

  Future<void> redirectUser() async {
    // var user = _authRepo.user;
    // if (user == null) {
    //   Get.offAllNamed(AppRoutes.getStarted);
    //   return;
    // }
    // userModel = await _userRepo.getUserProfile(user.uid);
    // if (userModel == null) {
    //   Get.toNamed(AppRoutes.createProfile);
    // } else {
    //   Get.toNamed(AppRoutes.home);
    // }
    final isLoggedIn = await _storage.read(Constants.token);

    print('2121 isLoggedIn != null ${isLoggedIn != null}');
    if (isLoggedIn != null) {
      final profile = await _profileRepo.getCurrentUsesr(token!);
      if (profile.user_profile != null) {
        print('2121 $profile');
        profileModel = profile;

        Get.off(() => NavigationBarScreen());
      } else {
        Get.off(() => CreateProfileView());
      }
    } else {
      // Get.toNamed(AppRoutes.login_then("afterSuccessfulLogin"));
      Get.off(() => LoginScreen());
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepo.signOut();
      redirectUser();
    } catch (e) {
      print("signOut: $e");
    }
  }
}
