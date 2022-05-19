import 'package:get/get.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/repositories/auth_repository.dart';

class AuthService extends GetxService {
  final _authRepo = Get.put(AuthRepository());

  Future<void> redirectUser() async {
    var user = _authRepo.user;
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.offAllNamed(AppRoutes.home);
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
