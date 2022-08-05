import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/repositories/reel_repository.dart';
import 'package:reel_ro/services/auth_service.dart';
import 'package:reel_ro/utils/snackbar.dart';
import '../../../models/comment_model.dart';
import '../../../models/reel_model.dart';

class HomePageController extends GetxController {
  final _reelRepo = Get.put(ReelRepository());
  final _authService = Get.put(AuthService());

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

  bool _showLike = false;
  bool get showLike => _showLike;
  set showLike(bool showLike) {
    _showLike = showLike;
    update();
  }

  List<ReelModel> _reelList = [];
  List<ReelModel> get reelList => _reelList;
  set reelList(List<ReelModel> reelList) {
    _reelList = reelList;
    update();
  }

  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([
    // CommentModel(
    //     username: "yashvala9",
    //     comment: "comment",
    //     datePublished: "datePublished",
    //     likes: [],
    //     profilePhoto: "profilePhoto",
    //     uid: "1",
    //     id: "1")
  ]);
  List<CommentModel> get comments => _comments.value;

  @override
  void onInit() {
    getFeeds();
    super.onInit();
  }

  void getFeeds() async {
    loading = true;
    try {
      reelList = await _reelRepo.getFeeds(profileId!, token!);
    } catch (e) {
      showSnackBar(e.toString(), color: Colors.red);
      print("getFeeds: $e");
    }
    loading = false;
    _loadMore = true;
  }

  void getMoreFeed() async {
    print('2121 running getMoreFeed');
    print('2121 _loadMore $_loadMore');
    loadingMore = true;
    if (_loadMore) {
      try {
        var newList = await _reelRepo.getFeeds(profileId!, token!,
            limit: 10, skip: reelList.length);
        print('2121 newList.length ${newList.length}');
        if (newList.isEmpty) {
          _loadMore = false;
        } else {
          reelList.addAll(newList);
          print('2121 reelList.length ${reelList.length}');
        }
        update();
      } catch (e) {
        showSnackBar(e.toString(), color: Colors.red);
        print("getFeeds: $e");
      }
    }
    loadingMore = false;
  }

  void toggleLikeShow() async {
    showLike = true;
    await Future.delayed(
        const Duration(milliseconds: 1000), () => showLike = false);
  }

  void likeToggle(int index) async {
    try {
      await _reelRepo.toggleLike(reelList[index].id, token!);
      final isLiked = await _reelRepo.getLikeFlag(reelList[index].id, token!);
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
}
