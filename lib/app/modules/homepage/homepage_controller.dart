import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/app/modules/single_feed/single_feed_screen.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';
import '../../../models/comment_model.dart';
import '../../../models/reel_model.dart';
import '../../../repositories/giveaway_repository.dart';
import '../../../repositories/profile_repository.dart';

class HomePageController extends GetxController {
  final _profileRepo = Get.put(ProfileRepository());
  final _reelRepo = Get.put(ReelRepository());
  final _authService = Get.put(AuthService());
  final _giveawayRepo = Get.put(GiveawayRepository());

  String? get token => _authService.token;
  int? get profileId => _authService.profileModel?.id;

  bool loadingMore = false;
  bool _loadMore = true;

  int _secondPageIndex = 0;
  int get secondPageIndex => _secondPageIndex;
  set secondPageIndex(int secondPageIndex) {
    _secondPageIndex = secondPageIndex;
    update();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    update();
  }

  bool _shareLoading = false;
  bool get shareLoading => _shareLoading;
  set shareLoading(bool shareLoading) {
    _shareLoading = shareLoading;
    update();
  }

  bool _loadingPoints = false;
  bool get loadingPoints => _loading;
  set loadingPoints(bool loadingPoints) {
    _loadingPoints = loadingPoints;
    update();
  }

  bool _showLike = false;
  bool get showLike => _showLike;
  set showLike(bool showLike) {
    _showLike = showLike;
    update();
  }

  List<ReelModel> _reelList = [];
  List<ReelModel> get reelList =>
      _reelList.where((element) => !reportList.contains(element.id)).toList();
  set reelList(List<ReelModel> reelList) {
    _reelList = reelList;
    update();
  }

  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([]);
  List<CommentModel> get comments => _comments.value;

  List<int> reportList = [];

  RxnString totalEntryPoints = RxnString("0");

  @override
  void onInit() {
    getFeeds();
    getTotalEntryPoints();
    super.onInit();
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  void getFeeds() async {
    loading = true;
    try {
      reelList = await _reelRepo.getFeedsWithAds(profileId!, token!);
    } catch (e) {
      // showSnackBar(e.toString(), color: Colors.red);
      debugPrint("getFeeds: $e");
    }
    loading = false;
    _loadMore = true;
  }

  void getTotalEntryPoints() async {
    loadingPoints = true;
    try {
      totalEntryPoints.value =
          await _giveawayRepo.getTotalEntryCountByUserId(profileId!, token!);
    } catch (e) {
      // showSnackBar(e.toString(), color: Colors.red);
      debugPrint("getFeeds: $e");
    }
    update();
    loadingPoints = false;
  }

  void getMoreFeed() async {
    loadingMore = true;
    if (_loadMore) {
      try {
        var newList = await _reelRepo.getFeedsWithAds(profileId!, token!,
            limit: 10, skip: reelList.length);
        if (newList.isEmpty) {
          _loadMore = false;
        } else {
          reelList.addAll(newList);
        }
        update();
      } catch (e) {
        // showSnackBar(e.toString(), color: Colors.red);
        debugPrint("getFeeds: $e");
      }
    }
    loadingMore = false;
  }

  void toggleLikeShow() async {
    showLike = true;
    await Future.delayed(
        const Duration(milliseconds: 1000), () => showLike = false);
  }

  void likeToggle(int index, {bool isPhoto = false}) async {
    try {
      bool isLiked = false;
      if (isPhoto) {
        await _reelRepo.photoToggleLike(reelList[index].id, token!);
        isLiked = await _reelRepo.getPhotosLikeFlag(reelList[index].id, token!);
      } else {
        await _reelRepo.toggleLike(reelList[index].id, token!);
        isLiked = await _reelRepo.getLikeFlag(reelList[index].id, token!);
      }
      if (isLiked) {
        toggleLikeShow();
      }
    } catch (e) {
      log("TogglelikeError: $e");
    }
    update();
  }

  void updateManually() async {
    update();
  }

  void signOut() {
    _authService.signOut();
  }

  void toggleFollowing(int id) async {
    try {
      _profileRepo.toggleFollow(id, token!);
      update();
    } catch (e) {
      log("toggleFollowingError: $e");
    }
  }

  void removeReel(int index) {
    _reelList.removeAt(index);
    update();
  }

  void reportReelOrComment(
      String reason, String type, int id, VoidCallback onDone) async {
    try {
      await _reelRepo.reportReelOrComment(type, reason, id, token!);
      onDone();
      // showSnackBar('This reel has been reported to the Admin!');
      // update();
    } catch (e) {
      log("reportReelOrComment: $e");
    }
  }
}
