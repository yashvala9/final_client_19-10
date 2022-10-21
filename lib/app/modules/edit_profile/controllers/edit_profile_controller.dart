import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/profile_model.dart';
import '../../../../repositories/profile_repository.dart';
import '../../../../services/auth_service.dart';
import 'package:path/path.dart' as path;

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
  String country = '';
  String state = '';
  int phone_pin = 0;
  int phone_number = 0;
  String bio = "";

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var filepath = file.path;
    var lastSeparator = filepath.lastIndexOf(Platform.pathSeparator);
    var extension = path.extension(file.path).toString();
    var newPath =
        filepath.substring(0, lastSeparator + 1) + newFileName + extension;
    return file.rename(newPath);
  }

  String genFileName(String userID, String fileName) {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    return 'reel_${userID}_${date}_${timestamp}_$fileName';
  }

  Future<void> updateProfile() async {
    loading = true;
    try {
      String _fileName = '';

      if (file != null) {
        file = await changeFileNameOnly(file!, 'image');
        _fileName = genFileName("Profile", path.basename(file!.path));

        final s3File = await _profileRepo.uploadProfileToAwsS3(
            userID: "Profile", file: file!, fileName: _fileName);
      }

      var profileData = {
        "fullname":
            fullname == '' ? profileModel.user_profile!.fullname! : fullname,
        "bio": bio == '' ? profileModel.user_profile!.bio! : bio,
        "profile_img": _fileName == ''
            ? profileModel.user_profile!.profile_img!
            : _fileName,
        "phone_pin": phone_pin == 0
            ? profileModel.user_profile!.phone_pin!
            : phone_pin.toString(),
        "phone_number": phone_number == 0
            ? profileModel.user_profile!.phone_number!
            : phone_number.toString(),
        "current_language": "en",
        "country":
            country == '' ? profileModel.user_profile!.country! : country,
        "state": state == '' ? profileModel.user_profile!.state! : state
      };
      await _profileRepo.updateProfile(profileData, _authService.token!);
      _fileName = '';

      final profile = await _profileRepo.getCurrentUsesr(_authService.token!);
      if (profile.user_profile != null) {
        _authService.profileModel = profile;
      }
      update();
      Get.back();
    } catch (e) {
      debugPrint("updateProfile: $e");
    }
    loading = false;
  }
}
