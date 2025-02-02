import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  bool get loadingPoints => _loading;
  set loadingPoints(bool loadingPoints) {
    update();
  }

  bool _showLike = false;
  bool get showLike => _showLike;
  set showLike(bool showLike) {
    _showLike = showLike;
    update();
  }

  Rx<List<ReelModel>> reelList = Rx<List<ReelModel>>([]);
  // List<ReelModel> get reelList => _reelList.value
  //     .where((element) => !reportList.contains(element.id))
  //     .toList();
  // set reelList(List<ReelModel> reelList) {
  //   _reelList.value = reelList;
  //   update();
  // }

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

  Future<void> getFeeds() async {
    loading = true;
    try {
      reelList(await _reelRepo.getFeedsWithAds(profileId!, token!));
    } catch (e) {
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
            limit: 10, skip: reelList.value.length);
        if (newList.isEmpty) {
          _loadMore = false;
        } else {
          reelList.value.addAll(newList);
        }
        update();
      } catch (e) {
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
        await _reelRepo.photoToggleLike(reelList.value[index].id, token!);
        isLiked =
            await _reelRepo.getPhotosLikeFlag(reelList.value[index].id, token!);
      } else {
        await _reelRepo.toggleLike(reelList.value[index].id, token!);
        isLiked = await _reelRepo.getLikeFlag(reelList.value[index].id, token!);
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
    reelList.value.removeAt(index);
    // reelList.value.removeAt(index);

    update();
  }

  void reportReelOrComment(
      String reason, String type, int id, VoidCallback onDone) async {
    try {
      await _reelRepo.reportReelOrCommentorUser(type, reason, id, token!);
      onDone();
      showSnackBar('The reel has been reported to the admin.');
    } catch (e) {
      log("reportReelOrComment: $e");
    }
  }
}
