import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/app/modules/homepage/home_page.dart';
import 'package:reel_ro/app/routes/app_page.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/models/user_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/user_repository.dart';

import '../utils/constants.dart';

class AuthService extends GetxService {
  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepository());
  final _storage = GetStorage();
  UserModel? userModel;

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
    if (isLoggedIn != null) {
      Get.off(() => HomePage());
    } else {
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
