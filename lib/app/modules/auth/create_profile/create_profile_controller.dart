import 'dart:io';

import 'package:get/get.dart';
import 'package:reel_ro/repositories/auth_repository.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';

class CreateProfileController extends GetxController {
  // final _authRepo = Get.put(AuthRepository());
  final _authService = Get.find<AuthService>();
  final _profileRepo = Get.put(ProfileRepository());
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  File? _file;
  File? get file => _file;
  set file(File? image) {
    _file = image;
    update();
  }

  String username = '';
  String fullname = '';
  int countryCode = 0;
  int mobileNumber = 0;
  String bio = "";

  void addProfileData() async {
    loading = true;
    printInfo(info: "Id: ${_authService.userId}");
    try {
      var profileData = {
        'fullname': fullname,
        'bio': bio,
        'phone_pin': countryCode,
        'current_language': 'en',
        'phone_number': mobileNumber,
        'profile_img': "",
      };
      await _profileRepo.updateProfile(profileData, _authService.token!);
      _authService.redirectUser();
    } catch (e) {
      print("addProfileDate: $e");
    }
    loading = false;
  }
}
