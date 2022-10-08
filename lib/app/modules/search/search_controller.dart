import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/profile_model.dart';
import 'package:reel_ro/services/auth_service.dart';

import '../../../models/reel_model.dart';
import '../../../repositories/profile_repository.dart';
import '../../../repositories/reel_repository.dart';
import '../../../utils/snackbar.dart';

class SearchController extends GetxController {
  SearchController();

  final _profileRepo = ProfileRepository();
  final _authService = Get.put(AuthService());

  final _reelRepo = ReelRepository();

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;
  set loadingMore(bool loadingMore) {
    _loadingMore = loadingMore;
    update();
  }

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
  List<ProfileModel> get searchProfiles =>
      _searchProfiles.where((element) => element.id != profileId).toList();
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

  void updateMannual() {
    update();
  }

  @override
  void onInit() {
    getFeeds();
    super.onInit();
  }

  void getFeeds() async {
    loading = true;
    try {
      reelList = await _reelRepo.getFeedsWithAds(profileId!, token!,
          limit: 10, skip: 0);
    } catch (e) {
      print("getFeeds: $e");
    }
    loading = false;
    _loadMore = true;
  }

  void getMoreFeed(int currentLength) async {
    loadingMore = true;
    if (_loadMore) {
      try {
        var newList = await _reelRepo.getFeedsWithAds(profileId!, token!,
            limit: 10, skip: currentLength);
        if (newList.isEmpty) {
          loadingMore = false;
          _loadMore = false;
        } else {
          reelList.addAll(newList);
        }
        update();
      } catch (e) {
        print("getMoreFeed: $e");
      }
    }
    loadingMore = false;
  }

  void searchUser(String username) async {
    loading = true;
    try {
      searchProfiles = await _profileRepo.searchByUserName(username, token!);
      log("searchResult: $searchProfiles");
    } catch (e) {
      log("searchUser: $e");
    }
    loading = false;
  }

  void getReelsByHashTag(String hashTag) async {
    loading = true;
    try {
      searchReels = await _reelRepo
          .getReelsByHashTag(hashTag, profileId!, token!, limit: 500, skip: 0);
    } catch (e) {
      log("getReelsByHashTag: $e");
    }
    loading = false;
  }

  void toggleFollowing(int index) async {
    try {
      _profileRepo.toggleFollow(searchProfiles[index].id, token!);
      update();
    } catch (e) {
      log("toggleFollowingError: $e");
    }
  }
}
