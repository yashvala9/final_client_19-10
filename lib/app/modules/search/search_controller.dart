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

import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';
import '../../../repositories/reel_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/snackbar.dart';

class SearchController extends GetxController {
  SearchController();

  final _profileRepo = Get.put(ProfileRepository());
  final _authService = Get.put(AuthService());

  final _reelRepo = Get.put(ReelRepository());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  bool loadingMore = false;
  bool _loadMore = true;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  List<ReelModel> _reelList = [];
  List<ReelModel> get reelList => _reelList;
  set reelList(List<ReelModel> reelList) {
    _reelList = reelList;
    update();
  }

  List<ProfileModel> _searchProfiles = [];
  List<ProfileModel> get searchProfiles => _searchProfiles;
  set searchProfiles(List<ProfileModel> searchProfiles) {
    _searchProfiles = searchProfiles;
    update();
  }

  List<ReelModel> _searchReels = [];
  List<ReelModel> get searchReels => _searchReels;
  set searchReels(List<ReelModel> searchReels) {
    _searchReels = searchReels;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  void searchUser(String username) async {
    print("username: $username");
    loading = true;
    try {
      searchProfiles = await _profileRepo.searchByUserName(username, token!);
      log("searchResult: $searchProfiles");
    } catch (e) {
      // showSnackBar(e.toString(), color: Colors.red);
      print("searchUser: $e");
    }
    loading = false;
  }

  void getReelsByHashTag(String hashTag) async {
    loading = true;
    try {
      searchReels = await _reelRepo
          .getReelsByHashTag(hashTag, profileId!, token!, limit: 500, skip: 0);
    } catch (e) {
      // showSnackBar(e.toString(), color: Colors.red);
      print("getFeeds: $e");
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

  void getMoreFeed(int currentLength) async {
    loadingMore = true;
    if (_loadMore) {
      try {
        var newList = await _reelRepo.getFeedsWithAds(profileId!, token!,
            limit: 10, skip: currentLength);
        if (newList.isEmpty) {
          _loadMore = false;
        } else {
          reelList.addAll(newList);
        }
        update();
      } catch (e) {
        showSnackBar(e.toString(), color: Colors.red);
        print("getFeeds: $e");
      }
    }
    loadingMore = false;
  }
}
