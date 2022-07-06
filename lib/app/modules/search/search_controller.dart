import 'dart:ui';

import 'package:get/get.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/user_model.dart';

import '../../../repositories/profile_repository.dart';
import '../../../utils/snackbar.dart';

class SearchController extends GetxController {
  bool _loading = false;
  final _profileRepo = Get.put(ProfileRepository());
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  void searchUser(String username) async {
    print("username: $username");
    loading = true;
    try {
      ProfileModel searchProfileModel =
          await _profileRepo.getProfileByUserName(username);
      print(searchProfileModel);
    } catch (e) {
      showSnackBar(e.toString(), color: Color.fromARGB(255, 92, 90, 90));
      print("login: $e");
    }
    loading = false;
  }
}
