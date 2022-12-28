import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reel_ro/repositories/profile_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:path/path.dart' as path;

class CreateProfileController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _profileRepo = Get.put(ProfileRepository());

  bool _loading = false;

  FormGroup addVendorForm = FormGroup({
    'vendorName': FormControl(validators: [
      Validators.required,
    ]),
    'email': FormControl(validators: [Validators.required, Validators.email]),
    'companyid': FormControl(validators: [
      Validators.required,
    ]),
    'taxnumber': FormControl(validators: [
      Validators.required,
    ]),
    'phone': FormControl(validators: [Validators.required, Validators.number]),
    'discription': FormControl(validators: [
      Validators.required,
    ]),
    'website': FormControl(
        validators: [Validators.required, Validators.pattern(".com")]),
    'contactPerson': FormControl(validators: [
      Validators.required,
    ]),
    'address': FormControl(validators: [
      Validators.required,
    ]),
    'category': FormControl<String>(),
    'status': FormControl<String>(),
    'location': FormControl<String>(),
    'region': FormControl<String>(),
    'country': FormControl<String>(),
    'password': FormControl(validators: [
      Validators.required,
    ]),
  });
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
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString city = ''.obs;
  int countryCode = 0;
  int mobileNumber = 0;
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
    final date = DateFormat('yyyyMMdd').format(DateTime.now().toUtc());
    return 'reel_${userID}_${date}_${timestamp}_$fileName';
  }

  void addProfileData() async {
    loading = true;
    try {
      file = await changeFileNameOnly(file!, 'image');
      final String _fileName =
          genFileName("Profile", path.basename(file!.path));

      await _profileRepo.uploadProfileToAwsS3(
          userID: "Profile", file: file!, fileName: _fileName);
      var profileData = {
        'fullname': fullname,
        'bio': bio,
        'phone_pin': countryCode,
        'current_language': 'en',
        'phone_number': mobileNumber,
        'profile_img': _fileName,
        "country": country.value,
        "state": state.value,
      };
      await _profileRepo.createProfile(profileData, _authService.token!);
      _authService.redirectUser();
    } catch (e) {
      debugPrint("addProfileDate: $e");
    }
    loading = false;
  }

  void signOut() async {
    await _authService.signOut();
  }
}
