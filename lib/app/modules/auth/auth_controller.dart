import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/auth/verify_email/verify_email.dart';
import 'package:reel_ro/app/modules/homepage/homepage_screen.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/models/user_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/constants.dart';
import 'package:reel_ro/utils/snackbar.dart';

import '../navigation_bar/navigation_bar_screen.dart';

class AuthController extends GetxController {
  final _authRepo = Get.put(AuthRepository());
  // final _userRepo = Get.put(UserRepository());
  final _authService = Get.find<AuthService>();

  final _storage = GetStorage();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  bool _obsecure = false;
  bool get obsecure => _obsecure;
  set obsecure(bool obsecure) {
    _obsecure = obsecure;
    update();
  }

  bool _obsecure2 = false;
  bool get obsecure2 => _obsecure2;
  set obsecure2(bool obsecure2) {
    _obsecure2 = obsecure2;
    update();
  }

  String email = '';
  String password = '';
  String repeatPassword = "";
  String userName = '';
  String mobileNumber = "";
  String countryCode = "";

  String forgetPasswordEmail = "";

  void login() async {
    loading = true;
    try {
      final message = await _authRepo.signIn(email: email, password: password);
      print("LoginSuccess: $message");
      _authService.redirectUser();
    } catch (e) {
      if (e == "Your account email is not confirmed") {
        var data = {
          'email': email.trim(),
          'password': password.trim(),
        };
        await _authRepo.signUp(data);
        Get.offAll(() => VerifyEmailView(data: data));
        return;
      }
      showSnackBar(e.toString(), color: Colors.red);
      print("login: $e");
    }
    loading = false;
  }

  void signup() async {
    loading = true;
    try {
      var map = {
        "username": "",
        "email": email.trim(),
        "password": password.trim(),
      };
      await _authRepo.signUp(map);
      Get.off(
        () => VerifyEmailView(
          data: map,
        ),
      );
      // _storage.write(Constants.token, token);
      // await _userRepo.createProfile(userModel);
      // _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("login: $e");
    }
    loading = false;
  }

  void verifyOtp(Map<String, dynamic> data) async {
    loading = true;
    try {
      final tokenId = await _authRepo.verifyOtp(data);
      _storage.write(Constants.token, tokenId);
      _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Color.fromARGB(255, 92, 90, 90));
      print("login: $e");
    }
    loading = false;
  }

  Future<void> signInwithGoogle() async {
    try {
      await _authRepo.signInWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      print("googleSignIn: $e");
    }
  }

  void forgetPassword(String email) async {
    loading = true;
    try {
      await _authRepo.forgetPassword(email);
    } catch (e) {
      print("forgetPassword: $e");
    }
    loading = false;
  }
}
