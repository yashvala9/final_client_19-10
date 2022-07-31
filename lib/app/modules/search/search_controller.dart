import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reel_ro/app/modules/profile/profile_controller.dart';
import 'package:reel_ro/app/modules/search/search_screen.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/models/user_model.dart';
import 'package:reel_ro/services/auth_service.dart';

import '../../../repositories/profile_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/snackbar.dart';

class SearchController extends GetxController {
  final String username;
  SearchController(this.username);

  final _profileRepo = Get.put(ProfileRepository());
  final _authService = Get.put(AuthService());
  final _profileControllere = Get.find<ProfileController>();

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  List<ProfileModel> _searchProfiles = [];
  List<ProfileModel> get searchProfiles => _searchProfiles;
  set searchProfiles(List<ProfileModel> searchProfiles) {
    _searchProfiles = searchProfiles;
    update();
  }

  @override
  void onInit() {
    searchUser(username);
    super.onInit();
  }

  void searchUser(String username) async {
    print("username: $username");
    loading = true;
    try {
      searchProfiles = await _profileRepo.searchByUserName(username, token!);
      log("searchResult: $searchProfiles");
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("searchUser: $e");
    }
    loading = false;
  }

  void toggleFollowing(int index) async {
    // searchProfiles[index].isFollowing = !searchProfiles[index].isFollowing!;
    // if (searchProfiles[index].isFollowing!) {
    //   searchProfiles[index].followerCount++;
    //   _profileControllere.profileModel.followingCount++;
    // } else {
    //   searchProfiles[index].followerCount--;
    //   _profileControllere.profileModel.followingCount--;
    // }
    try {
      _profileRepo.toggleFollow(searchProfiles[index].id, token!);
      update();
    } catch (e) {
      log("toggleFollowingError: $e");
    }
  }
}
