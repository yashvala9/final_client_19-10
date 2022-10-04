import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/add_referral/add_referral_screen.dart';
import 'package:reel_ro/app/modules/auth/create_profile/create_profile_view.dart';
import 'package:reel_ro/app/modules/auth/login/login_screen.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/user_model.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/communication_services.dart';

import '../app/modules/navigation_bar/navigation_bar_screen.dart';
import '../utils/constants.dart';
import '../utils/snackbar.dart';

class AuthService extends GetxService {
  final _authRepo = Get.put(AuthRepository());
  final _profileRepo = ProfileRepository();
  final _storage = GetStorage();
  UserModel? userModel;
  ProfileModel? profileModel;

  String? get token => _storage.read(Constants.token) != null
      ? _storage.read(Constants.token)['jwt']
      : null;
  int? get userId => _storage.read(Constants.token)[Constants.userId];

  bool get isAuthenticated => _storage.read(Constants.token);

  Future<void> redirectUser() async {
    final isLoggedIn = await _storage.read(Constants.token);
    debugPrint('2121 isLoggedIn != null ${isLoggedIn != null}');
    if (isLoggedIn != null) {
      final profile = await _profileRepo.getCurrentUsesr(token!);
      if (profile.user_profile != null) {
        profileModel = profile;

        if (!await _authRepo.getRefferalStatus(profile.id, token!)) {
          Get.offAll(() => AddReferralScreen());
        } else {
          var fcmToken = await FirebaseMessaging.instance.getToken();
          log("fcmToken: $fcmToken");
          await _authRepo.addToken(fcmToken!, token!);
          CommunicationService.to.authenticateUser(profile);
          Get.offAll(() => NavigationBarScreen());
        }
      } else {
        Get.off(() => CreateProfileView());
      }
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  Future<void> signOut() async {
    try {
      var fcmToken = await FirebaseMessaging.instance.getToken();
      await _authRepo.signOut(fcmToken!, token!);
      redirectUser();
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
    }
  }
}
