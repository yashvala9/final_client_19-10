import 'dart:io';

import 'package:get/get.dart';

import '../../../../models/profile_model.dart';
import '../../../../repositories/profile_repository.dart';
import '../../../../services/auth_service.dart';

class EditProfileController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _profileRepo = Get.put(ProfileRepository());

  ProfileModel get profileModel => _authService.profileModel!;
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
  int phone_pin = 0;
  int phone_number = 0;
  String bio = "";

  Future<void> updateProfile() async {
    loading = true;
    printInfo(info: "Id: ${_authService.userId}");
    try {
      var profileData = {
        "fullname":
            fullname == '' ? profileModel.user_profile!.fullname! : fullname,
        "bio": bio == '' ? profileModel.user_profile!.bio! : bio,
        "profile_img": "",
        "phone_pin": phone_pin == 0
            ? profileModel.user_profile!.phone_pin!
            : phone_pin.toString(),
        "phone_number": phone_number == 0
            ? profileModel.user_profile!.phone_number!
            : phone_number.toString(),
        "current_language": "en"
      };
      print('2121 profileData $profileData');
      await _profileRepo.updateProfile(profileData, _authService.token!);
      _authService.redirectUser();
    } catch (e) {
      print("updateProfile: $e");
    }
    loading = false;
  }
}
