import 'dart:io';

import 'package:get/get.dart';
import 'package:reel_ro/repositories/auth_repository.dart';

class CreateProfileController extends GetxController {
  final _authRepo = Get.put(AuthRepository());
  String fullName = "";
  String about = "";

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

  void addProfileData() async {
    loading = true;
    try {
      _authRepo.addProfile();
    } catch (e) {
      print("addProfileDate: $e");
    }
    loading = false;
  }
}
