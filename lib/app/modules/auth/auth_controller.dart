import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/models/user_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/user_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';

class AuthController extends GetxController {
  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepository());
  final _authService = Get.find<AuthService>();

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
    loading=true;
    try {
      await _authRepo.signIn(email: email, password: password);
      _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("login: $e");
    }
    loading=false;
  }

  void signup() async {
    loading=true;
    var userModel = UserModel(
        id: "",
        username: userName,
        email: email,
        countryCode: countryCode,
        mobileNumber: mobileNumber);
    try {
      await _authRepo.signUp(email: email, password: password);
      await _userRepo.createProfile(userModel);
      _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("login: $e");
    }
    loading=      false;
  }

  Future<void> signInwithGoogle() async {
    try {
      await _authRepo.signInWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      print("googleSignIn: $e");
    }
  }

  Future<void> forgetPassword() async {
    loading = true;
    try {
      await _authRepo.forgetPassword();
    } catch (e) {
      print("forgetPassword: $e");
    }
    loading = false;
  }
}
