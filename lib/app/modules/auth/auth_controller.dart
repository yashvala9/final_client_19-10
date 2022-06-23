import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final _authRepo = Get.put(AuthRepository());

  RxBool loading = RxBool(false);
  RxBool obsecure = RxBool(false);

  String email = '';
  String password = '';
  String repeatPassword = "";
  String userName = '';
  String mobileNumber = "";
  String countryCode = "";

  String forgetPasswordEmail = "";

  void login() async {
    loading(true);
    try {
      await _authRepo.signIn(email: email, password: password);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print("login: $e");
    }
    loading(false);
  }

  void signup() async {
    loading(true);
    try {
      await _authRepo.signUp(email: email, password: password);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print("login: $e");
    }
    loading(false);
  }

  Future<void> signInwithGoogle() async {
    try {
      await _authRepo.signInWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      print("googleSignIn: $e");
    }
  }

  Future<void> forgetPassword() async{
    
    try {
      await _authRepo.forgetPassword();
    } catch (e) {
    print("forgetPassword: $e");
    }
  }
}
