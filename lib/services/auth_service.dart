import 'package:get/get.dart';
import 'package:reel_ro/app/routes/app_page.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/models/user_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/user_repository.dart';

class AuthService extends GetxService {
  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepository());

  UserModel? userModel;

  Future<void> redirectUser() async {
    var user = _authRepo.user;
    if (user == null) {
      Get.offAllNamed(AppRoutes.getStarted);
      return;
    }
    userModel = await _userRepo.getUserProfile(user.uid);
    if (userModel == null) {
      Get.toNamed(AppRoutes.createProfile);
    } else {
      Get.toNamed(AppRoutes.home);
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepo.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print("signOut: $e");
    }
  }
}
