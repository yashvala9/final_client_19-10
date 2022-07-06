import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/search/search_screen.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/user_model.dart';

import '../../../repositories/profile_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/snackbar.dart';

class SearchController extends GetxController {
  final _storage = GetStorage();

  String? get token => _storage.read(Constants.token)['jwt'];
  int? get userId => _storage.read(Constants.token)[Constants.userId];
  ProfileModel? searchProfileModel;

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
      searchProfileModel =
          await _profileRepo.getProfileByUserName(username, token!);
      print(searchProfileModel);
    } catch (e) {
      showSnackBar(e.toString(), color: Color.fromARGB(255, 92, 90, 90));
      print("searchUser: $e");
    }
    loading = false;
    
  }
}
