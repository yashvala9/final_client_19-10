import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/auth/forgot_password/set_forget_password.dart';
import 'package:reel_ro/app/modules/auth/forgot_password/validate_forget_password.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/app/modules/auth/verify_email/verify_email.dart';
import 'package:reel_ro/app/routes/app_routes.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/constants.dart';
import 'package:reel_ro/utils/snackbar.dart';

class AuthController extends GetxController {
  final _authRepo = Get.put(AuthRepository());

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
  String forgetPassworedToken = '';
  String newPassword = '';
  String confirmPassword = '';

  String referrerId = '';

  void login() async {
    loading = true;
    try {
      final message = await _authRepo.signIn(email: email, password: password);
      debugPrint("LoginSuccess: $message");
      if (message == Constants.unverified) {
        await _storage.write(Constants.email, email);
        await _storage.write(Constants.password, password);
        Get.offAll(() => VerifyEmailView());
      } else {
        _authService.redirectUser();
      }
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("login: $e");
    }
    loading = false;
  }

  void refereshVerifyEmail(String e, String p) async {
    loading = true;

    try {
      final message = await _authRepo.signIn(email: e, password: p);
      debugPrint("LoginSuccess: $message");
      if (message == Constants.unverified) {
        Get.offAll(() => VerifyEmailView());
      } else {
        _authService.redirectUser();
      }
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("login: $e");
    }
    loading = false;
  }

  void sendVeifyEmailLink(String email) async {
    try {
      await _authRepo.sendVerifyEmailLink(email);
      showSnackBar("Veification email has been send");
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint(e.toString());
    }
  }

  void signup() async {
    loading = true;
    try {
      var map = {
        "username": userName.trim(),
        "email": email.trim(),
        "password": password.trim(),
      };
      await _authRepo.signUp(map);
      await _storage.write(Constants.email, email);
      await _storage.write(Constants.password, password);
      Get.off(
        () => VerifyEmailView(),
      );
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("login: $e");
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
      showSnackBar(e.toString(), color: const Color.fromARGB(255, 92, 90, 90));
      debugPrint("login: $e");
    }
    loading = false;
  }

  Future<void> signInwithGoogle() async {
    try {
      await _authRepo.signInWithGoogle();
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      debugPrint("googleSignIn: $e");
    }
  }

  void generateForgetPasswordToken(String email) async {
    loading = true;
    try {
      final message = await _authRepo.generateForgetPassword(email);
      showSnackBar(message);
      Get.off(() => ValidateForgetPassword(
            email: email,
          ));
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("forgetPassword: $e");
    }
    loading = false;
  }

  void validateForgetPassword(String email, String token) async {
    loading = true;
    try {
      final message = await _authRepo.validateForgetPasswordtoken(email, token);
      showSnackBar(message);
      Get.off(() => SetForgetPassword(email: email, token: token));
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("forgetPassword: $e");
    }
    loading = false;
  }

  void setForgettPassword(String email, String token, String password) async {
    loading = true;
    try {
      final message = await _authRepo.setForgetPassword(email, token, password);
      showSnackBar(message);
      Get.offAll(() => LoginScreen());
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("forgetPassword: $e");
    }
    loading = false;
  }

  void addReferral(
      String referrerUserId, String currentUserId, String token) async {
    try {
      await _authRepo.addReferrer(referrerUserId, token);
      await _authRepo.setRefferalStatus(currentUserId, token);
      await _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("addReferral: $e");
    }
  }

  void setReferralStatus(String currentUserId, String token) async {
    try {
      await _authRepo.setRefferalStatus(currentUserId, token);
      _authService.redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      debugPrint("setReferralstatus: $e");
    }
  }
}
