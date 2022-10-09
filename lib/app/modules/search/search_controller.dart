import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/models/photo_model.dart';
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

  bool _loadMoreReels = true;
  bool _loadMorePhotos = true;

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

  List<PhotoModel> _photosList = [];
  List<PhotoModel> get photosList => _photosList;
  set photosList(List<PhotoModel> photosList) {
    _photosList = photosList;
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
    getPhotos();
    super.onInit();
  }

  void getFeeds() async {
    loading = true;
    try {
      reelList = await _reelRepo.getFeedsWithAds(profileId!, token!,
          limit: 10, skip: 0);
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
    }
    loading = false;
    _loadMoreReels = true;
  }

  void getPhotos() async {
    loading = true;
    try {
      photosList = await _reelRepo.getPhotosWithoutAds(profileId!, token!,
          limit: 10, skip: 0);
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("getFeeds: $e");
    }
    loading = false;
    _loadMorePhotos = true;
  }

  void getMoreFeed(int currentLength) async {
    loadingMore = true;
    if (_loadMoreReels) {
      try {
        var newList = await _reelRepo.getFeedsWithAds(profileId!, token!,
            limit: 10, skip: currentLength);
        if (newList.isEmpty) {
          loadingMore = false;
          _loadMoreReels = false;
        } else {
          reelList.addAll(newList);
        }
        update();
      } catch (e) {
        showSnackBar(e.toString(), color: Colors.red);
      }
    }
    loadingMore = false;
  }

  void getMorePhotos(int currentLength) async {
    loadingMore = true;
    if (_loadMorePhotos) {
      try {
        var newList = await _reelRepo.getPhotosWithoutAds(profileId!, token!,
            limit: 10, skip: currentLength);
        if (newList.isEmpty) {
          loadingMore = false;
          _loadMorePhotos = false;
        } else {
          photosList.addAll(newList);
        }
        update();
      } catch (e) {
        showSnackBar(e.toString(), color: Colors.red);
        print("getFeeds: $e");
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
